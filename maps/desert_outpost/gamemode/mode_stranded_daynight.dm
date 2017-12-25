
/mob/verb/update_lights()
	if(ticker.mode:ambient_light)
		world << "Calling apply_lum()..."
		ticker.mode:ambient_light:apply_lum()

/*
	var/solar_cycle_duration = 6000
	var/threshold_dusk = 0.25
	var/threshold_dawn = 0.75
	var/daytime_brightness = 9
	var/current_light_level = 1
	*/

//this is about how long it takes under the server settings i tested to do a full light switchover
#define DURATION_LIGHTING_CHANGE 200
#define DAYTIME_BRIGHTNESS 2

/datum/game_mode/stranded/proc/process_daynight()

	//its a new day
	if(world.time + solar_cycle_offset > solar_cycle_start + solar_cycle_duration)
		solar_cycle_start = world.time

	//check if we've changed
	var/old_brightness = light_power
	var/new_brightness = calculate_light_level()

	if(new_brightness != old_brightness)
		if(world.time > time_light_update)
			time_light_update = world.time + DURATION_LIGHTING_CHANGE
			spawn(-1)
				/*var/duskdawn_progress = (daynight_progress - duskdawn_threshold) / (1 - duskdawn_threshold)
				if(is_daytime)
					duskdawn_progress = 1 - duskdawn_progress
				set_ambient_light(duskdawn_progress * daytime_brightness)*/
				set_ambient_light(new_brightness)
				if(solar_announcement_status < 1)
					if(world.time + solar_cycle_offset > solar_cycle_start + solar_cycle_duration * threshold_dawn)
						to_world("<span class='danger'>Dawn is breaking!</span>")
						solar_announcement_status = 1
				else if(solar_announcement_status < 2)
					if(world.time + solar_cycle_offset > solar_cycle_start + solar_cycle_duration * threshold_dusk)
						to_world("<span class='danger'>Dusk is falling!</span>")
						solar_announcement_status = 2

/datum/game_mode/stranded/proc/calculate_light_level()
	. = light_power

	//grab our time offset so the server can start eg at dawn or dusk, instead of 00:00 hours every time
	var/adjusted_time = world.time + solar_cycle_offset

	if(adjusted_time > solar_cycle_start + solar_cycle_duration * threshold_dawn)
		light_power = max(0.3, light_power)
		. = min(DAYTIME_BRIGHTNESS, light_power + light_change_amount)
	else if(adjusted_time > solar_cycle_start + (solar_cycle_duration * threshold_dusk))
		if(light_power < 0.3)
			light_power = 0
		. = max(0, light_power - light_change_amount)

/datum/game_mode/stranded/proc/set_ambient_light(var/brightness)
	light_power = brightness

	if(!ambient_light || ambient_light.destroyed == TRUE)
		var/turf/light_turf = locate(1,1,1)
		ambient_light = new(src, light_turf)

	ambient_light.light_power = light_power
	ambient_light.apply_lum()
	if(!light_power)
		//if we're fully dark, this light_source has become invalidated and needs to be recreated
		ambient_light.destroy()
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

#undef DAYTIME_BRIGHTNESS
#undef DURATION_LIGHTING_CHANGE
