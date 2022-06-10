SUBSYSTEM_DEF(weather)
	name =       "Weather"
	wait =       15 SECONDS
	init_order = SS_INIT_WEATHER
	priority =   SS_PRIORITY_WEATHER
	flags =      SS_BACKGROUND

	var/list/weather_systems = list()
	var/list/processing_systems

/datum/controller/subsystem/weather/UpdateStat()
	..("all systems: [length(weather_systems)], processing systems: [length(processing_systems)]")

/datum/controller/subsystem/weather/Initialize(start_timeofday)
	. = ..()
	for(var/obj/abstract/weather_system/weather AS_ANYTHING in weather_systems)
		weather.init_weather()

/datum/controller/subsystem/weather/fire(resumed)

	if(!resumed)
		processing_systems = weather_systems.Copy()

	var/obj/abstract/weather_system/weather
	while(processing_systems.len)
		weather = processing_systems[processing_systems.len]
		processing_systems.len--
		weather.tick()
		if(MC_TICK_CHECK)
			return
