/* /var/global/datum/alarm_handler/atmosphere_alarm	= new()*/
/var/global/datum/alarm_handler/camera_alarm		= new()
/* /var/global/datum/alarm_handler/fire_alarm		= new()*/
/var/global/datum/alarm_handler/motion_alarm		= new()
/* /var/global/datum/alarm_handler/power_alarm			= new() */

/datum/subsystem/alarm
	name = "Alarm"
	var/list/datum/alarm/all_handlers

/datum/subsystem/alarm/New()
	all_handlers = list(camera_alarm)

/datum/subsystem/alarm/stat_entry()
	stat(null,"Alarm-[master_controller.alarms_cost]\t# [active_alarms()]")

/datum/subsystem/alarm/fire()
	for(var/datum/alarm_handler/AH in all_handlers)
		AH.process()

/datum/subsystem/alarm/proc/active_alarms()
	var/total = 0
	for(var/datum/alarm_handler/AH in all_handlers)
		var/list/alarms = AH.alarms
		total += alarms.len

	return total
