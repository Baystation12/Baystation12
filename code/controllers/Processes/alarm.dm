/datum/controller/process/alarm/setup()
	name = "alarm"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/alarm/doWork()
	alarm_manager.fire()

/datum/controller/process/alarm/getStatName()
	var/list/alarms = alarm_manager.active_alarms()
	return ..()+"([alarms.len])"
