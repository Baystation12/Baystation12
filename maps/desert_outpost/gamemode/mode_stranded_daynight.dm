
/datum/game_mode/stranded/proc/process_daynight()

	var/phase_duration = is_daytime ? duration_day : duration_night
	var/daynight_progress = 1 - (time_lightchange - world.time) / phase_duration
	daynight_progress = max(daynight_progress, 0)
	daynight_progress = min(daynight_progress, 1)

	var/duskdawn_threshold = is_daytime ? threshold_dusk : threshold_dawn
	if(daynight_progress > duskdawn_threshold)
		var/updated = 0
		if(is_daytime && current_light_level > dusk_brightness)
			current_light_level = dusk_brightness
			to_world("<span class='danger'>It is now dusk!</span>")
			updated = 1
		else if(!is_daytime && current_light_level < dawn_brightness)
			current_light_level = dawn_brightness
			to_world("<span class='danger'>It is now dawn!</span>")
			updated = 1
		if(daynight_progress >= 1)
			time_lightchange = world.time + (is_daytime ? duration_night : duration_day)
			//
			is_daytime = !is_daytime
			if(is_daytime)
				current_light_level = daytime_brightness
			else
				current_light_level = 0
			updated = 1
			to_world("<span class='danger'>It is now [is_daytime ? "daytime" : "nighttime"]!</span>")

		if(updated)
			updated = 0
			spawn(-1)
				/*var/duskdawn_progress = (daynight_progress - duskdawn_threshold) / (1 - duskdawn_threshold)
				if(is_daytime)
					duskdawn_progress = 1 - duskdawn_progress
				set_ambient_light(duskdawn_progress * daytime_brightness)*/
				set_ambient_light(current_light_level)

/datum/game_mode/stranded/proc/set_ambient_light(var/brightness)
	light_power = brightness
	if(!ambient_light)
		var/turf/T = locate(1,1,1)
		ambient_light = new(src,T)
	ambient_light.update()

	//destroy the old light if it is fully dark
	if(!brightness)
		ambient_light = null

/datum/game_mode/stranded/proc/get_daynight_time()
	/*if(is_daytime)
		return time2text(daynight_start)
	return time2text(daynight_start + duration_day)*/
/*
	if(!roundstart_hour) roundstart_hour = pick(2,7,12,17)
	return timeshift ? time2text(time+(36000*roundstart_hour), "hh:mm") : time2text(time, "hh:mm")
	*/
	return
