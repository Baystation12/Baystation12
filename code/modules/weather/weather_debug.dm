/datum/admins/proc/force_kill_weather()
	set name = "Kill Weather For Level"
	set desc = "Destroys a weather system for a level if present."
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/turf/T = get_turf(usr)
	if(!istype(T))
		to_chat(usr, SPAN_WARNING("You need to have a turf to use this verb."))
		return

	var/obj/abstract/weather_system/weather = T.weather || global.weather_by_z["[T.z]"]
	if(!weather)
		to_chat(usr, SPAN_WARNING("This z-level does not have weather."))
		return

	qdel(weather)
	to_chat(usr, SPAN_NOTICE("Weather destroyed for z[T.z]."))

/datum/admins/proc/force_initialize_weather()
	set name = "Initialize Weather For Level"
	set desc = "Creates a weather system for a level if not present."
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/turf/T = get_turf(usr)
	if(!istype(T))
		to_chat(usr, SPAN_WARNING("You need to have a turf to use this verb."))
		return

	var/obj/abstract/weather_system/weather = T.weather || global.weather_by_z["[T.z]"]
	if(weather)
		to_chat(usr, SPAN_WARNING("This z-level already has weather."))
		return
	new /obj/abstract/weather_system(null, T.z)
	to_chat(usr, SPAN_NOTICE("Weather created for z[T.z]."))

/datum/admins/proc/force_weather_state()
	set name = "Force Weather State"
	set desc = "Force the local weather to use a given state."
	set category = "Debug"

	if(!check_rights(R_DEBUG))
		return

	var/turf/T = get_turf(usr)
	if(!istype(T))
		to_chat(usr, SPAN_WARNING("You need to have a turf to use this verb."))
		return

	var/obj/abstract/weather_system/weather = T.weather || global.weather_by_z["[T.z]"]
	if(!weather)
		to_chat(usr, SPAN_WARNING("This z-level has no weather. Use <b>Initialize Weather For Level</b> if you want to create it."))
		return

	var/use_state = input(usr, "Which state do you wish to use?", "Target State") as null|anything in subtypesof(/decl/state/weather)
	if(!use_state || weather != (T.weather || global.weather_by_z["[T.z]"]))
		return
	weather.weather_system.set_state(use_state)
	var/decl/state/weather/weather_state = GET_DECL(use_state)
	to_chat(usr, SPAN_NOTICE("Set weather for z[T.z] to [weather_state.name]."))
