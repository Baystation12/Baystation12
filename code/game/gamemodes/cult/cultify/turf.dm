/turf/proc/cultify()
	ChangeTurf(/turf/space)
	return

/turf/simulated/floor/cultify()
	//todo: flooring datum cultify check
	cultify_floor()

/turf/simulated/shuttle/wall/cultify()
	cultify_wall()

/turf/simulated/wall/cultify()
	cultify_wall()

/turf/simulated/wall/cult/cultify()
	return

/turf/unsimulated/wall/cult/cultify()
	return

/turf/unsimulated/beach/cultify()
	return

/turf/unsimulated/wall/cultify()
	cultify_wall()

/turf/simulated/floor/proc/cultify_floor()
	set_flooring(get_flooring_data(/decl/flooring/reinforced/cult))
	GLOB.cult.add_cultiness(CULTINESS_PER_TURF)
	var/image/I = image('icons/effects/effects.dmi', src, "cultfloor", BLOOD_LAYER + 0.1)
	flick_overlay(I, viewers(src, null), 1 SECOND) //Way longer than the actual animation's length, but shorter than the buffer frame at the end. Mostly because Chaoko99 does not feel like doing math.

/turf/proc/cultify_wall()
	var/turf/simulated/wall/wall = src
	if(!istype(wall))
		return
	if(wall.reinf_material)
		ChangeTurf(/turf/simulated/wall/cult/reinf)
	else
		ChangeTurf(/turf/simulated/wall/cult)
	var/image/I = image('icons/effects/effects.dmi', src, "cultwall", BLOOD_LAYER + 0.1)
	flick_overlay(I, viewers(src, null), 1 SECOND) //Way longer than the actual animation's length, but shorter than the buffer frame at the end.
	GLOB.cult.add_cultiness(CULTINESS_PER_TURF)
