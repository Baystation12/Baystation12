/obj/effect/overmap/ship
	name = "generic ship"
	desc = "Space faring vessel."
	icon_state = "ship"
	var/vessel_mass = 100 				//tonnes, arbitrary number, affects acceleration provided by engines
	var/default_delay = 6 SECONDS 		//time it takes to move to next tile on overmap
	var/speed_mod = 10					//multiplier for how much ship's speed reduces above time
	var/list/speed = list(0,0)			//speed in x,y direction
	var/last_burn = 0					//worldtime when ship last acceleated
	var/burn_delay = 10					//how often ship can do burns
	var/list/last_movement = list(0,0)	//worldtime when ship last moved in x,y direction
	var/fore_dir = NORTH				//what dir ship flies towards for purpose of moving stars effect procs

	var/obj/machinery/computer/ship/helm/nav_control
	var/list/engines = list()
	var/engines_state = 1 //global on/off toggle for all engines
	var/thrust_limit = 1 //global thrust limit for all engines, 0..1

/obj/effect/overmap/ship/Initialize()
	. = ..()
	START_PROCESSING(SSobj, src)

/obj/effect/overmap/ship/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/effect/overmap/ship/relaymove(mob/user, direction)
	accelerate(direction)

/obj/effect/overmap/ship/proc/is_still()
	return !(speed[1] || speed[2])

//Projected acceleration based on information from engines
/obj/effect/overmap/ship/proc/get_acceleration()
	return round(get_total_thrust()/vessel_mass, 0.1)

//Does actual burn and returns the resulting acceleration
/obj/effect/overmap/ship/proc/get_burn_acceleration()
	return round(burn() / vessel_mass, 0.1)

/obj/effect/overmap/ship/proc/get_speed()
	return round(sqrt(speed[1]*speed[1] + speed[2]*speed[2]), 0.1)

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
	speed[1] = round(Clamp(speed[1] + n_x, -default_delay, default_delay),0.1)
	speed[2] = round(Clamp(speed[2] + n_y, -default_delay, default_delay),0.1)
	for(var/zz in map_z)
		if(is_still())
			toggle_move_stars(zz)
		else
			toggle_move_stars(zz, fore_dir)
	update_icon()

/obj/effect/overmap/ship/proc/get_brake_path()
	if(!get_acceleration())
		return INFINITY
	var/num_burns = get_speed()/get_acceleration() + 2 //some padding in case acceleration drops form fuel usage
	var/burns_per_grid = (default_delay - speed_mod*get_speed())/burn_delay
	return round(num_burns/burns_per_grid)

/obj/effect/overmap/ship/proc/decelerate()
	if(!is_still() && can_burn())
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(get_burn_acceleration(),abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(get_burn_acceleration(),abs(speed[2])))
		last_burn = world.time

/obj/effect/overmap/ship/proc/accelerate(direction)
	if(can_burn())
		last_burn = world.time

		if(direction & EAST)
			adjust_speed(get_burn_acceleration(), 0)
		if(direction & WEST)
			adjust_speed(-get_burn_acceleration(), 0)
		if(direction & NORTH)
			adjust_speed(0, get_burn_acceleration())
		if(direction & SOUTH)
			adjust_speed(0, -get_burn_acceleration())

/obj/effect/overmap/ship/Process()
	if(!is_still())
		var/list/deltas = list(0,0)
		for(var/i=1, i<=2, i++)
			if(speed[i] && world.time > last_movement[i] + default_delay - speed_mod*abs(speed[i]))
				deltas[i] = speed[i] > 0 ? 1 : -1
				last_movement[i] = world.time
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc)
			Move(newloc)
			handle_wraparound()
		update_icon()

/obj/effect/overmap/ship/update_icon()
	if(!is_still())
		icon_state = "ship_moving"
		dir = get_heading()
	else
		icon_state = "ship"

/obj/effect/overmap/ship/proc/burn()
	for(var/datum/ship_engine/E in engines)
		. += E.burn()

/obj/effect/overmap/ship/proc/get_total_thrust()
	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()

/obj/effect/overmap/ship/proc/can_burn()
	if (world.time < last_burn + burn_delay)
		return 0
	for(var/datum/ship_engine/E in engines)
		. |= E.can_burn()
		
