
//this is about how long it takes under the server settings i tested to do a full light switchover
#define DURATION_LIGHTING_CHANGE 400
#define DAYTIME_BRIGHTNESS 2

/obj/effect/landmark/day_night_zcontroller
	name = "day night controller"
	icon_state = "x"
	//day night cycle stuff
	var/solar_cycle_start = 0			//deciseconds, calculated using world.time
	var/solar_cycle_duration = 6000		//deciseconds
	var/solar_cycle_offset = 1500		//deciseconds
	var/threshold_dawn = 0.25			//percent
	var/threshold_dusk = 0.75			//percent
	var/light_change_amount = 0.4		//set this to 2 for light changes to be 100% instead of a dawn/dusk period
	var/dusk_threshold_time
	var/dawn_threshold_time
	//var/current_light_level = 9
	var/do_daynight_cycle = 1			//for testing
	var/time_light_update = 0			//deciseconds, calculated using world.time
	var/solar_announcement_status = 0
	//
	var/datum/light_source/ambient/ambient_light
	light_power = 0
	light_range = 255
	light_color = "#ffffff"
	var/duration_light_change = DURATION_LIGHTING_CHANGE

/obj/effect/landmark/day_night_zcontroller/New()
	..()
	//lighting and day/night cycle
	solar_cycle_start = world.time
	var/turf/light_turf = locate(1,1,1)
	ambient_light = new(src, light_turf)

	dusk_threshold_time = solar_cycle_start + (solar_cycle_duration * threshold_dusk)
	dawn_threshold_time = solar_cycle_start + (solar_cycle_duration * threshold_dawn)

	//var/new_brightness = calculate_light_level()
	//set_ambient_light(new_brightness)

/obj/effect/landmark/day_night_zcontroller/Initialize()
	..()
	GLOB.processing_objects.Add(src)
	return INITIALIZE_HINT_NORMAL

/obj/effect/landmark/day_night_zcontroller/process()

	//its a new day
	if(world.time + solar_cycle_offset > solar_cycle_start + solar_cycle_duration)
		solar_cycle_start = world.time
		dusk_threshold_time = solar_cycle_start + (solar_cycle_duration * threshold_dusk) + solar_cycle_offset
		dawn_threshold_time = solar_cycle_start + (solar_cycle_duration * threshold_dawn) + solar_cycle_offset

	//check if we've changed
	var/old_brightness = light_power
	var/new_brightness = calculate_light_level()

	if(new_brightness != old_brightness)
		if(world.time > time_light_update)
			time_light_update = world.time + duration_light_change
			spawn(-1)
				/*var/duskdawn_progress = (daynight_progress - duskdawn_threshold) / (1 - duskdawn_threshold)
				if(is_daytime)
					duskdawn_progress = 1 - duskdawn_progress
				set_ambient_light(duskdawn_progress * daytime_brightness)*/
				set_ambient_light(new_brightness)
				var/adjusted_time = world.time + solar_cycle_offset
				if(solar_announcement_status < 1)
					if(adjusted_time > dawn_threshold_time)
						to_world("<span class='danger'>Dawn is breaking!</span>")
						solar_announcement_status = 1
				else if(solar_announcement_status < 2)
					if(adjusted_time > dusk_threshold_time)
						to_world("<span class='danger'>Dusk is falling!</span>")
						solar_announcement_status = 2

/obj/effect/landmark/day_night_zcontroller/proc/calculate_light_level()
	. = light_power

	//grab our time offset so the server can start eg at dawn or dusk, instead of 00:00 hours every time
	var/adjusted_time = world.time + solar_cycle_offset

	if(adjusted_time > dusk_threshold_time)
		if(light_power < 0.4)
			light_power = 0
		. = max(0, light_power - light_change_amount)
	else if(adjusted_time > dawn_threshold_time)
		light_power = max(0.4, light_power)
		. = min(DAYTIME_BRIGHTNESS, light_power + light_change_amount)

/obj/effect/landmark/day_night_zcontroller/proc/set_ambient_light(var/brightness)
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

/obj/effect/landmark/day_night_zcontroller/proc/get_daynight_time()
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
