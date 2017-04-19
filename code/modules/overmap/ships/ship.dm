/obj/effect/overmap/ship
	name = "generic ship"
	desc = "Space faring vessel."
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "ship"
	var/vessel_mass = 9000 //tonnes, random number
	var/default_delay = 60
	var/list/speed = list(0,0)
	var/last_burn = 0
	var/list/last_movement = list(0,0)
	var/fore_dir = NORTH
	var/rotate = 1 //For proc rotate

	var/obj/effect/overmap/current_sector
	var/obj/machinery/space_battle/computer/helm/nav_control
	var/list/eng_controls = list()
	var/braked = 1
	density = 1

/obj/effect/overmap/ship/Destroy()
	current_sector = null
	nav_control = null
	eng_controls.Cut()
	return ..()

/obj/effect/overmap/ship/initialize()
	..()
	for(var/obj/machinery/space_battle/computer/targeting/M in world)
		if (M.z in map_z)
			fire_controls.Add(M)
	for(var/obj/machinery/space_battle/computer/engine_control/E in machines)
		if (E.z in map_z)
			eng_controls += E
			E.linked = src
			E.zlevels = map_z
			E.reconnect()
			testing("Engines console at level [E.z] linked to overmap object '[name]'.")
	for(var/obj/machinery/space_battle/computer/helm/H in machines)
		if (H.z in map_z)
			nav_control = H
			H.linked = src
			H.get_known_sectors()
			testing("Helm console at level [H.z] linked to overmap object '[name]'.")
	processing_objects.Add(src)

/obj/effect/overmap/ship/relaymove(mob/user, direction)
	accelerate(direction)

/obj/effect/overmap/ship/proc/is_still()
	return !(speed[1] || speed[2])

/obj/effect/overmap/ship/proc/get_acceleration()
	var/thrust = 0
	for(var/obj/machinery/space_battle/computer/engine_control/E in eng_controls)
		thrust += E.get_total_thrust()/vessel_mass
	return thrust

/obj/effect/overmap/ship/proc/get_speed()
	return round(sqrt(speed[1]*speed[1] + speed[2]*speed[2]))

/obj/effect/overmap/ship/proc/get_heading()
	var/res = 0
	if(speed[1])
		if(speed[1] > 0)
			res |= EAST
		else
			res |= WEST
	if(speed[2])
		if(speed[2] > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

/obj/effect/overmap/ship/proc/adjust_speed(n_x, n_y)
	speed[1] = Clamp(speed[1] + n_x, -default_delay, default_delay)
	speed[2] = Clamp(speed[2] + n_y, -default_delay, default_delay)
	if(is_still())
		toggle_move_stars(map_z)
		if(!braked)
			var/obj/effect/overmap/station/S = locate() in src.loc
			if(S && istype(S))
				for(var/obj/machinery/space_battle/computer/engine_control/E in eng_controls)
					E.stopped()
				for(var/obj/machinery/space_battle/computer/targeting/M in fire_controls)
					M.find_targets()
	else
		toggle_move_stars(map_z, fore_dir)

/obj/effect/overmap/ship/proc/can_burn()
	if (!eng_controls.len)
		return 0
	if (world.time < last_burn + 10)
		return 0
	var/can_burn = 0
	for(var/obj/machinery/space_battle/computer/engine_control/E in eng_controls)
		if(E.burn())
			can_burn = 1
	return can_burn

/obj/effect/overmap/ship/proc/get_brake_path()
	if(!get_acceleration())
		return INFINITY
	return get_speed()/get_acceleration()

#define SIGN(X) (X == 0 ? 0 : (X > 0 ? 1 : -1))
/obj/effect/overmap/ship/proc/decelerate(var/forced = 0)
	if(!is_still() && (forced || can_burn()))
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(get_acceleration(),abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(get_acceleration(),abs(speed[2])))
		last_burn = world.time

/obj/effect/overmap/ship/proc/accelerate(direction)
	if(can_burn())
		last_burn = world.time

		if(direction & EAST)
			adjust_speed(get_acceleration(), 0)
		if(direction & WEST)
			adjust_speed(-get_acceleration(), 0)
		if(direction & NORTH)
			adjust_speed(0, get_acceleration())
		if(direction & SOUTH)
			adjust_speed(0, -get_acceleration())


/obj/effect/overmap/ship/proc/rotate(var/direction)
	var/matrix/M = matrix()
	M.Turn(dir2angle(direction))
	src.transform = M //Rotate ship

/obj/effect/overmap/ship/process()
	if(!is_still())
		var/list/deltas = list(0,0)
		for(var/i=1, i<=2, i++)
			if(speed[i] && world.time > last_movement[i] + default_delay - abs(speed[i]))
				deltas[i] = speed[i] > 0 ? 1 : -1
				last_movement[i] = world.time
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc)
			Move(newloc)
		if(rotate)
			rotate(get_heading())

/area/sector/shuttle/ship
	name = "\improper Ship Docking Area"
