/atom/proc/cultify()
	return

/turf/simulated/floor/cultify()
	//todo: flooring datum cultify check //I asked how this would be done, but nobody told me. Here's a lazy ass check instead.
	if(icon_state == "cult" || icon_state == "cult-narsie")
		return
	cultify_floor()

/turf/simulated/shuttle/wall/cultify()
	cultify_wall()

/turf/simulated/wall/cultify()
	cultify_wall()

/turf/simulated/wall/cult/cultify()
	play_cultify_animation() //Reduces a little overhead produced by changeturf.
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
	play_cultify_animation()

/turf/proc/cultify_wall()
	var/turf/simulated/wall/wall = src
	if(!istype(wall))
		return
	if(wall.reinf_material)
		ChangeTurf(/turf/simulated/wall/cult/reinf)
	else
		ChangeTurf(/turf/simulated/wall/cult)
	GLOB.cult.add_cultiness(CULTINESS_PER_TURF)
	play_cultify_animation()


/atom/proc/play_cultify_animation()
//Creation animation.
	var/image/I = image('icons/effects/effects.dmi', src, "cult[iswall(src) ? "wall" : "floor"]", BLOOD_LAYER + 0.1) //There aren't any animations for cultification of other types, so this rather rigid thing should be okay.
	var/list/viewing = list()

	for (var/mob/M in viewers(src))
		if (M.client)
			viewing |= M.client

	flick_overlay(I, viewing, 1 SECOND) //Way longer than the actual animation's length, but shorter than the buffer frame at the end.
