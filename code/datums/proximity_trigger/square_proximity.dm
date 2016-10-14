/datum/proximity_trigger/square/do_acquire_relevant_turfs()
	. = list()
	var/center = get_turf(holder)
	if(!center)
		return
	for(var/turf/T in trange(range_, center))
		. += T
