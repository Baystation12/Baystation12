/datum/artifact_effect/teleport_far
	name = "Long Range Teleporter"
	effect_type = EFFECT_BLUESPACE
	var/list/teleporting = list() //mobs waiting to be teleported
	var/list/zlevels = list() //possible zlevels to teleport too
	var/list/portals = list() //portals waiting for its connected player to use them
	var/area/target //target area used to put all players affected by the same pulse in the same place

/datum/artifact_effect/teleport_far/New()
	..()
	effect = EFFECT_PULSE
	zlevels = GLOB.using_map.player_levels.Copy()

	//filters out station levels and most provac sites
	zlevels -= GLOB.using_map.station_levels
	for (var/zlevel in map_sectors)
		var/obj/effect/overmap/visitable/O = map_sectors[zlevel]
		if (istype(O, /obj/effect/overmap/visitable/ship/landable))
			for (var/z in O.map_z)
				if (z in zlevels)
					zlevels -= GetConnectedZlevels(z)
		if (O.hide_from_reports)
			zlevels -= O.map_z
		if (length(O.get_areas()) <= 1)
			zlevels -= O.map_z

	if (length(zlevels) == 0) //no away sites!
		zlevels = GLOB.using_map.station_levels.Copy() //resort to just porting them around the station


//pulse is setup so each pulse puts all affected players in the same area
/datum/artifact_effect/teleport_far/DoEffectPulse()
	if (holder)
		target = get_area(get_awaysite_turf())
		var/list/mobs = list()
		for (var/mob/living/M in range(src.effectrange, get_turf(holder)))
			mobs += M
		try_teleport(mobs, target)

/datum/artifact_effect/teleport_far/proc/try_teleport(list/mobs, area/dest_area)
	for (var/mob/living/M in mobs)
		if (M in teleporting)
			continue

		var/weakness = GetAnomalySusceptibility(M)
		if (prob(100 * weakness))
			var/turf/destination
			if (!dest_area)
				destination = get_awaysite_turf()
			else
				destination = pick_area_turf(dest_area, list(/proc/not_turf_contains_dense_objects, /proc/IsTurfAtmosSafe))

				if (!destination)
					destination = pick_area_turf(dest_area, list(/proc/not_turf_contains_dense_objects))


			if (!destination)
				continue

			if (istype(M, /mob/living/carbon/human))
				var/turf/portal_turf = get_awaysite_turf(destination.z)
				var/obj/effect/portal/artifact/P = new (portal_turf, get_turf(M), 0, 0, M)
				GLOB.destroyed_event.register(P, src, .proc/portal_cleanup)
				portals += P


			to_chat(M, SPAN_WARNING("You feel as if some force is pulling you away!"))
			M.visible_message(SPAN_WARNING("\The [M] distorts and shimmers!"))
			teleporting += M
			addtimer(CALLBACK(src, .proc/do_teleport, M, destination), rand(150, 300))
		else
			to_chat(M, SPAN_NOTICE("You feel some sort of force gather around you, before it quickly dissapates."))


/datum/artifact_effect/teleport_far/proc/do_teleport(mob/M, turf/destination)
	if (M.buckled)
		M.buckled.unbuckle_mob()
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, get_turf(M))
	sparks.start()
	M.visible_message(SPAN_WARNING("\The [M] dissapears in a flash of light!"))
	M.Move(destination)
	sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, M.loc)
	sparks.start()

	to_chat(M, SPAN_WARNING("You are displaced by a strange force!"))
	target = null
	teleporting -= M

/datum/artifact_effect/teleport_far/proc/get_awaysite_turf(zlevel)
	var/obj/effect/overmap/visitable/site
	if (zlevel)
		site = map_sectors["[zlevel]"]
	else
		site = map_sectors["[pick(zlevels)]"]

	if (!site)
		return FALSE

	var/list/areas = site.get_areas()

	if (length(areas) == 0)
		return FALSE

	var/area/A = pick(areas)
	var/list/turfs = get_area_turfs(A, list(/proc/not_turf_contains_dense_objects, /proc/IsTurfAtmosSafe))

	//prioritize atmos safe turfs before resorting to just empty ones
	if (length(turfs) == 0)
		while (length(turfs) == 0)
			areas -= A
			if (!length(areas))
				turfs = get_area_turfs(A, list(/proc/not_turf_contains_dense_objects))
				break

			A = pick(areas)
			turfs = get_area_turfs(A, list(/proc/not_turf_contains_dense_objects, /proc/IsTurfAtmosSafe))

	var/turf/T = pick(turfs)

	if (!T)
		return FALSE

	return T

/datum/artifact_effect/teleport_far/proc/portal_cleanup(obj/effect/portal/P)
	GLOB.destroyed_event.unregister(P, src)
	portals -= P

/obj/effect/portal/artifact
	desc = "Some sort of portal. It looks like it appeared very recently."
	icon = 'icons/obj/objects.dmi'
	icon_state = "anom"
	var/mob/living/owner

/obj/effect/portal/artifact/New(start, end, delete_after, failure_rate, mob/living/owner)
	. = ..()
	addtimer(CALLBACK(src, .proc/cleanup), 30 MINUTES) //delete portal if they can't find it in time
	src.owner = owner


/obj/effect/portal/artifact/Bumped(mob/M as mob|obj)
	..()
	if (M == owner)
		addtimer(CALLBACK(src, .proc/cleanup), 1 SECOND)


/obj/effect/portal/artifact/Crossed(AM as mob|obj)
	..()
	if (AM == owner)
		addtimer(CALLBACK(src, .proc/cleanup), 1 SECOND)

/obj/effect/portal/artifact/attack_hand(mob/user as mob)
	..()
	if (user == owner)
		addtimer(CALLBACK(src, .proc/cleanup), 1 SECOND)

/obj/effect/portal/artifact/proc/cleanup()
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 0, get_turf(src))
	sparks.start()
	qdel(src)
