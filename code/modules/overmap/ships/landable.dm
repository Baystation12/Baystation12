// These come with shuttle functionality. Need to be assigned a (unique) shuttle datum name. 
// Mapping location doesn't matter, so long as on a map loaded at the same time as the shuttle areas.
// Multiz shuttles currently not supported. Non-autodock shuttles currently not supported.

#define SHIP_STATUS_LANDED   1
#define SHIP_STATUS_TRANSIT  2
#define SHIP_STATUS_OVERMAP  3

/obj/effect/overmap/ship/landable
	var/shuttle                                         // Name of assotiated shuttle. Must be autodock.
	var/obj/effect/shuttle_landmark/ship/landmark       // Record our open space landmark for easy reference.
	var/status = SHIP_STATUS_LANDED
	icon_state = "shuttle"
	moving_state = "shuttle_moving"

/obj/effect/overmap/ship/landable/Destroy()
	GLOB.shuttle_moved_event.unregister(SSshuttle.shuttles[shuttle], src)
	return ..()

/obj/effect/overmap/ship/landable/can_burn()
	if(status != SHIP_STATUS_OVERMAP)
		return 0
	return ..()

/obj/effect/overmap/ship/landable/burn()
	if(status != SHIP_STATUS_OVERMAP)
		return 0
	return ..()

/obj/effect/overmap/ship/landable/check_ownership(obj/object)
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(!shuttle_datum)
		return
	var/list/areas = shuttle_datum.find_childfree_areas()
	if(get_area(object) in areas)
		return 1

// We autobuild our z levels.
/obj/effect/overmap/ship/landable/find_z_levels()
	world.maxz++
	map_z += world.maxz
	// Not really the center, but rather where the shuttle landmark should be
	var/turf/center_loc = locate(round(world.maxx/2), round(world.maxy/2), world.maxz)
	landmark = new (center_loc, shuttle)
	add_landmark(landmark, shuttle)

/obj/effect/overmap/ship/landable/populate_sector_objects()
	..()
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	GLOB.shuttle_moved_event.register(shuttle_datum, src, .proc/on_shuttle_jump)
	on_landing(landmark, shuttle_datum.current_location) // We "land" at round start to properly place ourselves on the overmap.

/obj/effect/shuttle_landmark/ship
	name = "Open Space"
	landmark_tag = "ship"
	flags = SLANDMARK_FLAG_AUTOSET | SLANDMARK_FLAG_ZERO_G

/obj/effect/shuttle_landmark/ship/Initialize(mapload, shuttle_name)
	landmark_tag += "_[shuttle_name]"
	. = ..()

/obj/effect/shuttle_landmark/ship/Destroy()
	var/obj/effect/overmap/ship/landable/ship = map_sectors["z"]
	if(istype(ship) && ship.landmark == src)
		ship.landmark = null
	. = ..()

/obj/effect/overmap/ship/landable/proc/on_shuttle_jump(datum/shuttle/given_shuttle, obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(given_shuttle != SSshuttle.shuttles[shuttle])
		return
	var/datum/shuttle/autodock/auto = given_shuttle
	if(into == auto.landmark_transition)
		status = SHIP_STATUS_TRANSIT
		on_takeoff(from, into)
		return
	if(into == landmark)
		status = SHIP_STATUS_OVERMAP
		on_takeoff(from, into)
		return
	status = SHIP_STATUS_LANDED
	on_landing(from, into)

/obj/effect/overmap/ship/landable/proc/on_landing(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	var/obj/effect/overmap/target = map_sectors["[into.z]"]
	if(!target || target == src)
		return
	forceMove(target)
	halt()

/obj/effect/overmap/ship/landable/proc/on_takeoff(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(!isturf(loc))
		forceMove(get_turf(loc))
		unhalt()

/obj/effect/overmap/ship/landable/get_landed_info()
	switch(status)
		if(SHIP_STATUS_LANDED)
			var/obj/effect/overmap/location = loc
			if(istype(loc, /obj/effect/overmap/sector))
				return "Landed on \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			if(istype(loc, /obj/effect/overmap/ship))
				return "Docked with \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			return "Docked with an unknown object."
		if(SHIP_STATUS_TRANSIT)
			return "Maneuvering under secondary thrust."
		if(SHIP_STATUS_OVERMAP)
			return "In open space."

#undef SHIP_STATUS_LANDED
#undef SHIP_STATUS_TRANSIT
#undef SHIP_STATUS_OVERMAP