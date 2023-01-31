/mob/living/silicon
	var/list/silicon_subsystems_by_name = list()
	var/list/silicon_subsystems = list(
		/datum/nano_module/alarm_monitor/all,
		/datum/nano_module/law_manager,
		/datum/nano_module/email_client,
		/datum/nano_module/crew_manifest
	)

/mob/living/silicon/ai/New()
	silicon_subsystems.Cut()
	for(var/subtype in subtypesof(/datum/nano_module))
		var/datum/nano_module/NM = subtype
		if(initial(NM.available_to_ai))
			silicon_subsystems += NM
	..()

/mob/living/silicon/robot/syndicate
	silicon_subsystems = list(
		/datum/nano_module/law_manager,
		/datum/nano_module/email_client
	)

/mob/living/silicon/Destroy()
	for(var/subsystem in silicon_subsystems)
		remove_subsystem(subsystem)
	silicon_subsystems.Cut()
	. = ..()

/mob/living/silicon/proc/init_subsystems()
	for(var/subsystem_type in silicon_subsystems)
		init_subsystem(subsystem_type)

/mob/living/silicon/proc/init_subsystem(subsystem_type)
	var/existing_entry = silicon_subsystems[subsystem_type]
	if(existing_entry && !ispath(existing_entry))
		return FALSE

	var/ui_state = subsystem_type == /datum/nano_module/law_manager ? GLOB.conscious_state : GLOB.self_state
	var/stat_silicon_subsystem/SSS = new(src, subsystem_type, ui_state)
	silicon_subsystems[subsystem_type] = SSS
	silicon_subsystems_by_name[SSS.name] = SSS
	return TRUE

/mob/living/silicon/proc/remove_subsystem(subsystem_type)
	var/stat_silicon_subsystem/SSS = silicon_subsystems[subsystem_type]
	if(!istype(SSS))
		return FALSE

	silicon_subsystems_by_name -= SSS.name
	silicon_subsystems -= subsystem_type
	qdel(SSS)
	return TRUE

/mob/living/silicon/proc/open_subsystem(subsystem_type, mob/given = src)
	var/stat_silicon_subsystem/SSS = silicon_subsystems[subsystem_type]
	if(!istype(SSS))
		return FALSE
	SSS.Click(given)
	return TRUE

/mob/living/silicon/verb/activate_subsystem(datum/silicon_subsystem_name in silicon_subsystems_by_name)
	set name = "Subsystems"
	set desc = "Activates the given subsystem"
	set category = "Silicon Commands"

	var/stat_silicon_subsystem/SSS = silicon_subsystems_by_name[silicon_subsystem_name]
	if(istype(SSS))
		SSS.Click()

/mob/living/silicon/Stat()
	. = ..()
	if(!.)
		return
	if(!length(silicon_subsystems))
		return
	if(!statpanel("Subsystems"))
		return
	for(var/subsystem_type in silicon_subsystems)
		var/stat_silicon_subsystem/SSS = silicon_subsystems[subsystem_type]
		stat(SSS)

/mob/living/silicon/proc/get_subsystem_from_path(subsystem_type)
	var/stat_silicon_subsystem/SSS = silicon_subsystems[subsystem_type]
	if(!istype(SSS))
		return 0
	if(!istype(SSS.subsystem, subsystem_type))
		return 0
	return SSS.subsystem

/stat_silicon_subsystem
	parent_type = /atom/movable
	simulated = FALSE
	var/ui_state
	var/datum/nano_module/subsystem

/stat_silicon_subsystem/New(mob/living/silicon/loc, subsystem_type, ui_state)
	if(!istype(loc))
		CRASH("Unexpected location. Expected /mob/living/silicon, was [loc.type].")
	src.ui_state = ui_state
	subsystem = new subsystem_type(loc)
	name = subsystem.name
	..()

/stat_silicon_subsystem/Destroy()
	qdel(subsystem)
	subsystem = null
	. = ..()

/stat_silicon_subsystem/Click(mob/given = usr)
	if (istype(given))
		subsystem.ui_interact(given, state = ui_state)
	else
		subsystem.ui_interact(usr, state = ui_state)
