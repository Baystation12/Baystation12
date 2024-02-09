//making this separate from /obj/landmark until that mess can be dealt with
/obj/shuttle_landmark
	name = "Nav Point"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = TRUE
	unacidable = TRUE
	simulated = FALSE
	invisibility = INVISIBILITY_ABSTRACT

	var/landmark_tag
	//ID of the controller on the dock side
	var/datum/computer/file/embedded_program/docking/docking_controller
	//ID of controller used for this landmark for shuttles with multiple ones.
	var/list/special_dock_targets

	//when the shuttle leaves this landmark, it will leave behind the base area
	//also used to determine if the shuttle can arrive here without obstruction
	var/area/base_area
	//Will also leave this type of turf behind if set.
	var/turf/base_turf
	//Name of the shuttle, null for generic waypoint
	var/shuttle_restricted
	var/flags = 0


/obj/shuttle_landmark/Initialize()
	. = ..()
	if(docking_controller)
		. = INITIALIZE_HINT_LATELOAD
	if(flags & SLANDMARK_FLAG_AUTOSET)
		base_area = get_area(src)
		var/turf/T = get_turf(src)
		if(T)
			base_turf = T.type
	else
		base_area = locate(base_area || world.area)
	SetName(name + " ([x],[y])")
	SSshuttle.register_landmark(landmark_tag, src)


/obj/shuttle_landmark/LateInitialize(mapload)
	if(!docking_controller)
		return
	var/docking_tag = docking_controller
	docking_controller = SSshuttle.docking_registry[docking_tag]
	if(!istype(docking_controller))
		CRASH("Could not find docking controller for shuttle waypoint '[name]', docking tag was '[docking_tag]'.")
	if(GLOB.using_map.use_overmap)
		var/obj/overmap/visitable/location = map_sectors["[z]"]
		if(location && location.docking_codes)
			docking_controller.docking_codes = location.docking_codes


/obj/shuttle_landmark/forceMove()
	var/obj/overmap/visitable/map_origin = map_sectors["[z]"]
	. = ..()
	var/obj/overmap/visitable/map_destination = map_sectors["[z]"]
	if(map_origin != map_destination)
		if(map_origin)
			map_origin.remove_landmark(src, shuttle_restricted)
		if(map_destination)
			map_destination.add_landmark(src, shuttle_restricted)


//Called when the landmark is added to an overmap sector.
/obj/shuttle_landmark/proc/sector_set(obj/overmap/visitable/O, shuttle_name)
	shuttle_restricted = shuttle_name


/obj/shuttle_landmark/proc/is_valid(datum/shuttle/shuttle)
	if(shuttle.current_location == src)
		return FALSE
	for(var/area/A in shuttle.shuttle_area)
		var/list/translation = get_turf_translation(get_turf(shuttle.current_location), get_turf(src), A.contents)
		if(check_collision(base_area, list_values(translation)))
			return FALSE
	var/conn = GetConnectedZlevelsSet(z)
	for(var/w in (z - shuttle.multiz) to z)
		if(!(w in conn))
			return FALSE
	return TRUE


/obj/shuttle_landmark/proc/cannot_depart(datum/shuttle/shuttle)
	return FALSE


/obj/shuttle_landmark/proc/shuttle_arrived(datum/shuttle/shuttle)
	return


/proc/check_collision(area/target_area, list/target_turfs)
	for(var/target_turf in target_turfs)
		var/turf/target = target_turf
		if(!target)
			return TRUE //collides with edge of map
		if(target.loc != target_area)
			return TRUE //collides with another area
		if(target.density)
			return TRUE //dense turf
	return FALSE


//Self-naming/numbering ones.
/obj/shuttle_landmark/automatic
	name = "Navpoint"
	landmark_tag = "navpoint"
	flags = SLANDMARK_FLAG_AUTOSET


/obj/shuttle_landmark/automatic/Initialize()
	landmark_tag += "-[x]-[y]-[z]-[random_id("landmarks",1,9999)]"
	return ..()


/obj/shuttle_landmark/automatic/sector_set(obj/overmap/visitable/O)
	..()
	SetName("[O.name] - [initial(name)] ([x],[y])")


//Subtype that calls explosion on init to clear space for shuttles
/obj/shuttle_landmark/automatic/clearing
	var/radius = LANDING_ZONE_RADIUS


/obj/shuttle_landmark/automatic/clearing/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD


/obj/shuttle_landmark/automatic/clearing/LateInitialize(mapload)
	..()
	for(var/turf/T in range(radius, src))
		if(T.density)
			T.ChangeTurf(get_base_turf_by_area(T))


/obj/shuttle_landmark/automatic/beacon
	name = "Bluespace Beacon Signal"
	/// The beacon object synced to this landmark. If this is ever null or qdeleted the landmark should delete itself.
	var/obj/item/shuttle_beacon/beacon


/obj/shuttle_landmark/automatic/beacon/Initialize(mapload, obj/item/shuttle_beacon/beacon)
	. = ..()
	if (!istype(beacon))
		log_debug(append_admin_tools("\A [src] was initialized with an invalid or nonexistant beacon", location = get_turf(src)))
		return INITIALIZE_HINT_QDEL
	if (beacon.landmark && beacon.landmark != src)
		log_debug(append_admin_tools("\A [src] was initialized with a beacon already has a synced landmark.", location = get_turf(src)))
		return INITIALIZE_HINT_QDEL
	src.beacon = beacon
	GLOB.moved_event.register(beacon, src, /obj/shuttle_landmark/automatic/beacon/proc/update_beacon_moved)


