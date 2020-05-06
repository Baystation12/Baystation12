
/obj/effect/overmap/ship
	name = "generic ship"
	desc = "Space faring vessel."
	icon_state = "ship"
	var/icon_state_moving = "ship_moving"
	var/vessel_mass = 100 				//tonnes, arbitrary number, affects acceleration provided by engines
	var/default_delay = 6 SECONDS 		//time it takes to move to next tile on overmap
	var/list/speed = list(0,0)			//speed in x,y direction
	var/last_burn = 0					//worldtime when ship last acceleated
	var/list/last_movement = list(0,0)	//worldtime when ship last moved in x,y direction
	var/fore_dir = NORTH				//what dir ship flies towards for purpose of moving stars effect procs

	var/obj/machinery/computer/helm/nav_control
	var/obj/machinery/nav_computer/nav_comp
	var/list/engines = list()
	var/engines_state = 1 //global on/off toggle for all engines
	var/thrust_limit = 1 //global thrust limit for all engines, 0..1

	var/datum/npc_fleet/our_fleet
	var/ship_max_speed = SHIP_DEFAULT_PIXEL_SPEED
	var/ship_acceleration = SHIP_DEFAULT_PIXEL_ACCEL

	var/moving_dir = 0
	var/lock_thrust = 0
	var/braking = 0

/obj/effect/overmap/ship/New()
	. = ..()
	our_fleet = new(src)

/obj/effect/overmap/ship/Initialize()
	. = ..()
	for(var/datum/ship_engine/E in ship_engines)
		if (E.holder.z in map_z)
			engines |= E
	for(var/obj/machinery/computer/engines/E in GLOB.machines)
		if (E.z in map_z)
			E.linked = src
			testing("Engines console at level [E.z] linked to overmap object '[name]'.")
	for(var/obj/machinery/computer/helm/H in GLOB.machines)
		if (H.z in map_z)
			nav_control = H
			H.linked = src
			H.get_known_sectors()
			testing("Helm console at level [H.z] linked to overmap object '[name]'.")
	for(var/obj/machinery/computer/navigation/N in GLOB.machines)
		if (N.z in map_z)
			N.linked = src
			testing("Navigation console at level [N.z] linked to overmap object '[name]'.")
	GLOB.processing_objects.Add(src)

	my_pixel_transform = init_pixel_transform(src)
	my_pixel_transform.max_pixel_speed = ship_max_speed
	my_pixel_transform.my_observers = my_observers

/obj/effect/overmap/ship/proc/assign_fleet(var/assign)
	if(our_fleet == assign)
		return
	if(our_fleet.leader_ship == src)
		our_fleet.ships_infleet -= src
		if(our_fleet.ships_infleet > 0)
			our_fleet.assign_leader(pick(our_fleet.ships_infleet))
		else
			qdel(our_fleet)
	our_fleet = assign

/obj/effect/overmap/ship/generate_targetable_areas()
	if(isnull(parent_area_type))
		return
	var/list/areas_scanthrough = typesof(parent_area_type) - parent_area_type
	if(areas_scanthrough.len == 0)
		return
	for(var/a in areas_scanthrough)
		var/area/located_area = locate(a)
		if(isnull(located_area))
			continue
		var/low_x = 255
		var/upper_x = 0
		var/low_y = 255
		var/upper_y = 0
		for(var/turf/t in located_area.contents)
			if(t.x < low_x)
				low_x = t.x
			if(t.y < low_y)
				low_y = t.y
			if(t.x > upper_x)
				upper_x = t.x
			if(t.y > upper_y)
				upper_y = t.x
		var/list/co_ords_assign = list(0,0,255,255) //Default list, if anything else fails.
		if(fore_dir == EAST || WEST)
			co_ords_assign = list(low_x,map_bounds[2],upper_x,map_bounds[4])
		else
			co_ords_assign = list(map_bounds[1],upper_y,map_bounds[3],low_y)
		targeting_locations["[located_area.name]"] = co_ords_assign

/obj/effect/overmap/ship/get_faction()
	if(nav_comp)
		return nav_comp.get_faction()
	else
		return null

/obj/effect/overmap/ship/Move(var/newloc,var/dir)
	. = ..()
	break_umbilicals()

/obj/effect/overmap/ship/relaymove(mob/user, direction)
	if(world.time < ticker.mode.ship_lockdown_until)
		to_chat(user,"<span class = 'notice'>The ship is still finalising deployment preparations!</span>")
		return
	if(moving_dir == direction)
		moving_dir = 0
	else
		braking = 0
		if(lock_thrust)
			moving_dir = direction
		accelerate(direction)

/obj/effect/overmap/ship/proc/is_still()
	return my_pixel_transform.is_still()
	//return !(speed[1] || speed[2])

