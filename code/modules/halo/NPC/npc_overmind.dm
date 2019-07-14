
var/global/datum/npc_overmind/flood/flood_overmind = new

#define REPORT_CONTACT 1
#define REPORT_CONSTRUCT 2
#define REPORT_DECONSTRUCT 3
#define REPORT_RECLAIM_EQUIP 4
#define REPORT_CASUALTY 5
#define REPORT_SUPPORT_TEAM_REQ 6

#define SQUADFORM_SEARCHRANGE 14
#define TASKPOINT_TIMEOUT_DELAY 2 MINUTES
#define SINGLESQUAD_MAXTARGET_HANDLE 3 //How many people should we assume our squad can handle before starting to apply squadsize increases.

#define COMBAT_TROOPS_REQUIRED list(0,5,3,1)
#define CONSTRUCTOR_TROOPS_REQUIRED list(3,2,2,0)
#define DECONSTRUCTOR_TROOPS_REQUIRED list(2,2,3,0)

/datum/npc_report
	var/report_type = REPORT_CONTACT
	var/report_target //Used for REPORT_RECLAIM_EQUIP types
	var/targets_reported //Used for REPORT_CONTACT to determine severity
	var/mob/living/simple_animal/hostile/reporter_mob = null

/datum/npc_report/New(var/type,var/reporter,var/report_obj_target,var/num_targets)
	report_type = type
	reporter_mob = reporter
	if(report_obj_target)
		report_target = report_obj_target
	if(num_targets)
		targets_reported = num_targets

/datum/npc_overmind

	var/overmind_active = 0

	//Typepaths to mob-types of different categories.
	var/constructor_types = list()
	var/combat_types = list()
	var/support_types = list()
	//End Mob-Type categories//

	var/list/reports = list()

	var/list/unsorted_troops = list()
	var/list/constructor_troops = list()
	var/list/combat_troops = list()
	var/list/support_troops = list()
	var/list/other_troops = list()

	var/list/assigned_taskpoints = list() //Overmind should sort this as linkedTaskpoint = ListOfMobs.
	var/list/taskpoints = list() //List of taskpoints available (currently aka Assault markers) format: taskpoint = timecreated

	var/form_squad_searchrange = SQUADFORM_SEARCHRANGE

/datum/npc_overmind/proc/get_taskpoint_assigned(var/mob/m)
	for(var/taskpoint in assigned_taskpoints)
		if(m in assigned_taskpoints[taskpoint])
			return taskpoint
	return null

/datum/npc_overmind/proc/create_taskpoint(var/turf/loc_create)
	var/obj/assault_target = new /obj/effect/landmark/assault_target (loc_create)
	taskpoints[assault_target] = world.time
	return assault_target

/datum/npc_overmind/proc/is_type_list(var/checked_atom,var/list/our_list)
	for(var/type in our_list)
		if(istype(checked_atom,type))
			return 1
	return 0

/datum/npc_overmind/proc/create_taskpoint_assign(var/mob/leader,var/obj/taskpoint,var/task_type,var/severity = 1,var/search_range = form_squad_searchrange)
	var/required_troops = list(0,0,0,0) //constructor,combat,support,other
	switch (task_type)
		if("combat")
			required_troops = COMBAT_TROOPS_REQUIRED
		if("construct")
			required_troops = CONSTRUCTOR_TROOPS_REQUIRED
		if("deconstruct")
			required_troops = DECONSTRUCTOR_TROOPS_REQUIRED

	var/list/inrange_squadmembers = list()
	var/list/chosen_squadmembers = list(leader)
	for(var/mob/m in range(search_range,leader))
		if(m == leader)
			continue
		inrange_squadmembers += m
	inrange_squadmembers &= (constructor_troops + combat_troops + support_troops + other_troops)
	for(var/mob/living/simple_animal/hostile/m in inrange_squadmembers)
		var/is_chosen = 0
		if(required_troops[1] > 0 && is_type_list(m,constructor_types))
			is_chosen = 1
			required_troops[1]--
			world << "CONSTRUCTOR ADDED"
		if(required_troops[2] > 0 && is_type_list(m,combat_types))
			is_chosen = 1
			required_troops[2]--
			world << "COMBAT TYPE ADDED"
		if(required_troops[3] > 0 && is_type_list(m,support_types))
			is_chosen = 1
			required_troops[3]--
			world << "SUPPORT TYPE ADDED"
		if(required_troops[4] > 0)
			is_chosen = 1
			required_troops[4]--
			world << "OTHER TYPE ADDED"
		if(is_chosen)
			chosen_squadmembers += m
			m.target_margin = 1

	assign_taskpoint(taskpoint,chosen_squadmembers)

