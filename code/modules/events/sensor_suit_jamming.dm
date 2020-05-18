/datum/event/sensor_suit_jamming
	var/suit_sensor_jammer_method/jamming_method

/datum/event/sensor_suit_jamming/setup()
	announceWhen = 10
	endWhen = rand(15, 60) * severity
	switch(severity)
		if(EVENT_LEVEL_MAJOR)
			jamming_method = new/suit_sensor_jammer_method/random/major()
		if(EVENT_LEVEL_MODERATE)
			jamming_method = new/suit_sensor_jammer_method/random/moderate()
		else
			jamming_method = new/suit_sensor_jammer_method/random()

/datum/event/sensor_suit_jamming/announce()
	if(prob(75))
		ion_storm_announcement(affecting_z)

/datum/event/sensor_suit_jamming/start()
	jamming_method.enable()

/datum/event/sensor_suit_jamming/end()
	jamming_method.disable()
	qdel(jamming_method)
	jamming_method = null