//Projected acceleration based on information from engines
/obj/effect/overmap/ship/proc/get_acceleration()
	return ship_acceleration
	//return round(get_total_thrust()/vessel_mass, 0.1)

//Does actual burn and returns the resulting acceleration
/obj/effect/overmap/ship/proc/get_burn_acceleration()
	return round(burn() / vessel_mass, 0.1)

/obj/effect/overmap/ship/proc/get_speed()
	return round(sqrt(my_pixel_transform.pixel_speed_x*my_pixel_transform.pixel_speed_x + my_pixel_transform.pixel_speed_y*my_pixel_transform.pixel_speed_y), 0.1)

/obj/effect/overmap/ship/proc/get_heading()
	return my_pixel_transform.heading

/*
/obj/effect/overmap/ship/proc/adjust_speed(n_x, n_y)
	speed[1] = round(Clamp(speed[1] + n_x, -default_delay, default_delay),0.1)
	speed[2] = round(Clamp(speed[2] + n_y, -default_delay, default_delay),0.1)
	for(var/zz in map_z)
		if(is_still())
			toggle_move_stars(zz)
		else
			toggle_move_stars(zz, fore_dir)
	update_icon()
	*/

/obj/effect/overmap/ship/proc/get_brake_path()
	if(!get_acceleration())
		return INFINITY
	return get_speed()/get_acceleration()

/obj/effect/overmap/ship/proc/brake()
	moving_dir = 0
	if(braking)
		braking = 0
	else if(lock_thrust)
		braking = 1
	decelerate()

/obj/effect/overmap/ship/proc/decelerate()
	if(!is_still() && can_burn())
		my_pixel_transform.brake(get_acceleration())
		/*
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(get_burn_acceleration(),abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(get_burn_acceleration(),abs(speed[2])))
			*/
		last_burn = world.time
		if(is_still())
			icon_state = initial(icon_state)
		else
			icon_state = icon_state_moving

/obj/effect/overmap/ship/proc/accelerate(direction)
	if(can_burn())
		last_burn = world.time

		my_pixel_transform.add_pixel_speed_direction(get_acceleration(), direction)
		my_pixel_transform.turn_to_dir(direction, 15)
		icon_state = icon_state_moving
		/*
		if(direction & EAST)
			adjust_speed(get_burn_acceleration(), 0)
		if(direction & WEST)
			adjust_speed(-get_burn_acceleration(), 0)
		if(direction & NORTH)
			adjust_speed(0, get_burn_acceleration())
		if(direction & SOUTH)
			adjust_speed(0, -get_burn_acceleration())
			*/

/obj/effect/overmap/ship/process()
	. = ..()
	if(moving_dir)
		accelerate(moving_dir)
		if(!lock_thrust)
			moving_dir = 0
			icon_state = initial(icon_state)
	else if(braking)
		decelerate()
		if(!lock_thrust)
			braking = 0
			icon_state = initial(icon_state)
/*
	if(!is_still())
		var/list/deltas = list(0,0)
		for(var/i=1, i<=2, i++)
			if(speed[i] && world.time > last_movement[i] + default_delay - abs(speed[i]))
				deltas[i] = speed[i] > 0 ? 1 : -1
				last_movement[i] = world.time
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		break_umbilicals()
		if(newloc)
			Move(newloc)
		update_icon()
		*/

/obj/effect/overmap/ship/proc/break_umbilicals(var/force_break = 0)
	for(var/obj/docking_umbilical/umbi in connectors)
		if(isnull(umbi))
			connectors -= umbi
			continue
		if(force_break || (umbi.current_connected && get_dist(umbi.our_ship,umbi.current_connected.our_ship) > 1))
			if(umbi.current_connected)
				umbi.current_connected.umbi_rip()
			umbi.umbi_rip()

/obj/effect/overmap/ship/do_superstructure_fail()
	break_umbilicals(1)
	. = ..()

/obj/effect/overmap/ship/Crossed(var/obj/item/projectile/crosser)
	if(istype(crosser))
		crosser.Bump(src)
	. = ..()

/*
/obj/effect/overmap/ship/update_icon()
	if(!is_still())
		icon_state = "ship_moving"
		dir = get_heading()
	else
		icon_state = "ship"
		*/

/obj/effect/overmap/ship/proc/burn()
	for(var/datum/ship_engine/E in engines)
		. += E.burn()

/obj/effect/overmap/ship/proc/get_total_thrust()
	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()

/obj/effect/overmap/ship/proc/can_burn()
	if (world.time < last_burn + 10)
		return 0
	for(var/datum/ship_engine/E in engines)
		. |= E.can_burn()
