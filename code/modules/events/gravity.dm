/datum/event/gravity
	announceWhen = 5

/datum/event/gravity/setup()
	endWhen = rand(15, 60)

/datum/event/gravity/announce()
	command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artificial gravity has been disabled whilst the system reinitializes. Further failures may result in a gravitational collapse and formation of blackholes.", "Gravity Failure")

/datum/event/gravity/start()
	gravity_is_on = 0
	for(var/area/A in world)
		if(A.z in config.station_levels)
			A.gravitychange(gravity_is_on, A)

/datum/event/gravity/end()
	if(!gravity_is_on)
		gravity_is_on = 1

		for(var/area/A in world)
			if(A.z in config.station_levels)
				A.gravitychange(gravity_is_on, A)

		command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.", "Gravity Restored")
