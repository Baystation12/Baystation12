SUBSYSTEM_DEF(alarm)
	name = "Alarm"
	wait = 2 SECONDS
	priority = SS_PRIORITY_ALARM
	init_order = SS_INIT_ALARM
	var/static/tmp/list/datum/alarm_handler/handlers
	var/static/tmp/list/current = list()
	var/static/tmp/list/active = list()


/datum/controller/subsystem/alarm/Initialize(start_uptime)
	handlers = list(
		GLOB.atmosphere_alarm,
		GLOB.camera_alarm,
		GLOB.fire_alarm,
		GLOB.motion_alarm,
		GLOB.power_alarm
	)


/datum/controller/subsystem/alarm/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Alarms: [active.len]")


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


GLOBAL_DATUM_INIT(atmosphere_alarm, /datum/alarm_handler/atmosphere, new)
GLOBAL_DATUM_INIT(camera_alarm, /datum/alarm_handler/camera, new)
GLOBAL_DATUM_INIT(fire_alarm, /datum/alarm_handler/fire, new)
GLOBAL_DATUM_INIT(motion_alarm, /datum/alarm_handler/motion, new)
GLOBAL_DATUM_INIT(power_alarm, /datum/alarm_handler/power, new)
