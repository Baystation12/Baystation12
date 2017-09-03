#define SSMACHINES_PIPENETS      1
#define SSMACHINES_MACHINERY     2
#define SSMACHINES_POWERNETS     3
#define SSMACHINES_POWER_OBJECTS 4

#define START_MACHINE_PROCESSING(machine) ADD_SORTED(SSmachines.machinery, machine, /proc/cmp_name_asc)
#define STOP_MACHINE_PROCESSING(machine) SSmachines.machinery -= machine

SUBSYSTEM_DEF(machines)
	name = "Machines"
	init_order = INIT_ORDER_MACHINES
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/current_step = SSMACHINES_PIPENETS

	var/cost_pipenets      = 0
	var/cost_machinery     = 0
	var/cost_powernets     = 0
	var/cost_power_objects = 0

	var/list/pipenets      = list()
	var/list/machinery     = list()
	var/list/powernets     = list()
	var/list/power_objects = list()

	var/list/current_run = list()

/datum/controller/subsystem/machines/Initialize(timeofday)
	makepowernets()
	fire()
	..()

#define INTERNAL_PROCESS_STEP(this_step, check_resumed, proc_to_call, cost_var, next_step)\
if(current_step == this_step || (check_resumed && !resumed)) {\
	timer = TICK_USAGE_REAL;\
	proc_to_call(resumed);\
	cost_var = MC_AVERAGE(cost_var, TICK_DELTA_TO_MS(TICK_USAGE_REAL - timer));\
	if(state != SS_RUNNING){\
		return;\
	}\
	resumed = 0;\
	current_step = next_step;\
}

/datum/controller/subsystem/machines/fire(resumed = 0)
	var/timer = TICK_USAGE_REAL

	INTERNAL_PROCESS_STEP(SSMACHINES_PIPENETS,TRUE,process_pipenets,cost_pipenets,SSMACHINES_MACHINERY)
	INTERNAL_PROCESS_STEP(SSMACHINES_MACHINERY,FALSE,process_machinery,cost_machinery,SSMACHINES_POWERNETS)
	INTERNAL_PROCESS_STEP(SSMACHINES_POWERNETS,FALSE,process_powernets,cost_powernets,SSMACHINES_POWER_OBJECTS)
	INTERNAL_PROCESS_STEP(SSMACHINES_POWER_OBJECTS,FALSE,process_power_objects,cost_power_objects,SSMACHINES_PIPENETS)

#undef INTERNAL_PROCESS_STEP

// rebuild all power networks from scratch - only called at world creation or by the admin verb
// The above is a lie. Turbolifts also call this proc.
/datum/controller/subsystem/machines/proc/makepowernets()
	for(var/datum/powernet/PN in powernets)
		qdel(PN)
	powernets.Cut()

	for(var/obj/structure/cable/PC in cable_list)
		if(!PC.powernet)
			var/datum/powernet/NewPN = new()
			NewPN.add_cable(PC)
			propagate_network(PC,PC.powernet)

/datum/controller/subsystem/machines/stat_entry(msg)
	msg = list(msg)
	msg += "C:{"
	msg += "PI:[round(cost_pipenets,1)]|"
	msg += "MC:[round(cost_machinery,1)]|"
	msg += "PN:[round(cost_powernets,1)]|"
	msg += "PO:[round(cost_power_objects,1)]"
	msg += "} "
	msg += "PI:[pipenets.len]|"
	msg += "MC:[machinery.len]|"
	msg += "PN:[powernets.len]|"
	msg += "PO:[power_objects.len]|"
	msg += "MC/MS:[round((cost ? machinery.len/cost : 0),0.1)]"
	..(jointext(msg, null))

/datum/controller/subsystem/machines/proc/process_pipenets(resumed = 0)
	var/seconds = wait * 0.1
	if (!resumed)
		src.current_run = pipenets.Copy()
	//cache for sanic speed (lists are references anyways)
	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/pipe_network/PN = current_run[current_run.len]
		current_run.len--
		if(istype(PN) && !QDELETED(PN))
			PN.process(seconds)
		else
			pipenets.Remove(PN)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_machinery(resumed = 0)
	var/seconds = wait * 0.1
	if (!resumed)
		src.current_run = machinery.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/machinery/M = current_run[current_run.len]
		current_run.len--
		if(istype(M) && !QDELETED(M) && !(M.process(seconds) == PROCESS_KILL))
			if(M.use_power)
				M.auto_use_power()
		else
			machinery.Remove(M)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_powernets(resumed = 0)
	var/seconds = wait * 0.1
	if (!resumed)
		src.current_run = powernets.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/datum/powernet/PN = current_run[current_run.len]
		current_run.len--
		if(istype(PN) && !QDELETED(PN))
			PN.reset(seconds)
		else
			powernets.Remove(PN)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/proc/process_power_objects(resumed = 0)
	var/seconds = wait * 0.1
	if (!resumed)
		src.current_run = power_objects.Copy()

	var/list/current_run = src.current_run
	while(current_run.len)
		var/obj/item/I = current_run[current_run.len]
		current_run.len--
		if(!I.pwr_drain(seconds)) // 0 = Process Kill, remove from processing list.
			power_objects.Remove(I)
		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/machines/Recover()
	if (istype(SSmachines.pipenets))
		pipenets = SSmachines.pipenets
	if (istype(SSmachines.machinery))
		machinery = SSmachines.machinery
	if (istype(SSmachines.powernets))
		powernets = SSmachines.powernets
	if (istype(SSmachines.power_objects))
		power_objects = SSmachines.power_objects

#undef SSMACHINES_PIPENETS
#undef SSMACHINES_MACHINERY
#undef SSMACHINES_POWER
#undef SSMACHINES_power_objects
