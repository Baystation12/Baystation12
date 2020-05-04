
/datum/event/ship/power_failure
	title = "Power storage failure"
	custom_sound = 'sound/AI/poweroff.ogg'

/datum/event/ship/power_failure/setup()
	. = ..()

	announce_message = "Abnormal activity detected in the [target_ship] power system. \
		As a precaution, power storage must be shut down to prevent overloads."

	endWhen = rand(15,30)

/datum/event/ship/power_failure/start()
	for(var/cur_area_type in typesof(target_ship.parent_area_type))
		var/area/cur_area = locate(cur_area_type)
		if(cur_area)
			for(var/obj/machinery/power/smes/S in cur_area)
				S.energy_fail(endWhen)
				if(severity == EVENT_LEVEL_MAJOR)
					S.charge = 0
				S.update_icon()
				S.power_change()

/datum/event/ship/power_failure/end()
	if(severity == EVENT_LEVEL_MAJOR)
		affected_faction.AnnounceUpdate("All SMESs on the [target_ship] have been drained and restarted. \
			We apologize for the inconvenience.", "Power systems nominal", 'sound/AI/poweron.ogg')
	else
		affected_faction.AnnounceUpdate("All SMESs on the [target_ship] have been restarted. \
			We apologize for the inconvenience.", "Power systems nominal", 'sound/AI/poweron.ogg')
