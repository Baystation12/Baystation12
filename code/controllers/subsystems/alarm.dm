// We manually initialize the alarm handlers instead of looping over all existing types
// to make it possible to write: camera.triggerAlarm() rather than SSalarm.managers[datum/alarm_handler/camera].triggerAlarm() or a variant thereof.
/var/global/datum/alarm_handler/atmosphere/atmosphere_alarm	= new()
/var/global/datum/alarm_handler/camera/camera_alarm			= new()
/var/global/datum/alarm_handler/fire/fire_alarm				= new()
/var/global/datum/alarm_handler/motion/motion_alarm			= new()
/var/global/datum/alarm_handler/power/power_alarm			= new()

SUBSYSTEM_DEF(alarm)
	name = "Alarm"
	wait = 2 SECONDS
	priority = SS_PRIORITY_ALARM
	init_order = SS_INIT_ALARM
	var/list/datum/alarm/all_handlers
	var/tmp/list/current = list()
	var/tmp/list/active_alarm_cache = list()

/datum/controller/subsystem/alarm/Initialize()
	all_handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, motion_alarm, power_alarm)
	. = ..()

/datum/controller/subsystem/alarm/fire(resumed = FALSE)
	if (!resumed)
		current = all_handlers.Copy()
		active_alarm_cache.Cut()

	while (current.len)
		var/datum/alarm_handler/AH = current[current.len]
		current.len--

		AH.process()

		active_alarm_cache += AH.alarms

		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/alarm/proc/active_alarms()
	return active_alarm_cache.Copy()

/datum/controller/subsystem/alarm/proc/number_of_active_alarms()
	return active_alarm_cache.len

/datum/controller/subsystem/alarm/stat_entry()
	..("[number_of_active_alarms()] alarm\s")
