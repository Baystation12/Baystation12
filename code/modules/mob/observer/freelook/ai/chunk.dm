// CAMERA CHUNK
//
// A 16x16 grid of the map with a list of turfs that can be seen, are visible and are dimmed.
// Allows the Eye to stream these chunks and know what it can and cannot see.

/datum/chunk/camera
	var/list/cameras = list()

/datum/chunk/camera/acquireVisibleTurfs(var/list/visible)
	for(var/camera in cameras)
		var/obj/machinery/camera/c = camera

		if(!istype(c))
			cameras -= c
			continue

		if(!c.can_use())
			continue

		var/turf/point = locate(src.x + 8, src.y + 8, src.z)
		if(get_dist(point, c) > 24)
			cameras -= c

		for(var/turf/t in c.can_see())
			visible[t] = t

	for(var/mob/living/silicon/ai/AI in living_mob_list)
		for(var/turf/t in AI.seen_camera_turfs())
			visible[t] = t

// Create a new camera chunk, since the chunks are made as they are needed.

/datum/chunk/camera/New(loc, x, y, z)
	for(var/obj/machinery/camera/c in range(16, locate(x + 8, y + 8, z)))
		if(c.can_use())
			cameras += c
	..()

/mob/living/silicon/proc/provides_camera_vision()
	return 0

/mob/living/silicon/ai/provides_camera_vision()
	return stat != DEAD

/mob/living/silicon/robot/provides_camera_vision()
	return src.camera && src.camera.network.len

/mob/living/silicon/ai/proc/seen_camera_turfs()
	return seen_turfs_in_range(src, world.view)
