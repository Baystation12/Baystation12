/datum/alarm_handler/fire
	category = NETWORK_ALARM_FIRE

/datum/alarm_handler/fire/on_alarm_change(datum/alarm/alarm, was_raised)
	var/area/A = alarm.origin
	if(istype(A))
		if(was_raised)
			A.fire_alert()
		else
			A.fire_reset()
	..()
