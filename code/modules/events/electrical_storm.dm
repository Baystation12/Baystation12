/datum/event/electrical_storm
	announceWhen = 0		// Warn them shortly before it begins.
	startWhen = 30
	endWhen = 60			// Set in start()
	var/list/valid_apcs		// Shuffled list of valid APCs.

/datum/event/electrical_storm/announce()
	..()
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			command_announcement.Announce("A minor electrical storm has been detected near the [station_name()]. Please watch out for possible electrical discharges.", "[station_name()] Sensor Array")
		if(EVENT_LEVEL_MODERATE)
			command_announcement.Announce("The [station_name()] is about to pass through an electrical storm. Please secure sensitive electrical equipment until the storm passes.", "[station_name()] Sensor Array", new_sound = GLOB.using_map.electrical_storm_moderate_sound)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Alert. A strong electrical storm has been detected in proximity of the [station_name()]. It is recommended to immediately secure sensitive electrical equipment until the storm passes.", "[station_name()] Sensor Array", new_sound = GLOB.using_map.electrical_storm_major_sound)

/datum/event/electrical_storm/start()
	..()
	valid_apcs = list()
	for(var/obj/machinery/power/apc/A in SSmachines.machinery)
		if(A.z in GLOB.using_map.station_levels)
			valid_apcs.Add(A)
	endWhen = (severity * 60) + startWhen

/datum/event/electrical_storm/tick()
	..()
	if(!valid_apcs.len)
		CRASH("No valid APCs found for electrical storm event! This is likely a bug.")

	var/list/picked_apcs = list()
	for(var/i=0, i< severity*2, i++) // up to 2/4/6 APCs per tick depending on severity
		picked_apcs |= pick(valid_apcs)

	for(var/obj/machinery/power/apc/T in picked_apcs)
		// Main breaker is turned off. Consider this APC protected.
		if(!T.operating)
			continue

		// Decent chance to overload lighting circuit.
		if(prob(3 * severity))
			T.overload_lighting()

		// Relatively small chance to emag the apc as apc_damage event does.
		if(prob(0.2 * severity))
			T.emagged = 1
			T.update_icon()

		if(T.is_critical)
			T.energy_fail(10 * severity)
			continue
		else
			T.energy_fail(10 * severity * rand(severity * 2, severity * 4))

		// Very tiny chance to completely break the APC. Has a check to ensure we don't break critical APCs such as the Engine room, or AI core. Does not occur on Mundane severity.
		if(prob((0.2 * severity) - 0.2))
			T.set_broken()



/datum/event/electrical_storm/end()
	..()
	command_announcement.Announce("The [station_name()] has cleared the electrical storm. Please repair any electrical overloads.", "Electrical Storm Alert")
