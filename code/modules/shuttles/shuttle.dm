//shuttle moving state defines are in setup.dm

/datum/shuttle
	var/name = ""
	var/warmup_time = 0
	var/moving_status = SHUTTLE_IDLE

	var/list/shuttle_area //can be both single area type or a list of areas
	var/obj/shuttle_landmark/current_location //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.

	var/arrive_time = 0	//the time at which the shuttle arrives when long jumping
	var/flags = 0
	var/process_state = IDLE_STATE //Used with SHUTTLE_FLAGS_PROCESS, as well as to store current state.
	var/category = /datum/shuttle
	var/multiz = 0	//how many multiz levels, starts at 0

	var/ceiling_type = /turf/unsimulated/floor/shuttle_ceiling

	/// List of shuttle locations (as relative positions from the initial location) that should inherit the turf type of the target location when moving
	var/list/inheriting_turfs = list()

	var/sound_takeoff = 'sound/effects/shuttle_takeoff.ogg'
	var/sound_landing = 'sound/effects/shuttle_landing.ogg'

	var/knockdown = 1 //whether shuttle downs non-buckled people when it moves

	var/defer_initialisation = FALSE //this shuttle will/won't be initialised automatically. If set to true, you are responsible for initialzing the shuttle manually.
	                                 //Useful for shuttles that are initialed by map_template loading, or shuttles that are created in-game or not used.
	var/logging_home_tag   //Whether in-game logs will be generated whenever the shuttle leaves/returns to the landmark with this landmark_tag.
	var/logging_access     //Controls who has write access to log-related stuff; should correlate with pilot access.

	var/mothershuttle //tag of mothershuttle
	var/motherdock    //tag of mothershuttle landmark, defaults to starting location

/datum/shuttle/New(_name, obj/shuttle_landmark/initial_location)
	..()
	if (_name)
		src.name = _name

	if (initial_location)
		current_location = initial_location
	else
		current_location = SSshuttle.get_landmark(current_location)
	if (!istype(current_location))
		CRASH("Shuttle \"[name]\" could not find its starting location.")

	var/list/areas = list()
	if (!islist(shuttle_area))
		shuttle_area = list(shuttle_area)
	for (var/area_type in shuttle_area)
		var/area/located_area = locate(area_type)
		if (!istype(located_area))
			CRASH("Shuttle \"[name]\" couldn't locate area [area_type].")
		areas += located_area

		for (var/turf/area_turf in area_type)
			if (should_inherit_turf(area_turf))
				var/relative_x = area_turf.x - current_location.x
				var/relative_y = area_turf.y - current_location.y
				inheriting_turfs += list(relative_x, relative_y)

	shuttle_area = areas

	if (src.name in SSshuttle.shuttles)
		CRASH("A shuttle with the name '[name]' is already defined.")
	SSshuttle.shuttles[src.name] = src
	if (logging_home_tag)
		new /datum/shuttle_log(src)
	if (flags & SHUTTLE_FLAGS_PROCESS)
		SSshuttle.process_shuttles += src
	if (flags & SHUTTLE_FLAGS_SUPPLY)
		if (SSsupply.shuttle)
			CRASH("A supply shuttle is already defined.")
		SSsupply.shuttle = src

/datum/shuttle/Destroy()
	current_location = null

	SSshuttle.shuttles -= src.name
	SSshuttle.process_shuttles -= src
	SSshuttle.shuttle_logs -= src
	if (SSsupply.shuttle == src)
		SSsupply.shuttle = null

	inheriting_turfs.Cut()
	inheriting_turfs = null

	. = ..()

/// Whether or not the given turf should inherit the target turf type when the shuttle moves
/datum/shuttle/proc/should_inherit_turf(turf/shuttle_turf)
	// By default, all space turfs inherit target turfs
	return istype(shuttle_turf, /turf/space)

