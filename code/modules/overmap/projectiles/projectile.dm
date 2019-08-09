/obj/effect/overmap/projectile
	name = "projectile"
	icon_state = "projectile"
	sector_flags = OVERMAP_SECTOR_KNOWN // technically in space, but you can't visit the missile during its flight

	var/obj/structure/missile/actual_missile = null

	var/walking = FALSE // walking towards something on the overmap?
	var/moving = FALSE // is the missile moving on the overmap?
	var/dangerous = FALSE
	var/should_enter_zs = FALSE

/obj/effect/overmap/projectile/Initialize(var/maploading, var/sx, var/sy)
	start_x = sx
	start_y = sy

	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/overmap/projectile/Destroy()
	if(!QDELETED(actual_missile))
		QDEL_NULL(actual_missile)
	actual_missile = null

	. = ..()

/obj/effect/overmap/projectile/Bump(var/atom/A)
	if(istype(A,/turf/unsimulated/map/edge))
		// Destroy() in the missile will qdel this object as well
		qdel(actual_missile)
	..()

/obj/effect/overmap/projectile/proc/set_missile(var/obj/structure/missile/missile)
	actual_missile = missile

/obj/effect/overmap/projectile/proc/set_dangerous(var/is_dangerous)
	dangerous = is_dangerous

/obj/effect/overmap/projectile/proc/set_moving(var/is_moving)
	moving = is_moving

/obj/effect/overmap/projectile/proc/set_enter_zs(var/enter_zs)
	should_enter_zs = enter_zs

/obj/effect/overmap/projectile/get_scan_data(mob/user)
	. = ..()
	. += "<br>General purpose projectile frame"
	. += "<br>Additional information:<br>[get_additional_info()]"

/obj/effect/overmap/projectile/proc/get_additional_info()
	if(actual_missile)
		return actual_missile.get_additional_info()
	return "N/A"

/obj/effect/overmap/projectile/proc/move_to(var/datum/target, var/min_speed, var/speed)
	if(isnull(target) || !speed)
		walk(src, 0)
		walking = FALSE
		update_icon()
		return

	walk_towards(src, target, min_speed - speed)
	walking = TRUE
	update_icon()

/obj/effect/overmap/projectile/Process()
	// Whether overmap movement occurs is controlled by the missile itself
	if(!moving)
		return

	check_enter()

	// let equipment alter speed/course
	for(var/obj/item/missile_equipment/E in actual_missile.equipment)
		E.do_overmap_work(src)

	update_icon()

// Checks if the missile should enter the z level of an overmap object
/obj/effect/overmap/projectile/proc/check_enter()
	if(!should_enter_zs)
		return

	var/list/potential_levels
	var/turf/T = get_turf(src)
	for(var/obj/effect/overmap/O in T)
		if(!LAZYLEN(O.map_z))
			continue

		LAZYINITLIST(potential_levels)
		potential_levels[O] = 0

		// Missile equipment "votes" on what to enter
		for(var/obj/item/missile_equipment/E in actual_missile.equipment)
			if(E.should_enter(O))
				potential_levels[O]++

	// Nothing to enter
	if(!LAZYLEN(potential_levels))
		return

	var/total_votes = 0
	for(var/O in potential_levels)
		total_votes += potential_levels[O]

	// Default behavior, just enter the first thing in space we encounter
	if(!total_votes)
		// Must be in motion for this to happen
		if(!walking)
			return

		for(var/obj/effect/overmap/O in potential_levels)
			if((O.sector_flags & OVERMAP_SECTOR_IN_SPACE))
				actual_missile.enter_level(pick(O.map_z))
	else // Enter the thing with most "votes"
		var/obj/effect/overmap/winner = pick(potential_levels)
		for(var/O in potential_levels)
			if(potential_levels[O] > potential_levels[winner])
				winner = O
		actual_missile.enter_level(pick(winner.map_z))

/obj/effect/overmap/projectile/on_update_icon()
	icon_state = "projectile"
	if(walking)
		icon_state += "_moving"

	if(dangerous)
		icon_state += "_danger"