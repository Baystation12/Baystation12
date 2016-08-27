/obj/effect/map/ship
	name = "generic ship"
	desc = "Space faring vessel."
<<<<<<< HEAD
	icon = 'icons/obj/ship_battles.dmi'
=======
>>>>>>> 0b4cb4dda55c69006c7065b8e53f93e75d17612e
	icon_state = "ship"
	var/vessel_mass = 9000 //tonnes, random number
	var/default_delay = 60
	var/list/speed = list(0,0)
	var/last_burn = 0
	var/list/last_movement = list(0,0)
	var/fore_dir = NORTH
	var/rotate = 1 //For proc rotate

	var/obj/effect/map/current_sector
	var/obj/machinery/space_battle/helm/nav_control
	var/list/eng_controls = list()

/obj/effect/map/ship/initialize()
<<<<<<< HEAD
	for(var/obj/machinery/space_battle/engine_control/E in world)
		if (E.z == map_z && !(E in eng_controls))
			eng_controls.Add(E)
	for(var/obj/machinery/space_battle/helm/H in machines)
		if (H.z == map_z)
=======
	for(var/obj/machinery/computer/engines/E in machines)
		if (E.z in map_z)
			eng_control = E
			break
	for(var/obj/machinery/computer/helm/H in machines)
		if (H.z in map_z)
>>>>>>> 0b4cb4dda55c69006c7065b8e53f93e75d17612e
			nav_control = H
			break
	processing_objects.Add(src)

/obj/effect/map/ship/relaymove(mob/user, direction)
	accelerate(direction)

/obj/effect/map/ship/proc/is_still()
	return !(speed[1] || speed[2])

/obj/effect/map/ship/proc/get_acceleration()
<<<<<<< HEAD
	var/thrust = 0
	for(var/obj/machinery/space_battle/engine_control/E in eng_controls)
		thrust += E.get_total_thrust()/vessel_mass
	return thrust
=======
	return round(eng_control.get_total_thrust()/vessel_mass, 0.1)
>>>>>>> 0b4cb4dda55c69006c7065b8e53f93e75d17612e

/obj/effect/map/ship/proc/get_speed()
	return round(sqrt(speed[1]*speed[1] + speed[2]*speed[2]), 0.1)

/obj/effect/map/ship/proc/get_heading()
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

/obj/effect/map/ship/proc/adjust_speed(n_x, n_y)
	speed[1] = Clamp(speed[1] + n_x, -default_delay, default_delay)
	speed[2] = Clamp(speed[2] + n_y, -default_delay, default_delay)
<<<<<<< HEAD
	if(is_still())
		toggle_move_stars(map_z)
		for(var/obj/machinery/space_battle/engine_control/E in eng_controls)
			E.stopped()
	else
		toggle_move_stars(map_z, fore_dir)
=======
	for(var/zz in map_z)
		if(is_still())
			toggle_move_stars(zz)
		else
			toggle_move_stars(zz, fore_dir)
>>>>>>> 0b4cb4dda55c69006c7065b8e53f93e75d17612e

/obj/effect/map/ship/proc/can_burn()
	if (!eng_controls.len)
		return 0
	if (world.time < last_burn + 10)
		return 0
	var/can_burn = 0
	for(var/obj/machinery/space_battle/engine_control/E in eng_controls)
		if(E.burn())
			can_burn = 1
	return can_burn

/obj/effect/map/ship/proc/get_brake_path()
	if(!get_acceleration())
		return INFINITY
	return get_speed()/get_acceleration()

#define SIGN(X) (X == 0 ? 0 : (X > 0 ? 1 : -1))
/obj/effect/map/ship/proc/decelerate()
	if(!is_still() && can_burn())
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(get_acceleration(),abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(get_acceleration(),abs(speed[2])))
		last_burn = world.time

/obj/effect/map/ship/proc/accelerate(direction)
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


/obj/effect/map/ship/proc/rotate(var/direction)
	var/matrix/M = matrix()
	M.Turn(dir2angle(direction))
	src.transform = M //Rotate ship

/obj/effect/map/ship/process()
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
