#define BORG_CAMERA_BUFFER 30

//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

// TURFS

/turf
	var/image/obscured

/turf/proc/visibilityChanged()
	if(ticker)
		updateVisibilityNetworks(src)

/turf/simulated/Del()
	visibilityChanged()
	..()

/turf/simulated/New()
	..()
	visibilityChanged()



// STRUCTURES

/obj/structure/Del()
	if(ticker)
		updateVisibilityNetworks(src)
	..()

/obj/structure/New()
	..()
	if(ticker)
		updateVisibilityNetworks(src)

// EFFECTS

/obj/effect/Del()
	if(ticker)
		updateVisibilityNetworks(src)
	..()

/obj/effect/New()
	..()
	if(ticker)
		updateVisibilityNetworks(src)


// DOORS

// Simply updates the visibility of the area when it opens/closes/destroyed.
/obj/machinery/door/update_nearby_tiles(need_rebuild)
	. = ..(need_rebuild)
	// Glass door glass = 1
	// don't check then?
	if(!glass)
		world << "Updating visibility for [src]"
		updateVisibilityNetworks(src,0)


// ROBOT MOVEMENT

// Update the portable camera everytime the Robot moves.
// This might be laggy, comment it out if there are problems.
/mob/living/silicon/robot/var/updating = 0

/mob/living/silicon/robot/Move()
	var/oldLoc = src.loc
	. = ..()
	if(.)
		if(src.camera && src.camera.network.len)
			if(!updating)
				updating = 1
				spawn(BORG_CAMERA_BUFFER)
					if(oldLoc != src.loc)
						cameraNetwork.updateViewpoint(src.camera)
					updating = 0

// CAMERA

// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.

/obj/machinery/camera/deactivate(user as mob, var/choice = 1)
	..(user, choice)
	if(src.can_use())
		cameraNetwork.addViewpoint(src)
	else
		src.SetLuminosity(0)
		cameraNetwork.removeViewpoint(src)

/obj/machinery/camera/New()
	..()
	cameraNetwork.viewpoints += src //Camera must be added to global list of all cameras no matter what...
	var/list/open_networks = difflist(network,RESTRICTED_CAMERA_NETWORKS) //...but if all of camera's networks are restricted, it only works for specific camera consoles.
	if(open_networks.len) //If there is at least one open network, chunk is available for AI usage.
		cameraNetwork.addViewpoint(src)

/obj/machinery/camera/Del()
	cameraNetwork.viewpoints -= src
	var/list/open_networks = difflist(network,RESTRICTED_CAMERA_NETWORKS)
	if(open_networks.len)
		cameraNetwork.removeViewpoint(src)
	..()

#undef BORG_CAMERA_BUFFER