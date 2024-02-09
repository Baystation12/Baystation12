// If you add a more comprehensive system, just untick this file.
var/global/list/z_levels = list()// Each bit re... haha just kidding this is a list of bools now

// If the height is more than 1, we mark all contained levels as connected.
/obj/landmark/map_data/New(turf/loc, _height)
	..()
	if(!istype(loc)) // Using loc.z is safer when using the maploader and New.
		return
	if(_height)
		height = _height
	for(var/i = (loc.z - height + 1) to (loc.z-1))
		if (length(z_levels) <i)
			LIST_RESIZE(z_levels, i)
		z_levels[i] = TRUE

/obj/landmark/map_data/Initialize()
	..()
	return INITIALIZE_HINT_QDEL

/proc/HasAbove(z)
	if(z >= world.maxz || z < 1 || z > length(z_levels))
		return 0
	return z_levels[z]

/proc/HasBelow(z)
	if(z > world.maxz || z < 2 || (z-1) > length(z_levels))
		return 0
	return z_levels[z-1]

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(atom/atom)
	RETURN_TYPE(/turf)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(atom/atom)
	RETURN_TYPE(/turf)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

/proc/GetConnectedZlevels(z)
	RETURN_TYPE(/list)
	. = list(z)
	for(var/level = z, HasBelow(level), level--)
		. |= level-1
	for(var/level = z, HasAbove(level), level++)
		. |= level+1

/proc/GetConnectedZlevelsSet(z)
	RETURN_TYPE(/list)
	. = list("[z]" = TRUE)
	for(var/level = z, HasBelow(level), level--)
		.["[level-1]"] = TRUE
	for(var/level = z, HasAbove(level), level++)
		.["[level+1]"] = TRUE

/proc/AreConnectedZLevels(zA, zB)
	return zA == zB || (zB in GetConnectedZlevelsSet(zA))

/proc/get_zstep(ref, dir)
	RETURN_TYPE(/turf)
	if(dir == UP)
		. = GetAbove(ref)
	else if (dir == DOWN)
		. = GetBelow(ref)
	else
		. = get_step(ref, dir)
