SUBSYSTEM_DEF(alarm)
	name = "Alarm"
	wait = 2 SECONDS
	priority = SS_PRIORITY_ALARM
	init_order = SS_INIT_ALARM

	var/static/list/datum/alarm/handlers
	var/static/list/current = list()
	var/static/list/active = list()


/datum/controller/subsystem/alarm/stat_entry(msg)
	..("[msg] A:[active.len]")


/datum/controller/subsystem/alarm/Initialize(timeofday)
	handlers = list(atmosphere_alarm, camera_alarm, fire_alarm, motion_alarm, power_alarm)


/datum/controller/subsystem/alarm/fire(resumed, no_mc_tick)
	if (!resumed)
		current = handlers.Copy()
		active.Cut()
	var/datum/alarm_handler/A
	for (var/i = current.len to 1 step -1)
		A = current[i]
		A.process()
		active += A.alarms
		if (MC_TICK_CHECK)
			current.Cut(i)
			return
	current.Cut()


// This pattern permits handler.triggerAlarm() instead of something like SSalarm.handlers[/handler/path]:triggerAlarm()
var/global/datum/alarm_handler/atmosphere/atmosphere_alarm = new
var/global/datum/alarm_handler/camera/camera_alarm = new
var/global/datum/alarm_handler/fire/fire_alarm = new
var/global/datum/alarm_handler/motion/motion_alarm = new
var/global/datum/alarm_handler/power/power_alarm = new
