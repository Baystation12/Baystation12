/turf/proc/cultify()
	ChangeTurf(/turf/space)
	return

/turf/simulated/floor/cultify()
	cultify_floor()

/turf/simulated/floor/carpet/cultify()
	return

/turf/simulated/shuttle/floor/cultify()
	cultify_floor()

/turf/simulated/shuttle/floor4/cultify()
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

/turf/unsimulated/floor/cultify()
	cultify_floor()

/turf/unsimulated/wall/cultify()
	cultify_wall()

/turf/proc/cultify_floor()
	if((icon_state != "cult")&&(icon_state != "cult-narsie"))
		name = "engraved floor"
		icon_state = "cult"
		turf_animation('icons/effects/effects.dmi',"cultfloor",0,0,MOB_LAYER-1)

/turf/proc/cultify_wall()
	ChangeTurf(/turf/unsimulated/wall/cult)
	turf_animation('icons/effects/effects.dmi',"cultwall",0,0,MOB_LAYER-1)
