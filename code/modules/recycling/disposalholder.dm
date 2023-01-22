
// virtual disposal object
// travels through pipes in lieu of actual items
// contents will be items flushed by the disposal
// this allows the gas flushed to be tracked

/obj/structure/disposalholder
	invisibility = 101
	var/datum/gas_mixture/gas = null	// gas used to flush, will appear at exit point
	var/active = 0	// true if the holder is moving, otherwise inactive
	dir = 0
	var/count = 2048	//*** can travel 2048 steps before going inactive (in case of loops)
	var/destinationTag = "" // changes if contains a delivery container
	var/tomail = 0 //changes if contains wrapped package
	var/hasmob = 0 //If it contains a mob
	var/speed = 2

	var/partialTag = "" //set by a partial tagger the first time round, then put in destinationTag if it goes through again.

	// initialize a holder from the contents of a disposal unit
/obj/structure/disposalholder/proc/check_mob(list/stuff, max_depth = 2)
	. = list()
	if (max_depth > 0)
		for (var/mob/living/M in stuff)
			if (!istype(M, /mob/living/silicon/robot/drone))
				. += M
		for (var/obj/O in stuff)
			. += check_mob(O.contents, max_depth - 1)
/obj/structure/disposalholder/proc/init(var/obj/machinery/disposal/D, var/datum/gas_mixture/flush_gas)

	gas = flush_gas// transfer gas resv. into holder object -- let's be explicit about the data this proc consumes, please.
	var/stuff = D.contents - D.component_parts
	//Check for any living mobs trigger hasmob.
	//hasmob effects whether the package goes to cargo or its tagged destination.
	hasmob = length(check_mob(stuff))

	// now everything inside the disposal gets put into the holder
	// note AM since can contain mobs or objs
	for(var/atom/movable/AM in stuff)
		AM.forceMove(src)
		if(istype(AM, /obj/structure/bigDelivery) && !hasmob)
			var/obj/structure/bigDelivery/T = AM
			src.destinationTag = T.sortTag
		if(istype(AM, /obj/item/smallDelivery) && !hasmob)
			var/obj/item/smallDelivery/T = AM
			src.destinationTag = T.sortTag
		//Drones can mail themselves through maint.
		if(isdrone(AM))
			var/mob/living/silicon/robot/drone/drone = AM
			src.destinationTag = drone.mail_destination


	// start the movement process
	// argument is the disposal unit the holder started in
/obj/structure/disposalholder/proc/start(var/obj/machinery/disposal/D)
	if(!D.trunk)
		D.expel(src)	// no trunk connected, so expel immediately
		return

	forceMove(D.trunk)
	active = 1
	set_dir(DOWN)
	START_PROCESSING(SSdisposals, src)

	// movement process, persists while holder is moving through pipes
/obj/structure/disposalholder/Process()
	for (var/i in 1 to speed)
		if(!(count--))
			active = 0
		if(!active || QDELETED(src))
			return PROCESS_KILL

		var/obj/structure/disposalpipe/last

		if(hasmob && prob(10))
			for(var/mob/living/H in check_mob(src))
				H.apply_damage(30, DAMAGE_BRUTE, null, DAMAGE_FLAG_DISPERSED, "Blunt Trauma", ARMOR_MELEE_MAJOR)//horribly maim any living creature jumping down disposals.  c'est la vie

		var/obj/structure/disposalpipe/curr = loc
		if(!istype(curr))
			qdel(src)
			return PROCESS_KILL

		last = curr
		curr = curr.transfer(src)

		if(QDELETED(src))
			return PROCESS_KILL

		if(!curr)
			last.expel(src, loc, dir)

	// find the turf which should contain the next pipe
/obj/structure/disposalholder/proc/nextloc()
	return get_step(loc,dir)

// find a matching pipe on a turf
/obj/structure/disposalholder/proc/findpipe(var/turf/T)
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
/obj/structure/disposalholder/proc/merge(var/obj/structure/disposalholder/other)
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

/obj/structure/disposalholder/proc/settag(var/new_tag)
	destinationTag = new_tag

/obj/structure/disposalholder/proc/setpartialtag(var/new_tag)
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
			to_chat(M, "<FONT size=[max(0, 5 - get_dist(src, M))]>CLONG, clong!</FONT>")

	playsound(src.loc, 'sound/effects/clang.ogg', 50, 0, 0)

// called to vent all gas in holder to a location
/obj/structure/disposalholder/proc/vent_gas(var/atom/location)
	if(location)
		location.assume_air(gas)  // vent all gas to turf

/obj/structure/disposalholder/Destroy()
	QDEL_NULL(gas)
	active = 0
	STOP_PROCESSING(SSdisposals, src)
	return ..()
