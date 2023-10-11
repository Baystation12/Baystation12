
// virtual disposal object
// travels through pipes in lieu of actual items
// contents will be items flushed by the disposal
// this allows the gas flushed to be tracked

/obj/structure/disposalholder
	invisibility = INVISIBILITY_ABSTRACT
	var/datum/gas_mixture/gas = null	// gas used to flush, will appear at exit point
	var/active = 0	// true if the holder is moving, otherwise inactive
	dir = 0
	var/count = 2048	//*** can travel 2048 steps before going inactive (in case of loops)
	var/destinationTag = "" // changes if contains a delivery container
	var/hasmob = 0 //If it contains a mob
	var/speed = 2
	var/partialTag = "" //set by a partial tagger the first time round, then put in destinationTag if it goes through again.
	var/list/mob/living/held_mobs


/obj/structure/disposalholder/Destroy()
	LAZYCLEARLIST(held_mobs)
	QDEL_NULL(gas)
	active = 0
	STOP_PROCESSING(SSdisposals, src)
	return ..()


/obj/structure/disposalholder/Initialize(mapload, list/atom/movable/movables, datum/reagents/reagents, datum/gas_mixture/gas_mixture)
	. = ..()
	var/large_tag
	var/small_tag
	var/drone_tag
	var/list/found_mobs = list()
	for (var/atom/movable/movable as anything in movables)
		movable.forceMove(src)
		if (ismob(movable))
			if (istype(movable, /mob/living/silicon/robot/drone))
				var/mob/living/silicon/robot/drone/drone = movable
				if (drone.mail_destination)
					drone_tag = drone.mail_destination
			else
				found_mobs += mobs_in_contents(movable)
				found_mobs += movable
		else if (istype(movable, /obj/structure))
			found_mobs += mobs_in_contents(movable)
			if (istype(movable, /obj/structure/bigDelivery))
				var/obj/structure/bigDelivery/delivery = movable
				if (delivery.sortTag)
					large_tag = delivery.sortTag
		else if (istype(movable, /obj/item/smallDelivery))
			found_mobs += mobs_in_contents(movable)
			var/obj/item/smallDelivery/delivery = movable
			if (delivery.sortTag)
				small_tag = delivery.sortTag
		else if (istype(movable, /obj/item/storage))
			found_mobs += mobs_in_contents(movable)
	if (length(found_mobs))
		held_mobs = found_mobs
	create_reagents(500)
	if (reagents)
		reagents.trans_to(src, reagents.total_volume)
	gas = new (PRESSURE_TANK_VOLUME)
	if (gas_mixture)
		gas.copy_from(gas_mixture)
		gas_mixture.clear()
	if (drone_tag)
		destinationTag = drone_tag
	if (small_tag)
		destinationTag = small_tag
	if (large_tag)
		destinationTag = large_tag


/// Start moving the holder at the given disposal unit
/obj/structure/disposalholder/proc/start()
	var/obj/machinery/disposal/disposal = loc
	if (!istype(disposal))
		return
	if (!disposal.trunk)
		disposal.expel(src)
		return
	forceMove(disposal.trunk)
	active = TRUE
	set_dir(DOWN)
	START_PROCESSING(SSdisposals, src)


/obj/structure/disposalholder/Process()
	for (var/i in 1 to speed)
		if (--count < 0)
			active = FALSE
		if (!active || QDELETED(src))
			return PROCESS_KILL
		if (prob(10))
			for (var/mob/living/living as anything in held_mobs)
				living.apply_damage(30, DAMAGE_BRUTE, null, DAMAGE_FLAG_DISPERSED, "Blunt Trauma", ARMOR_MELEE_MAJOR)
		var/obj/structure/disposalpipe/last
		var/obj/structure/disposalpipe/curr = loc
		if (!istype(curr))
			qdel(src)
			return PROCESS_KILL
		last = curr
		curr = curr.transfer(src)
		if (QDELETED(src))
			return PROCESS_KILL
		if (!curr)
			last.expel(src, loc, dir)


	// find the turf which should contain the next pipe
/obj/structure/disposalholder/proc/nextloc()
	return get_step(loc,dir)

// find a matching pipe on a turf
/obj/structure/disposalholder/proc/findpipe(turf/T)
	if(!T)
		return null

	var/fdir = turn(dir, 180)	// flip the movement direction
	for(var/obj/structure/disposalpipe/P in T)
		if(fdir & P.dpdir)		// find pipe direction mask that matches flipped dir
			return P
	// if no matching pipe, return null
	return null

// merge two holder objects
// used when a a holder meets a stuck holder
/obj/structure/disposalholder/proc/merge(obj/structure/disposalholder/other)
	if(other.reagents?.total_volume)
		src.create_reagents()
		other.reagents.trans_to_holder(src.reagents, other.reagents.total_volume)
	for(var/atom/movable/AM in other)
		AM.forceMove(src)		// move everything in other holder to this one
		if(ismob(AM))
			var/mob/M = AM
			if(M.client)	// if a client mob, update eye to follow this holder
				M.client.eye = src
	qdel(other)

/obj/structure/disposalholder/proc/settag(new_tag)
	destinationTag = new_tag

/obj/structure/disposalholder/proc/setpartialtag(new_tag)
	if(partialTag == new_tag)
		destinationTag = new_tag
		partialTag = ""
	else
		partialTag = new_tag

// called when player tries to move while in a pipe
/obj/structure/disposalholder/relaymove(mob/user as mob)
	if(!istype(user,/mob/living))
		return

	var/mob/living/U = user

	if (U.stat || U.last_special <= world.time)
		return

	U.last_special = world.time+100

	if (src.loc)
		for (var/mob/M in hearers(src.loc.loc))
			to_chat(M, SPAN_SIZE(max(0, 5 - get_dist(src, M)), "CLONG, clong!"))

	playsound(src.loc, 'sound/effects/clang.ogg', 50, 0, 0)

// called to vent all gas in holder to a location
/obj/structure/disposalholder/proc/vent_gas(atom/location)
	if(location)
		location.assume_air(gas)  // vent all gas to turf
