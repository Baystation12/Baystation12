/datum/persistence
	var/version = 1

/datum/proc/after_save()

/datum/proc/before_save()

/turf/simulated/before_save()
	if(zone)
		c_copy_air()

/datum/proc/after_deserialize()

/datum
	var/should_save = TRUE

/obj/effect/expl_particles
	should_save = FALSE

/obj/effect/explosion
	should_save = FALSE

/datum/effect/system/explosion
	should_save = FALSE

/atom/movable/lighting_overlay
	should_save = FALSE

/obj/effect/effect/foam
	should_save = FALSE

/mob/observer
	should_save = FALSE

/obj/after_deserialize()
	..()
	queue_icon_update()

/obj/machinery/embedded_controller
	var/saved_memory
/obj/machinery/embedded_controller/before_save()
	..()
	saved_memory = program.memory
/obj/machinery/embedded_controller/after_deserialize()
	..()
	if(saved_memory)
		program.memory = saved_memory

// /obj/machinery/door/firedoor/after_deserialize()
// 	for(var/obj/machinery/door/firedoor/F in loc)
// 		if(F != src)
// 			return INITIALIZE_HINT_QDEL
// 	var/area/A = get_area(src)
// 	ASSERT(istype(A))

// 	LAZYADD(A.all_doors, src)
// 	areas_added = list(A)

// 	for(var/direction in GLOB.cardinal)
// 		A = get_area(get_step(src,direction))
// 		if(istype(A) && !(A in areas_added))
// 			LAZYADD(A.all_doors, src)
// 			areas_added += A

/obj/item/weapon/storage/after_deserialize()
	..()
	startswith = 0

/obj/item/weapon/tank/after_deserialize()
	..()
	starting_pressure = 0

/obj/item/weapon/extinguisher/after_deserialize()
	..()
	starting_water = 0	

/obj/structure/cable/after_deserialize()
	..()
	var/turf/T = src.loc			// hide if turf is not intact
	if(level==1) hide(!T.is_plating())

/obj/machinery/power/terminal/after_deserialize()
	..()
	var/turf/T = src.loc
	if(level==1) hide(!T.is_plating())

/obj/machinery/after_deserialize()
	..()
	uncreated_component_parts = list() // We don't want to create more parts.
	power_change()

/turf/space/after_deserialize()
	..()
	for(var/atom/movable/lighting_overlay/overlay in contents)
		overlay.loc = null
		qdel(overlay)

/turf/after_deserialize()
	..()
	queue_icon_update()
	if(dynamic_lighting)
		lighting_build_overlay()
	else
		lighting_clear_overlay()

// /zone/after_deserialize()
// 	..()
// 	needs_update = TRUE

/atom/movable/lighting_overlay/after_deserialize()
	loc = null
	qdel(src)

/area/after_deserialize()
	power_change()

/datum/proc/get_saved_vars()
	return GLOB.saved_vars[type] || get_default_vars()

/datum/proc/get_default_vars()
	var/savedlist = list()
	for(var/v in vars)
		if(issaved(vars[v]) && !(v in GLOB.blacklisted_vars))
			LAZYADD(savedlist, v)
	return savedlist

/area/proc/get_turf_coords()
	var/list/coord_list = list()
	for(var/turf/T in contents)
		coord_list.Add("[T.x],[T.y],[T.z]")
	return coord_list
