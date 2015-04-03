//meteor storms are much heavier
/datum/event/meteor_wave
	startWhen		= 6
	endWhen			= 33

/datum/event/meteor_wave/setup()
	endWhen = rand(15,30) * 3

/datum/event/meteor_wave/announce()
	command_announcement.Announce("Meteors have been detected on collision course with the station.", "Meteor Alert", new_sound = 'sound/AI/meteors.ogg')

/datum/event/meteor_wave/tick()
	if(IsMultiple(activeFor, 3))
		meteor_wave(rand(2,5))

/datum/event/meteor_wave/end()
	command_announcement.Announce("The station has cleared the meteor storm.", "Meteor Alert")

//
/datum/event/meteor_shower
	startWhen		= 5
	endWhen 		= 7
	var/next_meteor = 6
	var/waves = 1

/datum/event/meteor_shower/setup()
	waves = rand(2,5)

/datum/event/meteor_shower/announce()
	command_announcement.Announce("The station is now in a meteor shower.", "Meteor Alert")

//meteor showers are lighter and more common,
/datum/event/meteor_shower/tick()
	if(activeFor >= next_meteor)
		meteor_wave(rand(1,4))
		next_meteor += rand(20,100)
		waves--
		if(waves <= 0)
			endWhen = activeFor + 1
		else
			endWhen = next_meteor + 1

/datum/event/meteor_shower/end()
	command_announcement.Announce("The station has cleared the meteor shower", "Meteor Alert")
