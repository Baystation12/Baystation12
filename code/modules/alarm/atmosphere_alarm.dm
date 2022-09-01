/datum/alarm_handler/atmosphere
	category = NETWORK_ALARM_ATMOS

/datum/alarm_handler/atmosphere/triggerAlarm(atom/origin, atom/source, duration = 0, severity = 1)
	..()

/datum/alarm_handler/atmosphere/major_alarms(z_level)
	. = list()
	for(var/datum/alarm/A in ..())
		if(A.max_severity() > 1)
			. += A

/datum/alarm_handler/atmosphere/minor_alarms(z_level)
	. = list()
	for(var/datum/alarm/A in ..())
		if(A.max_severity() == 1)
			. += A
