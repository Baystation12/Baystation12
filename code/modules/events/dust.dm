/datum/event/dust
	startWhen	= 10
	endWhen		= 30
	var/prob_norm = 80

/datum/event/dust/announce()
	command_announcement.Announce("The [station_name()] is now passing through a belt of space dust.", "[station_name()] Sensor Array")

/datum/event/dust/start()
	dust_swarm(get_severity())

/datum/event/dust/end()
	command_announcement.Announce("The [station_name()] has now passed through the belt of space dust.", "[station_name()] Sensor Array")

/datum/event/dust/proc/get_severity()
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			return "weak"
		if(EVENT_LEVEL_MODERATE)
			return prob(prob_norm) ? "norm" : "strong"
		if(EVENT_LEVEL_MAJOR)
			return "super"
	return "weak"

/datum/event/dust/overmap
	prob_norm = 0
