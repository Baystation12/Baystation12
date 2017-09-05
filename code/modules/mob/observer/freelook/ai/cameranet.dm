// CAMERA NET
//
// The datum containing all the chunks.

var/datum/visualnet/camera/cameranet_
/proc/cameranet()
	if(!cameranet_)
		cameranet_ = new()
	return cameranet_

/datum/visualnet/camera
	// The cameras on the map, no matter if they work or not.
	var/list/cameras
	chunk_type = /datum/chunk/camera
	valid_source_types = list(/obj/machinery/camera, /mob/living/silicon/ai)

/datum/visualnet/camera/New()
	cameras = list()
	..()

/datum/visualnet/camera/Destroy()
	cameras.Cut()
	. = ..()

/datum/visualnet/camera/add_source(obj/machinery/camera/c)
	if(istype(c))
		if(c in cameras)
			return FALSE
		. = ..(c, c.can_use())
		if(.)
			dd_insertObjectList(cameras, c)
	else if(isAI(c))
		var/mob/living/silicon/AI = c
		return ..(AI, AI.stat != DEAD)

// Add a camera to a chunk.

/datum/visualnet/camera/remove_source(obj/machinery/camera/c)
	if(istype(c) && cameras.Remove(c))
		. = ..(c, c.can_use())
	if(isAI(c))
		var/mob/living/silicon/AI = c
		return ..(AI, AI.stat != DEAD)
