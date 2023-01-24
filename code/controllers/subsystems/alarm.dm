SUBSYSTEM_DEF(alarm)
	name = "Alarm"
	wait = 2 SECONDS
	priority = SS_PRIORITY_ALARM
	init_order = SS_INIT_ALARM
	var/static/list/datum/alarm_handler/alarm_handlers
	var/static/list/datum/alarm_handler/queue = list()
	var/static/list/datum/alarm/active_alarms = list()


/datum/controller/subsystem/alarm/Initialize(start_uptime)
	alarm_handlers = list(
		GLOB.atmosphere_alarm,
		GLOB.camera_alarm,
		GLOB.fire_alarm,
		GLOB.motion_alarm,
		GLOB.power_alarm
	)


/datum/controller/subsystem/alarm/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Alarms: [length(active_alarms)]")


/datum/controller/subsystem/alarm/fire(resumed, no_mc_tick)
	if (!resumed)
		active_alarms.Cut()
		queue = alarm_handlers.Copy()
		if (!length(queue))
			return
	var/cut_until = 1
	for (var/datum/alarm_handler/alarm_handler as anything in queue)
		++cut_until
		alarm_handler.process()
		active_alarms += alarm_handler.alarms
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()


GLOBAL_DATUM_INIT(atmosphere_alarm, /datum/alarm_handler/atmosphere, new)
GLOBAL_DATUM_INIT(camera_alarm, /datum/alarm_handler/camera, new)
GLOBAL_DATUM_INIT(fire_alarm, /datum/alarm_handler/fire, new)
GLOBAL_DATUM_INIT(motion_alarm, /datum/alarm_handler/motion, new)
GLOBAL_DATUM_INIT(power_alarm, /datum/alarm_handler/power, new)
