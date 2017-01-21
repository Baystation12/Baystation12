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
	cult.add_cultiness(CULTINESS_PER_TURF)

/turf/proc/cultify_wall()
	ChangeTurf(/turf/simulated/wall/cult)
	cult.add_cultiness(CULTINESS_PER_TURF)