/datum/event/power_surge
	announceWhen = 5

/datum/event/power_surge/setup()
	endWhen = rand(120, 300)

/datum/event/power_surge/announce()
	command_announcement.Announce("Energy readings indicate a minor shift in engine crystalline hyperstructure. Closer monitoring of crystal stability and power output is recommended.", "[location_name()] Supermatter Monitoring System", zlevels = affecting_z)

/datum/event/power_surge/start()
	for (var/obj/machinery/power/supermatter/S in SSmachines.machinery)
		if (!(S.z in affecting_z))
			return
		S.reaction_power_modifier += 0.2
		S.radiation_release_modifier += 0.2
		S.thermal_release_modifier += 1500

/datum/event/power_surge/end()
	for (var/obj/machinery/power/supermatter/S in SSmachines.machinery)
		if (!(S.z in affecting_z))
			return
		S.reaction_power_modifier = initial(S.reaction_power_modifier)
		S.radiation_release_modifier = initial(S.radiation_release_modifier)
		S.thermal_release_modifier = initial(S.thermal_release_modifier)
		command_announcement.Announce("Engine crystalline hyperstructure shift has now dissipated. Thank you for your patience.", "[location_name()] Supermatter Monitoring System", zlevels = affecting_z)
