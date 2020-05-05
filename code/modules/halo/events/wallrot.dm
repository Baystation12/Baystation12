
/datum/event/ship/wallrot
	title = "Level 5 Biohazard Alert"

/datum/event/ship/wallrot/setup()
	. = ..()
	announceWhen = rand(5,300)
	endWhen = announceWhen + 1
	announce_message = "Harmful fungi detected. [target_ship] hull may be contaminated."

/datum/event/ship/wallrot/start()
	//pick a random turf
	var/turf/simulated/wall/center = get_random_wall()

	// Make sure at least one piece of wall rots!
	center.rot()

	// Have a chance to rot lots of other walls.
	var/max_rot = 5
	if(severity == EVENT_LEVEL_MODERATE)
		max_rot = 20
	var/rotcount = 0
	for(var/turf/simulated/wall/W in range(7, center))
		if(prob(50))
			W.rot()
			rotcount++

			// Only rot up to severity walls
			if(rotcount >= max_rot)
				break
