// CAMERA NET
//
// The datum containing all the chunks.

/datum/visualnet/camera
	// The cameras on the map, no matter if they work or not. Updated in obj/machinery/camera.dm by New() and Destroy().
	var/list/cameras = list()
	var/cameras_unsorted = 1
	chunk_type = /datum/chunk/camera

/datum/visualnet/camera/proc/process_sort()
	if(cameras_unsorted)
		cameras = dd_sortedObjectList(cameras)
		cameras_unsorted = 0

// Removes a camera from a chunk.

/datum/visualnet/camera/proc/removeCamera(obj/machinery/camera/c)
	if(c.can_use())
		majorChunkChange(c, 0)

// Add a camera to a chunk.

/datum/visualnet/camera/proc/addCamera(obj/machinery/camera/c)
	if(c.can_use())
		majorChunkChange(c, 1)

// Used for Cyborg cameras. Since portable cameras can be in ANY chunk.

/datum/visualnet/camera/proc/updatePortableCamera(obj/machinery/camera/c)
	if(c.can_use())
		majorChunkChange(c, 1)
	//else
	//	majorChunkChange(c, 0)

/datum/visualnet/camera/onMajorChunkChange(atom/c, var/choice, var/datum/chunk/camera/chunk)
// Only add actual cameras to the list of cameras
	if(istype(c, /obj/machinery/camera))
		if(choice == 0)
			// Remove the camera.
			chunk.cameras -= c
		else if(choice == 1)
			// You can't have the same camera in the list twice.
			chunk.cameras |= c
