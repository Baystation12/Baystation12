/proc/HasAbove(var/z)
	var/datum/level/L = get_level_from_z(z)
	if (L)
		var/datum/level/L2 = L.connections["[UP]"]
		if (istype(L2))
			return TRUE
	return FALSE

/proc/HasAbove(var/z)
	var/datum/level/L = get_level_from_z(z)
	if (L)
		var/datum/level/L2 = L.connections["[DOWN]"]
		if (istype(L2))
			return TRUE
	return FALSE

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom, var/_method = ZMOVE_PHASE)
	if (!atom)
		return null
	var/datum/level/L = get_level_from_z(atom.z)
	var/datum/level/L2 = L.connections["[UP]"]
	var/vector2/landing_coords = L2.get_landing_point(atom, UP, _method, L)
	var/turf/turf = locate(landing_coords.x, landing_coords.y, L2.z)

	return turf

/proc/GetBelow(var/atom/atom)
	if (!atom)
		return null
	var/datum/level/L = get_level_from_z(atom.z)
	var/datum/level/L2 = L.connections["[DOWN]"]
	var/vector2/landing_coords = L2.get_landing_point(atom, DOWN, _method, L)
	var/turf/turf = locate(landing_coords.x, landing_coords.y, L2.z)

	return turf

/proc/GetConnectedZlevels(z)
	. = list(z)
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

/proc/AreConnectedZLevels(var/zA, var/zB)
	return zA == zB || (zB in GetConnectedZlevels(zA))

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)