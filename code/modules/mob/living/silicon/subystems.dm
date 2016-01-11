/mob/living/silicon
	var/register_alarms = 1
	var/obj/nano_module/alarm_monitor/all/alarm_monitor
	var/obj/nano_module/atmos_control/atmos_control
	var/obj/nano_module/crew_monitor/crew_monitor
	var/obj/nano_module/law_manager/law_manager
	var/obj/nano_module/power_monitor/power_monitor
	var/obj/nano_module/rcon/rcon

/mob/living/silicon
	var/list/silicon_subsystems = list(
		/mob/living/silicon/proc/subsystem_alarm_monitor,
		/mob/living/silicon/proc/subsystem_law_manager
	)

/mob/living/silicon/ai
	silicon_subsystems = list(
		/mob/living/silicon/proc/subsystem_alarm_monitor,
		/mob/living/silicon/proc/subsystem_atmos_control,
		/mob/living/silicon/proc/subsystem_crew_monitor,
		/mob/living/silicon/proc/subsystem_law_manager,
		/mob/living/silicon/proc/subsystem_power_monitor,
		/mob/living/silicon/proc/subsystem_rcon
	)

/mob/living/silicon/robot/syndicate
	register_alarms = 0
	silicon_subsystems = list(/mob/living/silicon/proc/subsystem_law_manager)

/mob/living/silicon/proc/init_subsystems()
	alarm_monitor 	= new(src)
	atmos_control 	= new(src)
	crew_monitor 	= new(src)
	law_manager 	= new(src)
	power_monitor	= new(src)
	rcon 			= new(src)

	if(!register_alarms)
		return

	for(var/datum/alarm_handler/AH in alarm_manager.all_handlers)
		AH.register(src, /mob/living/silicon/proc/receive_alarm)
		queued_alarms[AH] = list()	// Makes sure alarms remain listed in consistent order

/********************
*	Alarm Monitor	*
********************/
/mob/living/silicon/proc/subsystem_alarm_monitor()
	set name = "Alarm Monitor"
	set category = "Subystems"

	alarm_monitor.ui_interact(usr, state = self_state)

/********************
*	Atmos Control	*
********************/
/mob/living/silicon/proc/subsystem_atmos_control()
	set category = "Subystems"
	set name = "Atmospherics Control"

	atmos_control.ui_interact(usr, state = self_state)

/********************
*	Crew Monitor	*
********************/
/mob/living/silicon/proc/subsystem_crew_monitor()
	set category = "Subystems"
	set name = "Crew Monitor"

	crew_monitor.ui_interact(usr, state = self_state)

/****************
*	Law Manager	*
****************/
/mob/living/silicon/proc/subsystem_law_manager()
	set name = "Law Manager"
	set category = "Subystems"

	law_manager.ui_interact(usr, state = conscious_state)

/********************
*	Power Monitor	*
********************/
/mob/living/silicon/proc/subsystem_power_monitor()
	set category = "Subystems"
	set name = "Power Monitor"

	power_monitor.ui_interact(usr, state = self_state)

/************
*	RCON	*
************/
/mob/living/silicon/proc/subsystem_rcon()
	set category = "Subystems"
	set name = "RCON"

	rcon.ui_interact(usr, state = self_state)
