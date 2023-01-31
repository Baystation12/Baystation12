#define SSMACHINES_PIPENETS 1
#define SSMACHINES_MACHINERY 2
#define SSMACHINES_POWERNETS 3
#define SSMACHINES_POWER_OBJECTS 4


#define START_PROCESSING_IN_LIST(Datum, List) \
if (Datum.is_processing) {\
	if(Datum.is_processing != "SSmachines.[#List]")\
	{\
		crash_with("Failed to start processing. [log_info_line(Datum)] is already being processed by [Datum.is_processing] but queue attempt occured on SSmachines.[#List]."); \
	}\
} else {\
	Datum.is_processing = "SSmachines.[#List]";\
	SSmachines.List += Datum;\
}

#define STOP_PROCESSING_IN_LIST(Datum, List) \
if(Datum.is_processing) {\
	if(SSmachines.List.Remove(Datum)) {\
		Datum.is_processing = null;\
	} else {\
		crash_with("Failed to stop processing. [log_info_line(Datum)] is being processed by [is_processing] and not found in SSmachines.[#List]"); \
	}\
}

#define START_PROCESSING_PIPENET(Datum) START_PROCESSING_IN_LIST(Datum, pipenets)
#define STOP_PROCESSING_PIPENET(Datum) STOP_PROCESSING_IN_LIST(Datum, pipenets)

#define START_PROCESSING_POWERNET(Datum) START_PROCESSING_IN_LIST(Datum, powernets)
#define STOP_PROCESSING_POWERNET(Datum) STOP_PROCESSING_IN_LIST(Datum, powernets)

#define START_PROCESSING_POWER_OBJECT(Datum) START_PROCESSING_IN_LIST(Datum, power_objects)
#define STOP_PROCESSING_POWER_OBJECT(Datum) STOP_PROCESSING_IN_LIST(Datum, power_objects)


SUBSYSTEM_DEF(machines)
	name = "Machines"
	init_order = SS_INIT_MACHINES
	priority = SS_PRIORITY_MACHINERY
	flags = SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/static/current_step = SSMACHINES_PIPENETS
	var/static/cost_pipenets = 0
	var/static/cost_machinery = 0
	var/static/cost_powernets = 0
	var/static/cost_power_objects = 0
	var/static/list/pipenets = list()
	var/static/list/machinery = list()
	var/static/list/powernets = list()
	var/static/list/power_objects = list()
	var/static/list/processing = list()
	var/static/list/queue = list()


/datum/controller/subsystem/machines/Recover()
	current_step = SSMACHINES_PIPENETS
	queue.Cut()


/datum/controller/subsystem/machines/Initialize(start_uptime)
	makepowernets()
	setup_atmos_machinery(machinery)
	fire(FALSE, TRUE)


/datum/controller/subsystem/machines/fire(resumed, no_mc_tick)
	var/timer
	if (!resumed || current_step == SSMACHINES_PIPENETS)
		timer = world.tick_usage
		process_pipenets(resumed, no_mc_tick)
		cost_pipenets = MC_AVERAGE(cost_pipenets, (world.tick_usage - timer) * world.tick_lag)
		if (state != SS_RUNNING)
			return
		current_step = SSMACHINES_MACHINERY
		resumed = FALSE
	if (current_step == SSMACHINES_MACHINERY)
		timer = world.tick_usage
		process_machinery(resumed, no_mc_tick)
		cost_machinery = MC_AVERAGE(cost_machinery, (world.tick_usage - timer) * world.tick_lag)
		if(state != SS_RUNNING)
			return
		current_step = SSMACHINES_POWERNETS
		resumed = FALSE
	if (current_step == SSMACHINES_POWERNETS)
		timer = world.tick_usage
		process_powernets(resumed, no_mc_tick)
		cost_powernets = MC_AVERAGE(cost_powernets, (world.tick_usage - timer) * world.tick_lag)
		if(state != SS_RUNNING)
			return
		current_step = SSMACHINES_POWER_OBJECTS
		resumed = FALSE
	if (current_step == SSMACHINES_POWER_OBJECTS)
		timer = world.tick_usage
		process_power_objects(resumed, no_mc_tick)
		cost_power_objects = MC_AVERAGE(cost_power_objects, (world.tick_usage - timer) * world.tick_lag)
		if (state != SS_RUNNING)
			return
		current_step = SSMACHINES_PIPENETS