/datum/npc_overmind/proc/process_reports()
	for(var/datum/npc_report/report in reports)
		world << "REPORT RECIEVED"
		switch(report.report_type)
			if(REPORT_CONTACT)
				world << "REPORT TYPE: CONTACT"
				var/mob_squad = get_taskpoint_assigned(report.reporter_mob)
				if(mob_squad && report.reporter_mob.target_mob) //Only bother trying to retask if our mob has a target.
					world << "HASTARGET AND HAS-SQUAD"
					for(var/mob/living/simple_animal/hostile/m in mob_squad)
						if(!m.target_mob)
							m.target_mob = report.reporter_mob.target_mob
				else if(!mob_squad && report.reporter_mob.target_mob)
					world << "HASTARGET AND NO-SQUAD"
					var/taskpoint = create_taskpoint(report.reporter_mob.target_mob.loc)
					create_taskpoint_assign(report.reporter_mob,taskpoint,"combat",max(1,report.targets_reported/SINGLESQUAD_MAXTARGET_HANDLE))
				reports -= report
				world << "REPORT PROCESSED."
				qdel(report)
			//if(REPORT_CASUALTY)
				//TODO: CASUALTY REPORTING AND SQUAD REINFORCEMENT
			//if(REPORT_DECONSTRUCT)
				//TODO: DECONSTRUCT DISPATCH (Door break-open, weld-smash etc.)
			//if(REPORT_CONSTRUCT)
				//TODO: CONSTRUCTOR DISPATCH CODE
			//if(REPORT_RECLAIM_EQUIP)
				//TODO: EQUIPMENT RECLAMATION.
			//if(REPORT_SUPPORT_TEAM_REQ)
				//TODO: REQUESTING SUPPORT TEAMS.

/datum/npc_overmind/proc/sort_troops()
	for(var/mob/m in unsorted_troops)
		if(m.type in is_type_list(m,constructor_types))
			constructor_troops += m
		if(m.type in is_type_list(m,combat_types))
			combat_troops += m
		if(m.type in is_type_list(m,support_types))
			support_troops += m
		else
			other_troops += m
		unsorted_troops -= m

/datum/npc_overmind/proc/unassign_taskpoint(var/obj/taskpoint)
	var/squad_assigned = assigned_taskpoints[taskpoint]
	assigned_taskpoints -= taskpoint
	for(var/mob/living/simple_animal/hostile/m in squad_assigned)
		m.last_assault_target = m.assault_target
		m.assault_target = null
	return squad_assigned

/datum/npc_overmind/proc/assign_taskpoint(var/taskpoint,var/list/squad)
	assigned_taskpoints[taskpoint] = squad
	for(var/mob/living/simple_animal/hostile/m in squad)
		m.assault_target = taskpoint

/datum/npc_overmind/proc/prune_taskpoints()
	for(var/taskpoint in taskpoints)
		if(!(taskpoint in assigned_taskpoints) || (world.time > taskpoints[taskpoint] + TASKPOINT_TIMEOUT_DELAY))
			if(taskpoint in assigned_taskpoints)
				unassign_taskpoint(taskpoint)
			taskpoints -= taskpoint
			qdel(taskpoint)

/datum/npc_overmind/proc/process()
	sort_troops()
	prune_taskpoints()
	process_reports()
	if(overmind_active == 0)
		GLOB.processing_objects -= src

/datum/npc_overmind/flood
	constructor_types = list(/mob/living/simple_animal/hostile/flood/infestor)
	combat_types = list(/mob/living/simple_animal/hostile/flood/combat_form)
	support_types = list(/mob/living/simple_animal/hostile/flood/infestor,/mob/living/simple_animal/hostile/flood/carrier)

/obj/structure/overmind_controller
	name = "overmind controller"
	var/controlling_overmind = null

/obj/structure/overmind_controller/Initialize()
	controlling_overmind =  flood_overmind
	GLOB.processing_objects += flood_overmind
	flood_overmind.overmind_active = 1
	flood_overmind.reports.Cut() //We're likely activating the overmind here. Cut all previous reports out, they're likely outdated.
	. = ..()

/obj/structure/overmind_controller/Destroy()
	flood_overmind.overmind_active = 0
	. = ..()
