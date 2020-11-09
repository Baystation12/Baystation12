#define STARTUP_STAGE 1
#define MAIN_STAGE 2
#define WIND_DOWN_STAGE 3
#define END_STAGE 4

//Used for all kinds of weather, ex. lavaland ash storms.
SUBSYSTEM_DEF(weather)
	name = "Weather"
	flags = SS_BACKGROUND
	init_order = SS_INIT_WEATHER
	var/list/processing = list()
	var/list/eligible_zlevels = list()
	var/list/next_hit_by_zlevel = list() //Used by barometers to know when the next storm is coming

/datum/controller/subsystem/weather/fire()
	// process active weather
	for(var/V in processing)
		var/datum/weather/W = V
		if(W.aesthetic || W.stage != MAIN_STAGE)
			continue
		for(var/i in GLOB.living_mob_list_)
			var/mob/living/L = i
			if(W.can_weather_act(L))
				W.weather_act(L)

	// start random weather on relevant levels
	for(var/z in eligible_zlevels)
		var/possible_weather = eligible_zlevels[z]
		var/datum/weather/W = pickweight(possible_weather)
		run_weather(W, list(text2num(z)))
		eligible_zlevels -= z
		var/randTime = rand(3000, 6000)
		next_hit_by_zlevel["[z]"] = addtimer(CALLBACK(src, .proc/make_eligible, z, possible_weather), randTime + initial(W.weather_duration_upper), TIMER_UNIQUE|TIMER_STOPPABLE) //Around 5-10 minutes between weathers

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	for(var/V in subtypesof(/datum/weather))
		var/datum/weather/W = V
		var/probability = initial(W.probability)
		var/area/target_area = initial(W.target_area)
		var/z_levels = list()

		//get all exoplanet z-levels that contain an area that matches the target
		var/area/map = locate(/area/overmap)
		for (var/obj/effect/overmap/visitable/sector/exoplanet/O in map)
			if (O.planetary_area && O.planetary_area == target_area)
				z_levels += O.map_z

		// any weather with a probability set may occur at random
		if (probability)
			for(var/z in z_levels)
				LAZYINITLIST(eligible_zlevels["[z]"])
				eligible_zlevels["[z]"][W] = probability
	return ..()

/datum/controller/subsystem/weather/proc/run_weather(datum/weather/weather_datum_type, z_levels)
	if (istext(weather_datum_type))
		for (var/V in subtypesof(/datum/weather))
			var/datum/weather/W = V
			if (initial(W.name) == weather_datum_type)
				weather_datum_type = V
				break
	if (!ispath(weather_datum_type, /datum/weather))
		CRASH("run_weather called with invalid weather_datum_type: [weather_datum_type || "null"]")

	if (isnull(z_levels))
		testing("Z levels var was null, populating...")
		z_levels = list()
		var/area/map = locate(/area/overmap)
		for (var/obj/effect/overmap/visitable/sector/exoplanet/O in map)
			testing("Checking [O.name]")
			if (O.planetary_area && O.planetary_area == weather_datum_type.target_area)
				testing("Adding [O.name]")
				z_levels += O.map_z

	else if (isnum(z_levels))
		z_levels = list(z_levels)
	else if (!islist(z_levels))
		CRASH("run_weather called with invalid z_levels: [z_levels || "null"]")

	var/datum/weather/W = new weather_datum_type(z_levels)
	testing("Running weather: [W] on levels:")
	for (var/z in z_levels)
		testing("[z]")
	W.telegraph()

/datum/controller/subsystem/weather/proc/make_eligible(z, possible_weather)
	eligible_zlevels[z] = possible_weather
	next_hit_by_zlevel["[z]"] = null

/datum/controller/subsystem/weather/proc/get_weather(z, area/active_area)
	var/datum/weather/A
	for(var/V in processing)
		var/datum/weather/W = V
		if((z in W.impacted_z_levels) && W.area_type == active_area.type)
			A = W
			break
	return A
