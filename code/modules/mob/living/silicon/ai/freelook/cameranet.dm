/datum/visibility_network/cameras
	ChunkType = /datum/visibility_chunk/camera

/datum/visibility_network/cameras/getViewpointFromMob(var/mob/currentMob)
	var/mob/living/silicon/robot/currentRobot=currentMob
	if(currentRobot)
		return currentRobot.camera
	return FALSE
	
/datum/visibility_network/cameras/validViewpoint(var/viewpoint)
	var/obj/machinery/camera/c = viewpoint
	if (!c)
		return FALSE
	return c.can_use()