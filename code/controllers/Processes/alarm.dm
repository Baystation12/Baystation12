// We manually initialize the alarm handlers instead of looping over all existing types
// to make it possible to write: camera.triggerAlarm() rather than alarm_manager.managers[datum/alarm_handler/camera].triggerAlarm() or a variant thereof.
/var/global/datum/alarm_handler/atmosphere/atmosphere_alarm	= new()
/var/global/datum/alarm_handler/camera/camera_alarm			= new()
/var/global/datum/alarm_handler/fire/fire_alarm				= new()
/var/global/datum/alarm_handler/motion/motion_alarm			= new()
/var/global/datum/alarm_handler/power/power_alarm			= new()

// Alarm Manager, the manager for alarms.
var/datum/controller/process/alarm/alarm_manager

/datum/controller/process/alarm
	var/list/datum/alarm/all_handlers

/datum/controller/process/alarm/setup()
	name = "alarm"
	schedule_interval = 20 // every 2 seconds
	all_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, motion_alarm, power_alarm)
	alarm_manager = src

/datum/controller/process/alarm/doWork()
	for(last_object in all_handlers)
		var/datum/alarm_handler/AH = last_object
		AH.process()
		SCHECK

/datum/controller/process/alarm/proc/active_alarms()
	var/list/all_alarms = new
	for(var/datum/alarm_handler/AH in all_handlers)
		var/list/alarms = AH.alarms
		all_alarms += alarms

	return all_alarms

/datum/controller/process/alarm/proc/number_of_active_alarms()
	var/list/alarms = active_alarms()
	return alarms.len

/datum/controller/process/alarm/statProcess()
	..()
	stat(null, "[number_of_active_alarms()] alarm\s")
