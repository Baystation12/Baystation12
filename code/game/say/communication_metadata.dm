/datum/communication_metadata
	var/mob/observer/virtual/source
	var/range
	var/datum/radio_channel/radio_channel

/datum/communication_metadata/New(var/atom/source, var/range)
	// Deliberate avoidance of ..() to keep weight down
	src.source = source
	src.range = range

/datum/communication_metadata/Destroy()
	source = null
	radio_channel = null
	..()
	return QDEL_HINT_PUTINPOOL

/datum/communication_metadata/full
	var/input
	var/language

/datum/communication_metadata/full/New(var/atom/source, var/range, var/input)
	src.input = input
	language = all_languages["Noise"]
	..()

/datum/communication_metadata/full/proc/Trim()
	input = null
	language = null
	return src

/datum/communication_metadata/proc/get_distance(var/target)
	if(source)
		return get_dist(source, target)
	return world.maxx
