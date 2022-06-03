//Load a random map template from the list. Maploader handles it to avoid order of init madness
/obj/effect/landmark/map_load_mark
	name = "map loader landmark"
	var/list/templates	//list of template types to pick from

//Throw things in the area around randomly
/obj/effect/landmark/carnage_mark
	name = "carnage landmark"
	var/movement_prob = 50	// a chance random unanchored item in the room will be moved randomly
	var/movement_range = 3  // how far would items get thrown

/obj/effect/landmark/carnage_mark/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/effect/landmark/carnage_mark/LateInitialize()
	var/area/A = get_area(src)
	for(var/atom/movable/AM in A)
		if(AM && !AM.anchored && AM.simulated && prob(movement_prob))
			spawn()
				AM.throw_at_random(FALSE, movement_range, 1)
	qdel(src)

//Clears walls
/obj/effect/landmark/clear
	name = "clear turf"
	icon_state = "clear"
	delete_me = TRUE

/obj/effect/landmark/clear/Initialize()
	var/turf/simulated/wall/W = get_turf(src)
	if(istype(W))
		W.dismantle_wall(TRUE, TRUE)
	var/turf/simulated/mineral/M = W
	if(istype(M))
		M.GetDrilled()
	. = ..()

//Applies fire act to the turf
/obj/effect/landmark/scorcher
	name = "fire"
	icon_state = "fire"
	var/temp = T0C + 3000

/obj/effect/landmark/scorcher/Initialize()
	var/turf/simulated/T = get_turf(src)
	if(istype(T))
		T.fire_act(exposed_temperature = temp)
	. = ..()

//Delete specified things when a specified shuttle moves
/obj/effect/landmark/delete_on_shuttle
	var/shuttle_name
	var/shuttle_datum
	var/list/typetodelete = list(/obj/machinery, /obj/item/gun, /mob/living/exosuit, /obj/item/device/transfer_valve)

/obj/effect/landmark/delete_on_shuttle/Initialize()
	. = ..()
	GLOB.shuttle_added.register_global(src, .proc/check_shuttle)

/obj/effect/landmark/delete_on_shuttle/proc/check_shuttle(var/shuttle)
	if(SSshuttle.shuttles[shuttle_name] == shuttle)
		GLOB.shuttle_moved_event.register(shuttle, src, .proc/delete_everything)
		shuttle_datum = shuttle

/obj/effect/landmark/delete_on_shuttle/proc/delete_everything()
	for(var/O in loc)
		if(is_type_in_list(O,typetodelete))
			qdel(O)
	qdel(src)

/obj/effect/landmark/delete_on_shuttle/Destroy()
	GLOB.shuttle_added.unregister_global(src, .proc/check_shuttle)
	if(shuttle_datum)
		GLOB.shuttle_moved_event.unregister(shuttle_datum, src, .proc/delete_everything)
	. = ..()
