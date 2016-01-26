/mob/living/silicon
	var/register_alarms = 1
	var/datum/nano_module/alarm_monitor/all/alarm_monitor
	var/datum/nano_module/atmos_control/atmos_control
	var/datum/nano_module/crew_monitor/crew_monitor
	var/datum/nano_module/law_manager/law_manager
	var/datum/nano_module/power_monitor/power_monitor
	var/datum/nano_module/rcon/rcon

/mob/living/silicon/ai
	var/datum/nano_module/computer_ntnetmonitor/ntnet_monitor

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
		/mob/living/silicon/proc/subsystem_rcon,
		/mob/living/silicon/ai/proc/subsystem_ntnet_monitor
	)

/mob/living/silicon/robot/syndicate
	register_alarms = 0
	silicon_subsystems = list(/mob/living/silicon/proc/subsystem_law_manager)

/mob/living/silicon/Destroy()
	qdel(alarm_monitor)
	alarm_monitor = null

	qdel(atmos_control)
	atmos_control = null

	qdel(crew_monitor)
	crew_monitor = null

	qdel(law_manager)
	law_manager = null

	qdel(power_monitor)
	power_monitor = null

	qdel(rcon)
	rcon = null

	return ..()

/mob/living/silicon/ai/Destroy()
	qdel(ntnet_monitor)
	ntnet_monitor = null

	return ..()

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
		AH.register_alarm(src, /mob/living/silicon/proc/receive_alarm)
		queued_alarms[AH] = list()	// Makes sure alarms remain listed in consistent order

/mob/living/silicon/ai/init_subsystems()
	..()
	ntnet_monitor = new(src)

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
*	NTNet Monitor	*
********************/
/mob/living/silicon/ai/proc/subsystem_ntnet_monitor()
	set name = "NTNet Monitoring"
	set category = "Subystems"

	ntnet_monitor.ui_interact(usr, state = conscious_state)

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
