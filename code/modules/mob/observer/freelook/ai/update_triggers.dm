#define BORG_CAMERA_BUFFER 30

// ROBOT MOVEMENT

// Update the portable camera everytime the Robot moves.
// This might be laggy, comment it out if there are problems.
/mob/living/silicon/var/updating = 0

/mob/living/silicon/robot/Move()
	var/oldLoc = src.loc
	. = ..()
	if(.)
		if(provides_camera_vision())
			if(!updating)
				updating = 1
				spawn(BORG_CAMERA_BUFFER)
					if(oldLoc != src.loc)
						cameranet.updatePortableCamera(src.camera)
					updating = 0

/mob/living/silicon/AI/Move()
	var/oldLoc = src.loc
	. = ..()
	if(.)
		if(provides_camera_vision())
			if(!updating)
				updating = 1
				spawn(BORG_CAMERA_BUFFER)
					if(oldLoc != src.loc)
						cameranet.updateVisibility(oldLoc, 0)
						cameranet.updateVisibility(loc, 0)
					updating = 0

#undef BORG_CAMERA_BUFFER

// CAMERA

// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.

/obj/machinery/camera/deactivate(user as mob, var/choice = 1)
	..(user, choice)
	invalidateCameraCache()
	if(src.can_use())
		cameranet.addCamera(src)
	else
		src.set_light(0)
		cameranet.removeCamera(src)

/obj/machinery/camera/New()
	..()
	//Camera must be added to global list of all cameras no matter what...
	if(cameranet.cameras_unsorted || !ticker)
		cameranet.cameras += src
		cameranet.cameras_unsorted = 1
	else
		dd_insertObjectList(cameranet.cameras, src)
	update_coverage(1)

/obj/machinery/camera/Destroy()
	clear_all_networks()
	cameranet.cameras -= src
	..()

// Mobs
/mob/living/silicon/ai/rejuvenate()
	var/was_dead = stat == DEAD
	..()
	if(was_dead && stat != DEAD)
		// Arise!
		cameranet.updateVisibility(src, 0)

/mob/living/silicon/ai/death(gibbed)
	if(..())
		// If true, the mob went from living to dead (assuming everyone has been overriding as they should...)
		cameranet.updateVisibility(src, 0)