/obj/shuttle_landmark/automatic/beacon/Destroy()
	GLOB.moved_event.unregister(beacon, src, /obj/shuttle_landmark/automatic/beacon/proc/update_beacon_moved)
	if (beacon?.active)
		log_debug(append_admin_tools("\A [src] was destroyed with a still active beacon.", location = get_turf(beacon)))
		beacon.deactivate()
	beacon = null
	return ..()


/// Event handler for when the beacon moves. Theoretically possible with a beacon deployed on a shuttle turf, or with adminbus.
/obj/shuttle_landmark/automatic/beacon/proc/update_beacon_moved(atom/movable/moving_instance, atom/old_loc, atom/new_loc)
	if (!isturf(new_loc) || isspaceturf(new_loc) || isopenspace(new_loc))
		log_debug(append_admin_tools("\A [src]'s beacon was moved to a non-turf or unacceptable location.", location = get_turf(new_loc)))
		beacon.deactivate()
		return
	forceMove(new_loc)
	SetName("[initial(name)] ([x],[y])")
	log_debug(append_admin_tools("\A [src]'s beacon was moved to [get_area(new_loc)].", location = get_turf(src)))


/// Desynchronizes the effect from the beacon, rendering it a permanent landmark.
/obj/shuttle_landmark/automatic/beacon/proc/desync_beacon()
	GLOB.moved_event.unregister(beacon, src, /obj/shuttle_landmark/automatic/beacon/proc/update_beacon_moved)
	if (beacon?.active)
		beacon.deactivate(TRUE, TRUE)
	beacon = null


/obj/item/shuttle_beacon
	name = "shuttle beacon"
	desc = "Burst transmitter used to broadcast all needed information for shuttle navigation systems. Has a bright blue light attached for marking the spot where you probably shouldn't be standing."
	icon = 'icons/obj/space_flare.dmi'
	icon_state = "packaged"
	light_color = "#3728ff"

	/// Boolean. Whether or not the beacon has been activated.
	var/active = FALSE

	/// The shuttle landmark synced to this beacon. This is set when the beacon is activated.
	var/obj/shuttle_landmark/automatic/beacon/landmark


/obj/item/shuttle_beacon/Destroy()
	deactivate(TRUE)
	return ..()


/obj/item/shuttle_beacon/attack_self(mob/user)
	if (activate(user))
		user.visible_message(
			SPAN_NOTICE("\The [user] plants \the [src] and activates it."),
			SPAN_NOTICE("You plant \the [src] and activate it."),
			SPAN_ITALIC("You hear a soft hum.")
		)


/obj/item/shuttle_beacon/on_update_icon()
	if (active)
		icon_state = "deployed"
		var/image/image = image(icon, "active")
		image.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		image.layer = ABOVE_LIGHTING_LAYER
		AddOverlays(image)
		pixel_x = rand(-6, 6)
		pixel_y = rand(-6, 6)
		set_light(7, 0.7, "#85d1ff")
	else
		icon_state = initial(icon_state)
		ClearOverlays()
		set_light(0)


/obj/item/shuttle_beacon/shuttle_land_on()
	if (active)
		landmark.desync_beacon()
	..()


/**
 * Handles activation of the flare.
 *
 * Parameters
 * `user` - The user activating the flare. Optional. Applies additional unequip processing and checks before activating the flare.
 *
 * Returns boolean - FALSE if the flare was not activated, TRUE if it was.
 */
/obj/item/shuttle_beacon/proc/activate(mob/user)
	if (active)
		log_debug(append_admin_tools("\A [src] attempted to activate but was already active.", user, get_turf(src)))
		return FALSE
	var/turf/T = get_turf(src)
	if (isspaceturf(T) || isopenspace(T))
		if (user)
			to_chat(user, SPAN_WARNING("\The [src] needs to be activated on solid ground."))
		return FALSE
	if (istype(user) && !user.unEquip(src, T))
		log_debug(append_admin_tools("\A [src] attempted to activate but could not be unequipped by the mob.", user, get_turf(src)))
		return FALSE
	if (loc != T)
		log_debug(append_admin_tools("\A [src] attempted to activate but was not on a valid turf.", user, get_turf(src)))
		return FALSE
	if (user)
		user.visible_message(
			SPAN_ITALIC("\The [user] starts setting up \a [src]."),
			SPAN_ITALIC("You start setting up \a [src]."),
			SPAN_ITALIC("You hear the clicking of metal and plastic.")
		)
		playsound(src, 'sound/items/shuttle_beacon_prepare.ogg', 100)
		if (!do_after(user, 3 SECONDS, src, DO_PUBLIC_UNIQUE))
			return FALSE
		playsound(src, 'sound/items/shuttle_beacon_complete.ogg', 100)
	active = TRUE
	anchored = TRUE
	log_and_message_admins("activated a shuttle beacon in [get_area(src)].", user, get_turf(src))
	landmark = new(T, src)
	update_icon()
	return TRUE


/**
 * Handles deactivation of the flare.
 *
 * Returns boolean - FALSE if the flare was not deactivated, TRUE if it was.
 */
/obj/item/shuttle_beacon/proc/deactivate(silent, skip_destroy_landmark)
	if (!active)
		return FALSE
	active = FALSE
	anchored = FALSE
	if (!skip_destroy_landmark)
		QDEL_NULL(landmark)
	landmark = null
	update_icon()
	if (!silent)
		visible_message(SPAN_WARNING("\The [src] deactivates, going dark."))
	return TRUE


/obj/item/shuttle_beacon/active
	active = TRUE
	anchored = TRUE


/obj/item/shuttle_beacon/active/Initialize()
	. = ..()
	var/turf/turf = get_turf(src)
	if (!turf)
		return INITIALIZE_HINT_QDEL
	landmark = new (turf, src)
	update_icon()
