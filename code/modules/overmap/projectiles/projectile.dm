/obj/effect/overmap/projectile
	name = "projectile"
	icon_state = "projectile"
	sector_flags = OVERMAP_SECTOR_KNOWN // technically in space, but you can't visit the missile during its flight

	var/list/velocity = list(0,0)
	var/list/last_movement = list(0,0)

	var/obj/structure/missile/actual_missile = null

	var/moving = FALSE
	var/dangerous = FALSE
	var/should_enter_zs = FALSE

/obj/effect/overmap/projectile/Initialize(var/maploading, var/sx, var/sy)
	start_x = sx
	start_y = sy

	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/overmap/projectile/Destroy()
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

/obj/effect/overmap/projectile/proc/set_velocity(var/vx, var/vy)
	velocity[1] = vx
	velocity[2] = vy

/obj/effect/overmap/projectile/proc/get_speed()
	return sqrt(velocity[1] ** 2 + velocity[2] ** 2)

/obj/effect/overmap/projectile/proc/get_heading()
	var/res = 0
	if(velocity[1])
		if(velocity[1] > 0)
			res |= EAST
		else
			res |= WEST
	if(velocity[2])
		if(velocity[2] > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

/obj/effect/overmap/projectile/proc/is_moving()
	return (velocity[1] != 0 || velocity[2] != 0)

/obj/effect/overmap/projectile/get_scan_data(mob/user)
	. = ..()
	. += "<br>[is_moving() ? "Heading: [dir2angle(get_heading())]deg, speed [get_speed() * 1000]" : "Not in motion"]"
	. += "<br>Additional information:<br>[get_additional_info()]"

/obj/effect/overmap/projectile/proc/get_additional_info()
	if(actual_missile)
		return actual_missile.get_additional_info()
	return "N/A"

/obj/effect/overmap/projectile/Process()
	// Whether overmap movement occurs is controlled by the missile itself
	if(!moving)
		return

	check_enter()

	// let equipment alter speed/course
	for(var/obj/item/missile_equipment/E in actual_missile.equipment)
		E.do_overmap_work(src)

	var/list/deltas = list(0,0)
	for(var/i=1, i<=2, i++)
		if(velocity[i] && world.time > last_movement[i] + 1/abs(velocity[i]))
			deltas[i] = SIGN(velocity[i])
			last_movement[i] = world.time

	if(deltas[1] != 0 || deltas[2] != 0)
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc)
			Move(newloc)

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
		if(velocity[1] == 0 && velocity[2] == 0)
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
	dir = get_heading()
	icon_state = "projectile"
	if(is_moving())
		icon_state += "_moving"

	if(dangerous)
		icon_state += "_danger"