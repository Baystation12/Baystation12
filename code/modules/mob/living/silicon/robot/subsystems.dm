var/list/robot_verbs_subsystems = list(
	/mob/living/silicon/robot/proc/subsystem_alarm_monitor
)

/mob/living/silicon/robot/proc/subsystem_alarm_monitor()
	set name = "Alarm Monitor"
	set category = "Robot Subystems"

	alarm_monitor.ui_interact(usr)