/// Rebuilds power networks from scratch. Called by world initialization and elevators.
/datum/controller/subsystem/machines/proc/makepowernets()
	for(var/datum/powernet/powernet as anything in powernets)
		qdel(powernet)
	powernets.Cut()
	setup_powernets_for_cables(GLOB.cable_list)


/datum/controller/subsystem/machines/proc/setup_powernets_for_cables(list/cables)
	for (var/obj/structure/cable/cable as anything in cables)
		if (cable.powernet)
			continue
		var/datum/powernet/network = new
		network.add_cable(cable)
		propagate_network(cable, cable.powernet)


/datum/controller/subsystem/machines/proc/setup_atmos_machinery(list/machines)
	set background = TRUE
	var/list/atmos_machines = list()
	for (var/obj/machinery/atmospherics/machine in machines)
		atmos_machines += machine
	report_progress("Initializing atmos machinery")
	for (var/obj/machinery/atmospherics/machine as anything in atmos_machines)
		machine.atmos_init()
		CHECK_TICK
	report_progress("Initializing pipe networks")
	for (var/obj/machinery/atmospherics/machine as anything in atmos_machines)
		machine.build_network()
		CHECK_TICK


/datum/controller/subsystem/machines/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Queues: \
		Pipes [length(pipenets)] \
		Machines [length(processing)] \
		Networks [length(powernets)] \
		Objects [length(power_objects)]\n\
		Costs: \
		Pipes [Round(cost_pipenets)] \
		Machines [Round(cost_machinery)] \
		Networks [Round(cost_powernets)] \
		Objects [Round(cost_power_objects)]\n\
		Overall [Roundm(cost ? length(processing) / cost : 0, 0.1)]
	"})


/datum/controller/subsystem/machines/proc/process_pipenets(resumed, no_mc_tick)
	if (!resumed)
		queue = pipenets.Copy()
	var/datum/pipe_network/network
	for (var/i = length(queue) to 1 step -1)
		network = queue[i]
		if (QDELETED(network))
			if (network)
				network.is_processing = null
			pipenets -= network
			continue
		network.Process(wait)
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


/datum/controller/subsystem/machines/proc/process_machinery(resumed, no_mc_tick)
	if (!resumed)
		queue = processing.Copy()
	var/obj/machinery/machine
	for (var/i = length(queue) to 1 step -1)
		machine = queue[i]
		if (QDELETED(machine))
			if (machine)
				machine.is_processing = null
			processing -= machine
			continue
		if (machine.ProcessAll(wait) == PROCESS_KILL)
			processing -= machine
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


/datum/controller/subsystem/machines/proc/process_powernets(resumed, no_mc_tick)
	if (!resumed)
		queue = powernets.Copy()
	var/datum/powernet/network
	for (var/i = length(queue) to 1 step -1)
		network = queue[i]
		if (QDELETED(network))
			if (network)
				network.is_processing = null
			powernets -= network
			continue
		network.reset(wait)
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


/datum/controller/subsystem/machines/proc/process_power_objects(resumed, no_mc_tick)
	if (!resumed)
		queue = power_objects.Copy()
	var/obj/item/item
	for (var/i = length(queue) to 1 step -1)
		item = queue[i]
		if (QDELETED(item))
			if (item)
				item.is_processing = null
			power_objects -= item
			continue
		if (!item.pwr_drain(wait))
			item.is_processing = null
			power_objects -= item
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


#undef SSMACHINES_PIPENETS
#undef SSMACHINES_MACHINERY
#undef SSMACHINES_POWERNETS
#undef SSMACHINES_POWER_OBJECTS
