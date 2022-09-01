/atom/proc/is_flooded(lying_mob, absolute)
	return

/atom/proc/water_act(depth)
	clean_blood()

/atom/proc/return_fluid()
	return null

/atom/proc/check_fluid_depth(min)
	return 0

/atom/proc/get_fluid_depth()
	return 0

/atom/proc/CanFluidPass(coming_from)
	return TRUE

/atom/movable/proc/is_fluid_pushable(amt)
	return simulated && !anchored

/atom/movable/is_flooded(lying_mob, absolute)
	var/turf/T = get_turf(src)
	return T.is_flooded(lying_mob)

/atom/proc/submerged(depth)
	if(isnull(depth))
		var/turf/T = get_turf(src)
		if(!istype(T))
			return FALSE
		depth = T.get_fluid_depth()
	if(istype(loc, /mob))
		return depth >= FLUID_SHALLOW
	if(istype(loc, /turf))
		return depth >= 3
	return depth >= FLUID_OVER_MOB_HEAD

/turf/submerged(depth)
	if(isnull(depth))
		depth = get_fluid_depth()
	return depth >= FLUID_OVER_MOB_HEAD

/atom/proc/fluid_update()
	var/turf/T = get_turf(src)
	if(istype(T))
		T.fluid_update()

/atom/movable/update_nearby_tiles(need_rebuild)
	UNLINT(. = ..(need_rebuild))
	fluid_update()
