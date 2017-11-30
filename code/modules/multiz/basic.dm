GLOBAL_VAR_CONST(HIGHEST_CONNECTABLE_ZLEVEL_INDEX, 17)

// If you add a more comprehensive system, just untick this file.
// WARNING: Only works for up to 17 z-levels!
var/z_levels = 0 // Each bit represents a connection between adjacent levels.  So the first bit means levels 1 and 2 are connected.

// If the height is more than 1, we mark all contained levels as connected.
/obj/effect/landmark/map_data/New()
	..()
	ASSERT(height <= z)
	if(z > GLOB.HIGHEST_CONNECTABLE_ZLEVEL_INDEX)
		CRASH("[log_info_line(src)] - Attempted to connect Z-levels outside the valid range.")
	// Due to the offsets of how connections are stored v.s. how z-levels are indexed, some magic number silliness happened.
	for(var/i = (z - height) to (z - 2))
		z_levels |= (1 << i)

/obj/effect/landmark/map_data/Initialize()
	..()
	return INITIALIZE_HINT_QDEL

// The storage of connections between adjacent levels means some bitwise magic is needed.
/proc/HasAbove(var/z)
	if(z >= world.maxz || z > 16 || z < 1)
		return 0
	return z_levels & (1 << (z - 1))

/proc/HasBelow(var/z)
	if(z > world.maxz || z > 17 || z < 2)
		return 0
	return z_levels & (1 << (z - 2))

// Thankfully, no bitwise magic is needed here.
/proc/GetAbove(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasAbove(turf.z) ? get_step(turf, UP) : null

/proc/GetBelow(var/atom/atom)
	var/turf/turf = get_turf(atom)
	if(!turf)
		return null
	return HasBelow(turf.z) ? get_step(turf, DOWN) : null

#define GET_BELOW_OR_NULL(atom, z) \
	(!(z > world.maxz || z > 17 || z < 2) && z_levels & (1 << (z - 2))) ? get_step(atom, DOWN) : null

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