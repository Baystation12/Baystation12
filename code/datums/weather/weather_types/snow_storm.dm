/datum/weather/snow_storm
	name = "snow storm"
	desc = "Harsh snowstorms roam the topside of this arctic planet, burying any area unfortunate enough to be in its path."
	probability = 90

	telegraph_message = "<span class='warning'>Drifting particles of snow begin to dust the surrounding area..</span>"
	telegraph_duration = 650
	telegraph_overlay = "light_snow"
	//telegraph_sound = 'sound/weather/snowstorm/outside/wind_incoming.ogg'

	weather_message = "<span class='userdanger'><i>Harsh winds pick up as dense snow begins to fall from the sky! Seek shelter!</i></span>"
	weather_overlay = "snow_storm"
	weather_duration_lower = 2100
	weather_duration_upper = 2500

	end_duration = 100
	end_message = "<span class='boldannounce'>The snowfall dies down, it should be safe to go outside again.</span>"

	area_type = /area
	protect_indoors = TRUE
	target_area = /area/exoplanet/snow

	immunity_type = "snow"

	barometer_predictable = TRUE

	var/datum/looping_sound/active_outside_snow_storm/sound_ao = new(list(), FALSE)
	var/datum/looping_sound/active_inside_snow_storm/sound_ai = new(list(), FALSE)
	var/datum/looping_sound/weak_outside_snow_storm/sound_wo = new(list(), FALSE)
	// var/datum/looping_sound/weak_inside_snow_storm/sound_wi = new(list(), FALSE, TRUE)

//TODO: make snowstorms just lower the overall temp of an area
// /datum/weather/snow_storm/weather_act(mob/living/L)
// 	L.adjust_bodytemperature(-rand(5,15))

/datum/weather/snow_storm/telegraph()
	. = ..()
	var/list/inside_areas = list()
	var/list/outside_areas = list()
	var/list/eligible_areas = list()

	var/z_levels = list()
	for (var/z in impacted_z_levels)
		z_levels += z
	for (var/area/A in world)
		if(A.z in z_levels)
			eligible_areas += A
	for(var/area/A in eligible_areas)
		if(A && A.planetary_surface)
			outside_areas += A
		else
			inside_areas += A
		CHECK_TICK


	sound_ao.output_atoms = outside_areas
	sound_ai.output_atoms = inside_areas
	sound_wo.output_atoms = outside_areas
	// sound_wi.output_atoms = inside_areas

	sound_wo.start()
	// sound_wi.start()

/datum/weather/snow_storm/start()
	. = ..()
	testing("Start")
	sound_wo.stop()
	// sound_wi.stop()

	sound_ao.start()
	sound_ai.start()

/datum/weather/snow_storm/wind_down()
	. = ..()
	testing("Wind down")
	sound_ao.stop()
	sound_ai.stop()

	// sound_wo.start()
	// sound_wi.start()

/datum/weather/snow_storm/end()
	. = ..()
	testing("End")
	// sound_wo.stop()
	// sound_wi.stop()