/mob/living/silicon
	var/list/silicon_verbs_subsystems = list(
		/mob/living/silicon/proc/subsystem_alarm_monitor,
		/mob/living/silicon/proc/subsystem_law_manager
	)

	// Subsystems
	var/obj/nano_module/alarm_monitor = null
	var/obj/nano_module/law_manager = null

/mob/living/silicon/robot/syndicate
	silicon_verbs_subsystems = list(
		/mob/living/silicon/proc/subsystem_law_manager
	)

/mob/living/silicon/proc/subsystem_alarm_monitor()
	set name = "Alarm Monitor"
	set category = "Subystems"

	alarm_monitor.ui_interact(usr, state = self_state)

/mob/living/silicon/proc/subsystem_law_manager()
	set name = "Law Manager"
	set category = "Subystems"

	law_manager.ui_interact(usr, state = self_state)
