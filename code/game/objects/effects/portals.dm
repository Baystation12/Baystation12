/obj/effect/portal
	name = "portal"
	desc = "Looks unstable. Best to test it with the clown."
	icon = 'icons/obj/stationobjs.dmi'
	icon_state = "portal"
	density = 1
	unacidable = 1//Can't destroy energy portals.
	var/obj/item/target = null
	var/creator = null
	anchored = 1.0
	var/dangerous = 0
	var/failchance = 0

/obj/effect/portal/Bumped(mob/M as mob|obj)
	spawn(0)
		src.teleport(M)
		return
	return

/obj/effect/portal/Crossed(AM as mob|obj)
	spawn(0)
		src.teleport(AM)
		return
	return

/obj/effect/portal/attack_hand(mob/user as mob)
	spawn(0)
		src.teleport(user)
		return
	return

/obj/effect/portal/New(var/start, var/end, var/delete_after = 300, var/failure_rate)
	..()
	if(failure_rate)
		failchance = failure_rate
		if(prob(failchance))
			icon_state = "portal1"
			dangerous = 1
	playsound(src, 'sound/effects/phasein.ogg', 25, 1)
	target = end

	if(delete_after)
		spawn(delete_after)
			qdel(src)

/obj/effect/portal/Destroy()
	target = null
	. = ..()

/obj/effect/portal/proc/teleport(atom/movable/M as mob|obj)
	if(istype(M, /obj/effect)) //sparks don't teleport
		return
	if (M.anchored&&istype(M, /obj/mecha))
		return
	if (icon_state == "portal1")
		return
	if (!( target ))
		qdel(src)
		return
	if (istype(M, /atom/movable))
		if(dangerous && prob(failchance)) //oh dear a problem, put em in deep space
			var/destination_z = GLOB.using_map.get_transit_zlevel(z)
			do_teleport(M, locate(rand(TRANSITIONEDGE, world.maxx - TRANSITIONEDGE), rand(TRANSITIONEDGE, world.maxy -TRANSITIONEDGE), destination_z), 0)
		else
			do_teleport(M, target, 1) ///You will appear adjacent to the beacon
