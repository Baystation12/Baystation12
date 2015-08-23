/obj/effect/landmark/map_data
	name = "Unknown"
	desc = "An unknown location."
	invisibility = 101

	var/height = 1     ///< The number of Z-Levels in the map.
	var/turf/edge_type ///< What the map edge should be formed with. (null = world.turf)

// FOR THE LOVE OF GOD USE THESE.  DO NOT FUCKING SPAGHETTIFY THIS.
// Use the Has*() functions if you ONLY need to check.
// If you need to do something, use Get*().
proc/HasAbove(var/z)
proc/HasBelow(var/z)
// These give either the turf or null.
proc/GetAbove(var/turf/turf)
proc/GetBelow(var/turf/turf)