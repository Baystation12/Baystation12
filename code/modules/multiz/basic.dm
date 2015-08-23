// If you add a more comprehensive system, just untick this file.
// WARNING: Only works for up to 17 z-levels!
var/z_levels = 0 // Each bit represents a connection between adjacent levels.  So the first bit means levels 1 and 2 are connected.

// If the height is more than 1, we mark all contained levels as connected.
/obj/effect/landmark/map_data/New()
	for(var/i = z - 1 to height - 2)
		z_levels |= 1 << i
	del src

HasAbove(z)
	if(z > world.maxz || z > 17 || z < 2)
		return 0
	return z_levels & (1 << (z - 1))

HasBelow(z)
	if(z >= world.maxz || z > 16 || z < 1)
		return 0
	return z_levels & (1 << z)

GetAbove(var/atom/thing)
	var/turf/turf = get_turf(thing)
	if(!istype(turf))
		return null
	return HasBelow(turf.z) ? locate(turf.z, turf.y, turf.z - 1) : null

GetBelow(var/atom/thing)
	var/turf/turf = get_turf(thing)
	if(!istype(turf))
		return null
	return HasBelow(turf.z) ? locate(turf.z, turf.y, turf.z + 1) : null