//deciseconds to next step
/obj/effect/overmap/ship/proc/ETA()
	. = INFINITY
	for(var/i=1, i<=2, i++)
		if(speed[i])
			. = min(last_movement[i] + default_delay - speed_mod*abs(speed[i]) - world.time, .)
	. = max(.,0)

/obj/effect/overmap/ship/proc/handle_wraparound()
	var/nx = x
	var/ny = y
	var/low_edge = 1
	var/high_edge = GLOB.using_map.overmap_size - 1

	if(dir == WEST && x == low_edge)
		nx = high_edge
	else if(dir == EAST && x == high_edge)
		nx = low_edge
	else if(dir == SOUTH  && y == low_edge)
		ny = high_edge
	else if(dir == NORTH && y == high_edge)
		ny = low_edge
	else
		return //we're not flying off anywhere

	var/turf/T = locate(nx,ny,z)
	if(T)
		forceMove(T)

/obj/effect/overmap/ship/Bump(var/atom/A)
	if(istype(A,/turf/unsimulated/map/edge))
		handle_wraparound()
	..()

/obj/effect/overmap/ship/proc/get_helm_skill()
	. = SKILL_MIN
	if(nav_control)
		. = nav_control.operator_skill || .

/obj/effect/overmap/ship/populate_sector_objects()
	..()
	for(var/obj/machinery/computer/ship/S in SSmachines.machinery)
		S.attempt_hook_up(src)
	for(var/datum/ship_engine/E in ship_engines)
		if(check_ownership(E.holder))
			engines |= E

// These come with shuttle functionality. Need to be assigned a (unique) shuttle datum name. 
// Mapping location doesn't matter, so long as on a map loaded at the same time as the shuttle areas.
// Multiz shuttles currently not supported. Non-autodock shuttles currently not supported.
/obj/effect/overmap/ship/landable
	var/shuttle                                         // Name of assotiated shuttle. Must be autodock.
	var/obj/effect/shuttle_landmark/ship/landmark       // Record our open space landmark for easy reference.

/obj/effect/overmap/ship/landable/Destroy()
	GLOB.shuttle_moved_event.unregister(SSshuttle.shuttles[shuttle], src)
	return ..()

/obj/effect/overmap/ship/landable/check_ownership(obj/object)
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	if(!shuttle_datum)
		return
	var/list/areas = shuttle_datum.find_childfree_areas()
	if(get_area(object) in areas)
		return 1

// We autobuild our z levels.
/obj/effect/overmap/ship/landable/find_z_levels()
	world.maxz++
	map_z += world.maxz
	// Not really the center, but rather where the shuttle landmark should be
	var/turf/center_loc = locate(round(world.maxx/2), round(world.maxy/2), world.maxz)
	landmark = new (center_loc, shuttle)
	add_landmark(landmark, shuttle)

/obj/effect/overmap/ship/landable/populate_sector_objects()
	..()
	var/datum/shuttle/shuttle_datum = SSshuttle.shuttles[shuttle]
	GLOB.shuttle_moved_event.register(shuttle_datum, src, .proc/on_shuttle_jump)
	on_landing(landmark, shuttle_datum.current_location) // We "land" at round start to properly place ourselves on the overmap.

/obj/effect/shuttle_landmark/ship
	name = "Open Space"
	landmark_tag = "ship"
	autoset = 1

/obj/effect/shuttle_landmark/ship/Initialize(shuttle_name)
	landmark_tag += "_[shuttle_name]"
	. = ..()

/obj/effect/shuttle_landmark/ship/Destroy()
	var/obj/effect/overmap/ship/landable/ship = map_sectors["z"]
	if(istype(ship) && ship.landmark == src)
		ship.landmark = null
	. = ..()

/obj/effect/overmap/ship/landable/proc/on_shuttle_jump(datum/shuttle/given_shuttle, obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(given_shuttle != SSshuttle.shuttles[shuttle])
		return
	var/datum/shuttle/autodock/auto = given_shuttle
	if(into == auto.landmark_transition || into == landmark)
		on_takeoff(from, into)
	else
		on_landing(from, into)

/obj/effect/overmap/ship/landable/proc/on_landing(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	var/obj/effect/overmap/target = map_sectors["[into.z]"]
	if(!target || target == src)
		return
	forceMove(target)

/obj/effect/overmap/ship/landable/proc/on_takeoff(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(!isturf(loc))
		forceMove(get_turf(loc))