/datum/shuttle/proc/short_jump(obj/shuttle_landmark/destination)
	if (moving_status != SHUTTLE_IDLE) return

	moving_status = SHUTTLE_WARMUP
	if (sound_takeoff)
		playsound(current_location, sound_takeoff, 100, 20, 0.2)
	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return //someone cancelled the launch

		if (!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			var/datum/shuttle/autodock/dock = src
			if (istype(dock))
				dock.cancel_launch(null)
			return

		moving_status = SHUTTLE_INTRANSIT //shouldn't matter but just to be safe
		attempt_move(destination)
		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/long_jump(obj/shuttle_landmark/destination, obj/shuttle_landmark/interim, travel_time)
	if (moving_status != SHUTTLE_IDLE) return

	var/obj/shuttle_landmark/start_location = current_location

	moving_status = SHUTTLE_WARMUP
	if (sound_takeoff)
		playsound(current_location, sound_takeoff, 100, 20, 0.2)
		if (!istype(start_location.base_area, /area/space))
			var/area/start_area = get_area(start_location)

			for (var/mob/player_mob in GLOB.player_list)
				if (player_mob.client && player_mob.z == start_area.z && !istype(get_turf(player_mob), /turf/space) && !(get_area(player_mob) in src.shuttle_area))
					to_chat(player_mob, SPAN_NOTICE("The rumble of engines are heard as a shuttle lifts off."))

	spawn(warmup_time*10)
		if (moving_status == SHUTTLE_IDLE)
			return	//someone cancelled the launch

		if (!fuel_check()) //fuel error (probably out of fuel) occured, so cancel the launch
			var/datum/shuttle/autodock/dock = src
			if (istype(dock))
				dock.cancel_launch(null)
			return

		arrive_time = world.time + travel_time*10
		moving_status = SHUTTLE_INTRANSIT
		if (attempt_move(interim))
			var/fwooshed = 0
			while (world.time < arrive_time)
				if (!fwooshed && (arrive_time - world.time) < 100)
					fwooshed = 1
					playsound(destination, sound_landing, 100, 0, 7)
					if (!istype(destination.base_area, /area/space))
						var/area/A = get_area(destination)

						for (var/mob/M in GLOB.player_list)
							if (M.client && M.z == A.z && !istype(get_turf(M), /turf/space) && !(get_area(M) in src.shuttle_area))
								to_chat(M, SPAN_NOTICE("The rumble of a shuttle's engines fill the area as a ship manuevers in for a landing."))

				sleep(5)
			if (!attempt_move(destination))
				attempt_move(start_location) //try to go back to where we started. If that fails, I guess we're stuck in the interim location

		moving_status = SHUTTLE_IDLE

/datum/shuttle/proc/fuel_check()
	return 1 //fuel check should always pass in non-overmap shuttles (they have magic engines)

/*****************
* Shuttle Moved Handling * (Observer Pattern Implementation: Shuttle Moved)
* Shuttle Pre Move Handling * (Observer Pattern Implementation: Shuttle Pre Move)
*****************/

/datum/shuttle/proc/attempt_move(obj/shuttle_landmark/destination)
	if (current_location == destination)
		return FALSE

	if (!destination.is_valid(src))
		return FALSE
	if (current_location.cannot_depart(src))
		return FALSE
	testing("[src] moving to [destination]. Areas are [english_list(shuttle_area)]")
	var/list/translation = list()
	for (var/area/area_to_move in shuttle_area)
		testing("Moving [area_to_move]")
		translation += get_turf_translation(get_turf(current_location), get_turf(destination), area_to_move.contents)
	var/old_location = current_location
	GLOB.shuttle_pre_move_event.raise_event(src, old_location, destination)
	shuttle_moved(destination, translation)
	GLOB.shuttle_moved_event.raise_event(src, old_location, destination)
	destination.shuttle_arrived(src)
	// + BANDAID
	// /obj/machinery/proc/area_changed and /proc/translate_turfs cause problems with power cost duplication.
	var/list/area/retally_areas
	if (isarea(shuttle_area))
		retally_areas = list(shuttle_area)
	else if (islist(shuttle_area))
		retally_areas = shuttle_area
	for (var/area/retally_area as anything in retally_areas)
		retally_area.retally_power()
	// - BANDAID
	return TRUE

//just moves the shuttle from A to B, if it can be moved
//A note to anyone overriding move in a subtype. shuttle_moved() must absolutely not, under any circumstances, fail to move the shuttle.
//If you want to conditionally cancel shuttle launches, that logic must go in short_jump(), long_jump() or attempt_move()
/datum/shuttle/proc/shuttle_moved(obj/shuttle_landmark/destination, list/turf_translation)

//	log_debug("move_shuttle() called for [shuttle_tag] leaving [origin] en route to [destination].")
//	log_degug("area_coming_from: [origin]")
//	log_debug("destination: [destination]")
	if ((flags & SHUTTLE_FLAGS_ZERO_G))
		var/new_grav = 1
		if (destination.flags & SLANDMARK_FLAG_ZERO_G)
			var/area/new_area = get_area(destination)
			new_grav = new_area.has_gravity
		for (var/area/our_area in shuttle_area)
			if (our_area.has_gravity != new_grav)
				our_area.gravitychange(new_grav)

	for (var/turf/src_turf in turf_translation)
		var/turf/dst_turf = turf_translation[src_turf]
		if (src_turf.is_solid_structure()) //in case someone put a hole in the shuttle and you were lucky enough to be under it
			for (var/atom/movable/movable in dst_turf)
				if (!movable.simulated)
					continue
				movable.shuttle_land_on()
	var/list/powernets = list()
	var/list/beacons = list()
	var/list/roofs_to_clear = list()
	for (var/area/area_to_move in shuttle_area)
		// if there was a zlevel above our origin, prepare to erase our ceiling now we're leaving. The actual replacement occurs later, to prevent space turfs converting to open space because the shuttle's still there.
		if (HasAbove(current_location.z))
			for (var/turf/origin_turf in area_to_move.contents)
				var/turf/turf_above = GetAbove(origin_turf)
				if (istype(turf_above, ceiling_type))
					roofs_to_clear += turf_above
		if (knockdown)
			for (var/mob/mob in area_to_move)
				spawn(0)
					if (istype(mob, /mob/living/carbon))
						if (mob.buckled)
							to_chat(mob, SPAN_WARNING("Sudden acceleration presses you into your chair!"))
							shake_camera(mob, 3, 1)
						else
							to_chat(mob, SPAN_WARNING("The floor lurches beneath you!"))
							shake_camera(mob, 10, 1)
							mob.visible_message(SPAN_WARNING("[mob.name] is tossed around by the sudden acceleration!"))
							mob.throw_at_random(FALSE, 4, 1)

		for (var/obj/structure/cable/cable in area_to_move)
			powernets |= cable.powernet
		for (var/obj/machinery/radio_beacon/beacon in area_to_move)
			beacons |= beacon
	if (logging_home_tag)
		var/datum/shuttle_log/s_log = SSshuttle.shuttle_logs[src]
		s_log.handle_move(current_location, destination)

	// inherit turfs before the actual movement by copying the target to the source
	for (var/i = 1; i <= length(inheriting_turfs); i += 2)
		var/turf/source = locate(current_location.x + inheriting_turfs[i], current_location.y + inheriting_turfs[i + 1], current_location.z)
		var/turf/target = turf_translation[source]
		if (target)
			var/turf/inherited_turf = source.ChangeTurf(target.type, FALSE, FALSE, TRUE)
			inherited_turf.transport_properties_from(target)

	// move shuttle turfs to the target location
	translate_turfs(turf_translation, current_location.base_area, current_location.base_turf)
	current_location = destination

	for (var/turf/roof_turf as anything in roofs_to_clear)
		roof_turf.ChangeTurf(get_base_turf_by_area(roof_turf), 1, 1)

	// if there's a zlevel above our destination, paint in a ceiling on it so we retain our air
	if (HasAbove(current_location.z))
		for (var/area/area_to_check in shuttle_area)
			for (var/turf/destination_turf in area_to_check.contents)
				var/turf/turf_above = GetAbove(destination_turf)
				if (istype(turf_above, get_base_turf_by_area(turf_above)) || istype(turf_above, /turf/simulated/open))
					if (get_area(turf_above) in shuttle_area)
						continue
					turf_above.ChangeTurf(ceiling_type, TRUE, TRUE, TRUE)
					for (var/datum/lighting_corner/lighting_corner in destination_turf.corners)
						lighting_corner.clear_above_ambient()

	// Remove all powernets that were affected, and rebuild them.
	var/list/cables = list()
	for (var/datum/powernet/powernet in powernets)
		cables |= powernet.cables
		qdel(powernet)
	for (var/obj/structure/cable/cable in cables)
		if (!cable.powernet)
			var/datum/powernet/new_powernet = new()
			new_powernet.add_cable(cable)
			propagate_network(cable, cable.powernet)

	// Move any active radio beacon signals to follow the correct overmap object.
	for (var/obj/machinery/radio_beacon/beacon as anything in beacons)
		var/obj/overmap/visitable/visitable = map_sectors["[get_z(beacon)]"]
		if (!visitable)
			continue
		beacon.signal?.set_origin(visitable)
		beacon.emergency_signal?.set_origin(visitable)

	if (mothershuttle)
		var/datum/shuttle/mothership = SSshuttle.shuttles[mothershuttle]
		if (mothership)
			if (current_location.landmark_tag == motherdock)
				mothership.shuttle_area |= shuttle_area
			else
				mothership.shuttle_area -= shuttle_area

/// Handler for shuttles landing on atoms. Called by `shuttle_moved()`.
/atom/movable/proc/shuttle_land_on()
	qdel(src)

/mob/living/shuttle_land_on()
	gib()

//returns 1 if the shuttle has a valid arrive time
/datum/shuttle/proc/has_arrive_time()
	return (moving_status == SHUTTLE_INTRANSIT)

/datum/shuttle/proc/find_children()
	. = list()
	for (var/shuttle_name in SSshuttle.shuttles)
		var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_name]
		if (shuttle.mothershuttle == name)
			. += shuttle

//Returns those areas that are not actually child shuttles.
/datum/shuttle/proc/find_childfree_areas()
	. = shuttle_area.Copy()
	for (var/datum/shuttle/child in find_children())
		. -= child.shuttle_area

/datum/shuttle/autodock/proc/get_location_name()
	if (moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return current_location.name

/datum/shuttle/autodock/proc/get_destination_name()
	if (!next_location)
		return "None"
	return next_location.name
