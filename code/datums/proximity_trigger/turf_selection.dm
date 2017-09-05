/decl/turf_selection/proc/get_turfs(var/atom/origin, var/range)
	return list()

/decl/turf_selection/line/get_turfs(var/atom/origin, var/range)
	. = list()
	var/center = get_turf(origin)
	if(!center)
		return
	for(var/i = 0 to range)
		center = get_step(center, origin.dir)
		if(!center) // Reached the end of the world most likely
			return
		. += center

/decl/turf_selection/square/get_turfs(var/atom/origin, var/range)
	. = list()
	var/center = get_turf(origin)
	if(!center)
		return
	for(var/turf/T in trange(range, center))
		. += T
