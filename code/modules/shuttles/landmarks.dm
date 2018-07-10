//making this separate from /obj/effect/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "Nav Point"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	unacidable = 1
	simulated = 0
	invisibility = 101

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
	//If set, will set base area and turf type to same as where it was spawned at
	var/autoset

/obj/effect/shuttle_landmark/Initialize()
	. = ..()
	if(autoset)
		base_area = get_area(src)
		var/turf/T = get_turf(src)
		if(T)
			base_turf = T.type
	else
		base_area = locate(base_area || world.area)

	SetName(name + " ([x],[y])")

	if(docking_controller)
		var/docking_tag = docking_controller
		docking_controller = locate(docking_tag)
		if(!istype(docking_controller))
			log_error("Could not find docking controller for shuttle waypoint '[name]', docking tag was '[docking_tag]'.")
		if(GLOB.using_map.use_overmap)
			var/obj/effect/overmap/location = map_sectors["[z]"]
			if(location && location.docking_codes)
				docking_controller.docking_codes = location.docking_codes

	SSshuttle.register_landmark(landmark_tag, src)

//Called when the landmark is added to an overmap sector.
/obj/effect/shuttle_landmark/proc/sector_set(var/obj/effect/overmap/O)

/obj/effect/shuttle_landmark/proc/is_valid(var/datum/shuttle/shuttle)
	if(shuttle.current_location == src)
		return FALSE
	for(var/area/A in shuttle.shuttle_area)
		var/list/translation = get_turf_translation(get_turf(shuttle.current_location), get_turf(src), A.contents)
		if(check_collision(base_area, list_values(translation)))
			return FALSE
	return TRUE

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
/obj/effect/shuttle_landmark/automatic
	name = "Navpoint"
	landmark_tag = "navpoint"
	autoset = 1
	var/shuttle_restricted //name of the shuttle, null for generic waypoint

/obj/effect/shuttle_landmark/automatic/Initialize()
	landmark_tag += "-[x]-[y]-[z]"
	return ..()

/obj/effect/shuttle_landmark/automatic/sector_set(var/obj/effect/overmap/O)
	..()
	SetName("[O.name] - [name]")

//Subtype that calls explosion on init to clear space for shuttles
/obj/effect/shuttle_landmark/automatic/clearing
	var/radius = 10

/obj/effect/shuttle_landmark/automatic/clearing/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/shuttle_landmark/automatic/clearing/LateInitialize()
	for(var/turf/T in range(radius, src))
		if(T.density)
			T.ChangeTurf(get_base_turf_by_area(T))

/obj/item/device/spaceflare
	name = "bluespace flare"
	desc = "Burst transmitter used to broadcast all needed information for shuttle navigation systems. Has a flare attached for marking the spot where you probably shouldn't be standing."
	icon_state = "bluflare"
	light_color = "#3728ff"
	var/active

/obj/item/device/spaceflare/attack_self(var/mob/user)
	if(!active)
		visible_message("<span class='notice'>[user] pulls the cord, activating the [src].</span>")
		activate()

/obj/item/device/spaceflare/proc/activate()
	if(active)
		return
	var/turf/T = get_turf(src)
	var/mob/M = loc
	if(istype(M) && !M.unEquip(src, T))
		return

	active = 1
	anchored = 1

	var/obj/effect/shuttle_landmark/automatic/mark = new(T)
	mark.SetName("Beacon signal ([T.x],[T.y])")
	T.hotspot_expose(1500, 5)
	update_icon()

/obj/item/device/spaceflare/update_icon()
	if(active)
		icon_state = "bluflare_on"
		set_light(0.3, 0.1, 6, 2, "85d1ff")