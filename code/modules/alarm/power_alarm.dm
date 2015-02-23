/datum/alarm_handler/power
	category = "Power"

/datum/alarm_handler/power/notify_listeners(var/datum/alarm/alarm, var/was_raised)
	..()
	var/area/A = alarm.origin
	if(istype(A))
		A.power_alert(was_raised)

/area/proc/power_alert(var/alarming)
