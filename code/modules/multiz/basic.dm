//These Has* procs return true/false if there is a connected level in the specified direction
/proc/HasAbove(var/z)
	var/datum/level/L = get_level_from_z(z)
	if (L)
		var/datum/level/L2 = L.connections["[UP]"]
		if (istype(L2))
			return TRUE
	return FALSE

/proc/HasBelow(var/z)
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
	if (!L)
		return null
	var/datum/level/L2 = L.connections["[UP]"]
	if (!L2)
		return null
	var/vector2/landing_coords = L2.get_landing_point(atom, UP, _method, L)
	var/turf/turf = locate(landing_coords.x, landing_coords.y, L2.z)

	return turf

/proc/GetBelow(var/atom/atom, var/_method = ZMOVE_PHASE)
	if (!atom)
		return null
	var/datum/level/L = get_level_from_z(atom.z)
	if (!L)
		return null
	var/datum/level/L2 = L.connections["[UP]"]
	if (!L2)
		return null
	var/vector2/landing_coords = L2.get_landing_point(atom, DOWN, _method, L)
	var/turf/turf = locate(landing_coords.x, landing_coords.y, L2.z)

	return turf

/proc/GetConnectedZlevels(z)
	var/datum/scene/S = get_scene_from_z(z)
	if (S)
		return S.level_numbers
	else
		return list(z)

/proc/AreConnectedZLevels(var/zA, var/zB)
	if (zA == zB)
		return TRUE
	var/datum/scene/S1 = get_scene_from_z(zA)
	var/datum/scene/S2 = get_scene_from_z(zB)
	if (S1 == S2)
		return TRUE
	return FALSE

/proc/get_zstep(ref, dir)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)