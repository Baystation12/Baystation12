/datum/alarm_handler/atmosphere
	category = NETWORK_ALARM_ATMOS

/datum/alarm_handler/atmosphere/triggerAlarm(var/atom/origin, var/atom/source, var/duration = 0, var/severity = 1)
	..()

/datum/alarm_handler/atmosphere/major_alarms()
	. = list()
	for(var/datum/alarm/A in alarms)
		if(A.max_severity() > 1)
			. += A
	return .

/datum/alarm_handler/atmosphere/minor_alarms()
	. = list()
	for(var/datum/alarm/A in alarms)
		if(A.max_severity() == 1)
			. += A
	return .
