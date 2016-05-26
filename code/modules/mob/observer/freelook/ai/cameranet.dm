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
	var/list/cameras = list()
	chunk_type = /datum/chunk/camera

/datum/visualnet/camera/New()
	for(var/obj/machinery/camera/c in machines)
		add_source(c, FALSE)
	for(var/mob/living/silicon/ai/AI in mob_list)
		add_source(AI, FALSE)
	..()

/datum/visualnet/camera/Destroy()
	cameras.Cut()
	. = ..()

/datum/visualnet/camera/add_source(obj/machinery/camera/c)
	if(istype(c))
		if(c in cameras)
			return
		. = ..(c, c.can_use())
		if(.)
			var/list/open_networks = c.network - restricted_camera_networks
			if(!open_networks.len)
				return
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
