// Returns the atom sitting on the turf.
// For example, using this on a disk, which is in a bag, on a mob, will return the mob because it's on the turf.
/proc/get_atom_on_turf(var/atom/movable/M)
	var/atom/mloc = M
	while(mloc && mloc.loc && !istype(mloc.loc, /turf/))
		mloc = mloc.loc
	return mloc

/proc/iswall(turf/T)
	return (istype(T, /turf/simulated/wall) || istype(T, /turf/unsimulated/wall) || istype(T, /turf/simulated/shuttle/wall))

/proc/isfloor(turf/T)
	return (istype(T, /turf/simulated/floor) || istype(T, /turf/unsimulated/floor))

/proc/turf_clear(turf/T)
	for(var/atom/A in T)
		if(A.simulated)
			return 0
	return 1

// Picks a turf without a mob from the given list of turfs, if one exists.
// If no such turf exists, picks any random turf from the given list of turfs.
/proc/pick_mobless_turf_if_exists(var/list/start_turfs)
	if(!start_turfs.len)
		return null

	var/list/available_turfs = list()
	for(var/start_turf in start_turfs)
		var/mob/M = locate() in start_turf
		if(!M)
			available_turfs += start_turf
	if(!available_turfs.len)
		available_turfs = start_turfs
	return pick(available_turfs)

/proc/get_random_turf_in_range(var/atom/origin, var/outer_range, var/inner_range)
	origin = get_turf(origin)
	if(!origin)
		return
	var/list/turfs = list()
	for(var/turf/T in orange(origin, outer_range))
		if(!(T.z in using_map.sealed_levels)) // Picking a turf outside the map edge isn't recommended
			if(T.x >= world.maxx-TRANSITIONEDGE || T.x <= TRANSITIONEDGE)	continue
			if(T.y >= world.maxy-TRANSITIONEDGE || T.y <= TRANSITIONEDGE)	continue
		if(!inner_range || get_dist(origin, T) >= inner_range)
			turfs += T
	if(turfs.len)
		return pick(turfs)

/proc/screen_loc2turf(text, turf/origin)
	if(!origin)
		return null
	var/tZ = splittext(text, ",")
	var/tX = splittext(tZ[1], "-")
	var/tY = text2num(tX[2])
	tX = splittext(tZ[2], "-")
	tX = text2num(tX[2])
	tZ = origin.z
	tX = max(1, min(origin.x + 7 - tX, world.maxx))
	tY = max(1, min(origin.y + 7 - tY, world.maxy))
	return locate(tX, tY, tZ)

/*
	Predicate helpers
*/

/proc/turf_contains_dense_objects(var/turf/T)
	return T.contains_dense_objects()

/proc/not_turf_contains_dense_objects(var/turf/T)
	return !turf_contains_dense_objects(T)

/proc/is_station_turf(var/turf/T)
	return T && isStationLevel(T.z)

/proc/IsTurfAtmosUnsafe(var/turf/T)
	if(istype(T, /turf/space)) // Space tiles
		return "Spawn location is open to space."
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return "Spawn location lacks atmosphere."
	return get_atmosphere_issues(air, 1)

/proc/IsTurfAtmosSafe(var/turf/T)
	return !IsTurfAtmosUnsafe(T)

/proc/is_below_sound_pressure(var/turf/T)
	var/datum/gas_mixture/environment = T ? T.return_air() : null
	var/pressure =  environment ? environment.return_pressure() : 0
	if(pressure < SOUND_MINIMUM_PRESSURE)
		return TRUE
	return FALSE
