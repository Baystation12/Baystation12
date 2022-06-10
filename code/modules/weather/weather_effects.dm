/obj/abstract/weather_system/proc/get_movement_delay(var/datum/gas_mixture/env, var/travel_dir)

	// It's quiet. Too quiet.
	if(!wind_direction || !base_wind_delay || !travel_dir || !env || env.return_pressure() < MIN_WIND_PRESSURE)
		return 0

	// May the wind be always at your back!
	var/current_wind_strength = round(wind_strength * base_wind_delay)
	if(wind_direction == travel_dir)
		return -(current_wind_strength)
	if(travel_dir & wind_direction)
		return -(round(current_wind_strength * 0.5))

	// Never spit into the wind.
	var/reversed_wind = GLOB.reverse_dir[wind_direction]
	if(wind_direction == reversed_wind)
		return current_wind_strength
	if(travel_dir & reversed_wind)
		return round(current_wind_strength * 0.5)

	return 0

/obj/abstract/weather_system/proc/adjust_temperature(initial_temperature)
	return initial_temperature

/obj/abstract/weather_system/proc/show_weather(var/mob/M)
	var/mob_ref = weakref(M)
	if(mob_shown_weather[mob_ref])
		return FALSE
	var/decl/state/weather/current_weather = weather_system?.current_state
	if(!istype(current_weather))
		return FALSE
	mob_shown_weather[mob_ref] = TRUE
	current_weather.show_to(M, src)
	return TRUE

/obj/abstract/weather_system/proc/lightning_strike()
	set waitfor = FALSE
	animate(lightning_overlay, alpha = 255, time = 2)
	for(var/client/C)
		if(!isliving(C.mob) || C.mob.get_preference_value(/datum/client_preference/play_ambiance) != GLOB.PREF_YES)
			continue
		var/turf/T = get_turf(C.mob)
		if(!(T.z in affecting_zs))
			continue
		sound_to(C.mob, sound('sound/effects/weather/thunder.ogg', repeat = FALSE, wait = 0, volume = 100))
	sleep(3)
	animate(lightning_overlay, alpha = initial(lightning_overlay.alpha), time = 5 SECONDS)
