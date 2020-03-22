/datum/persistence
	var/version = 1

/datum/proc/after_save()

/datum/proc/before_save()

/datum/proc/after_deserialize()

/datum
	var/should_save = TRUE

/atom/movable/lighting_overlay
	should_save = FALSE

/area
	should_save = FALSE

/mob/observer
	should_save = FALSE

/obj/after_deserialize()
	..()
	queue_icon_update()

/obj/structure/cable/after_deserialize()
	var/turf/T = src.loc			// hide if turf is not intact
	if(level==1) hide(!T.is_plating())

/obj/machinery/power/terminal/after_deserialize()
	var/turf/T = src.loc
	if(level==1) hide(!T.is_plating())

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
	var/ind = 0
	for(var/turf/T in contents)
		ind++
		coord_list += "[ind]"
		coord_list[ind] = list(T.x, T.y, T.z)
	return coord_list