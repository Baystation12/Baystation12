// CAMERA

// An addition to deactivate which removes/adds the camera from the chunk list based on if it works or not.

/obj/machinery/camera/deactivate(user as mob, var/choice = 1)
	..(user, choice)
	invalidateCameraCache()
	if(!can_use())
		set_light(0)
	var/datum/visualnet/camera/net = get_cameranet()
	if(!isnull(net))
		net.update_visibility(src)

/obj/machinery/camera/New()
	. = ..()
	var/datum/visualnet/camera/net = get_cameranet()
	if(!isnull(net))
		net.add_source(src)

/obj/machinery/camera/Destroy()
	. = ..()
	var/datum/visualnet/camera/net = get_cameranet()
	if(!isnull(net))
		net.remove_source(src)

/obj/machinery/camera/proc/ready_for_netswitch()
	var/datum/visualnet/camera/old_net = all_networks[network]
	old_net.remove_source(src)

/obj/machinery/camera/proc/update_coverage(var/network_change = 0)
	var/datum/visualnet/camera/new_net = all_networks[network]
	if(network_change)
		new_net.add_source(src)
	else
		new_net.update_visibility(src)

	invalidateCameraCache()

// Mobs
/mob/living/silicon/ai/New()
	..()
	our_visualnet.add_source(src)

/mob/living/silicon/ai/Destroy()
	our_visualnet.remove_source(src)
	. = ..()

/mob/living/silicon/ai/rejuvenate()
	var/was_dead = stat == DEAD
	..()
	if(was_dead && stat != DEAD)
		// Arise!
		our_visualnet.update_visibility(src, FALSE)

/mob/living/silicon/ai/death(gibbed, deathmessage, show_dead_message)
	. = ..(gibbed, deathmessage, show_dead_message)
	if(.)
		// If true, the mob went from living to dead (assuming everyone has been overriding as they should...)
		our_visualnet.update_visibility(src, FALSE)
