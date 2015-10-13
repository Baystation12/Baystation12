/datum/event/meteor_wave
	startWhen		= 5
	endWhen 		= 7
	var/next_meteor = 6
	var/waves = 1
	var/start_side

/datum/event/meteor_wave/setup()
	waves = severity * rand(1,3)
	start_side = pick(cardinal)
	endWhen = worst_case_end()

/datum/event/meteor_wave/announce()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("Meteors have been detected on collision course with the station.", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')
		else
			command_announcement.Announce("The station is now in a meteor shower.", "Meteor Alert")

/datum/event/meteor_wave/tick()
	if(waves && activeFor >= next_meteor)
		var/pick_side = prob(80) ? start_side : (prob(50) ? turn(start_side, 90) : turn(start_side, -90))

		spawn() spawn_meteors(severity * rand(1,2), get_meteors(), pick_side)
		next_meteor += rand(15, 30) / severity
		waves--
		endWhen = worst_case_end()

/datum/event/meteor_wave/proc/worst_case_end()
	return activeFor + ((30 / severity) * waves) + 10

/datum/event/meteor_wave/end()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			command_announcement.Announce("The station has cleared the meteor storm.", "Meteor Alert")
		else
			command_announcement.Announce("The station has cleared the meteor shower", "Meteor Alert")

/datum/event/meteor_wave/proc/get_meteors()
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			return meteors_catastrophic
		if(EVENT_LEVEL_MODERATE)
			return meteors_threatening
		else
			return meteors_normal
