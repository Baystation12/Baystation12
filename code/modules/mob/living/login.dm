
/mob/living/Login()
	..()
	//Mind updates
	mind_initialize()	//updates the mind (or creates and initializes one if one doesn't exist)
	mind.active = 1		//indicates that the mind is currently synced with a client
	//If they're SSD, remove it so they can wake back up.
	update_antag_icons(mind)

	// Clear our cosmetic/sound weather cooldowns.
	var/obj/abstract/weather_system/weather = get_affecting_weather()

	var/mob_ref = weakref(src)
	if(istype(weather))
		weather.mob_shown_weather -=     mob_ref
		weather.mob_shown_wind -=        mob_ref
	global.current_mob_ambience -= mob_ref

	return .
