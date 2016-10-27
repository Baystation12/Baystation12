/datum/proximity_trigger/line/do_acquire_relevant_turfs()
	. = list()
	var/center = get_turf(holder)
	if(!center)
		return
	. += center
	for(var/i = 1 to range_)
		center = get_step(center, holder.dir)
		if(!center)
			return
		. += center
