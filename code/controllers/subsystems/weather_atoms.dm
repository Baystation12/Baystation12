SUBSYSTEM_DEF(weather_atoms)
	name     = "Weather Atoms"
	wait     = 2 SECONDS
	priority = SS_PRIORITY_WEATHER
	flags    = SS_NO_INIT
	var/list/weather_atoms = list()
	var/list/processing_atoms

	// Predeclared vars for processing.
	var/atom/atom
	var/obj/abstract/weather_system/weather
	var/singleton/state/weather/weather_state

/datum/controller/subsystem/weather_atoms/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("A:[length(weather_atoms)]")

/datum/controller/subsystem/weather_atoms/fire(resumed = 0)
	if(!resumed)
		processing_atoms = weather_atoms.Copy()

	atom          = null
	weather       = null
	weather_state = null

	var/i = 0
	while(i < length(processing_atoms))
		i++
		atom = processing_atoms[i]

		// Atom is null or doesn't exist, remove it from processing.
		if(QDELETED(atom))
			weather_atoms -= atom
			continue

		// If weather does not exist, we don't care.
		weather = atom.get_affecting_weather()
		weather_state = weather?.weather_system?.current_state
		if(!istype(weather_state))
			continue

		// Not outside, or not on a turf with a Z- weather is not relevant.
		if(!atom.z || !atom.is_outside())
			continue

		// Process the atom and return early if needed.
		if(atom.process_weather(weather, weather_state) == PROCESS_KILL)
			weather_atoms -= atom
		if (MC_TICK_CHECK)
			processing_atoms.Cut(1, i+1)
			return

	processing_atoms.Cut()

/atom/proc/process_weather(obj/abstract/weather_system/weather, singleton/state/weather/weather_state)
	return PROCESS_KILL
