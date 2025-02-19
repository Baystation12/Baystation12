// Uses Lorentzian dynamics to avoid going too fast.
#define SENSOR_COEFFICENT 1000
/obj/overmap/visitable/ship
	name = "generic ship"
	desc = "Space faring vessel."
	icon_state = "ship"
	requires_contact = TRUE
	movable = TRUE
	randomize_start_pos = FALSE

	var/list/consoles
	var/list/sensors

	var/vessel_mass = 10000             // tonnes, arbitrary number, affects acceleration provided by engines
	var/vessel_size = SHIP_SIZE_LARGE	// arbitrary number, affects how likely are we to evade meteors
	var/max_autopilot = 1 / (10 SECONDS) // The maximum speed any attached helm can try to autopilot at.

	var/last_burn = 0                   // worldtime when ship last acceleated
	var/burn_delay = 1 SECOND           // how often ship can do burns
	var/fore_dir = NORTH                // what dir ship flies towards for purpose of moving stars effect procs

	/// How much it increases identification process each scan
	var/base_sensor_visibility = 10

	var/list/navigation_viewers // list of weakrefs to people viewing the overmap via this ship

	var/list/engines = list()
	var/engines_state = 0 //global on/off toggle for all engines
	var/thrust_limit = 1  //global thrust limit for all engines, 0..1
	var/skill_needed = SKILL_TRAINED  //piloting skill needed to steer it without going in random dir
	var/operator_skill

/obj/overmap/visitable/ship/Initialize()
	. = ..()
	glide_size = world.icon_size
	SSshuttle.ships += src
	base_sensor_visibility = initial(base_sensor_visibility) + round(sqrt(vessel_mass/SENSOR_COEFFICENT),1)

/obj/overmap/visitable/ship/Destroy()
	SSshuttle.ships -= src
	if(length(consoles))
		for(var/obj/machinery/computer/ship/machine in consoles)
			if(machine.linked == src)
				machine.linked = null
		consoles = null
	if (length(sensors))
		for (var/obj/machinery/shipsensors/machine in sensors)
			if (machine.linked == src)
				machine.linked = null
		sensors = null
	. = ..()

/obj/overmap/visitable/ship/relaymove(mob/user, direction, accel_limit)
	accelerate(direction, accel_limit)
	update_operator_skill(user)

/**
 * Updates `operator_skill` to match the current user's skill level, or to null if no user is provided.
 * Will skip observers to avoid allowing unintended external influences on flight.
 */
/obj/overmap/visitable/ship/proc/update_operator_skill(mob/user)
	if (isobserver(user))
		return
	operator_skill = user?.get_skill_value(SKILL_PILOT)

/obj/overmap/visitable/ship/get_scan_data(mob/user)
	. = ..()
	var/list/extra_data = list("Mass: [vessel_mass] tons.")
	if(is_moving())
		extra_data += "Heading: [get_heading_angle()], speed [get_speed() * 1000]"
	if(instant_contact)
		extra_data += "<b>It is broadcasting a distress signal.</b>"
	. += jointext(extra_data, "<br>")


//Projected acceleration based on information from engines
/obj/overmap/visitable/ship/proc/get_acceleration()
	return round(get_total_thrust()/get_vessel_mass(), GLOB.overmap_move_resolution)

//Does actual burn and returns the resulting acceleration
/obj/overmap/visitable/ship/proc/get_burn_acceleration()
	return round(burn() / get_vessel_mass(), GLOB.overmap_move_resolution)

/obj/overmap/visitable/ship/proc/get_vessel_mass()
	. = vessel_mass
	for(var/obj/overmap/visitable/ship/ship in src)
		. += ship.get_vessel_mass()

/obj/overmap/visitable/ship/adjust_speed(n_x, n_y)
	. = ..()
	for(var/zz in map_z)
		if(!is_moving())
			toggle_move_stars(zz)
		else
			toggle_move_stars(zz, fore_dir)

/obj/overmap/visitable/ship/proc/get_brake_path()
	if(!get_acceleration())
		return INFINITY
	if(!is_moving())
		return 0
	if(!burn_delay)
		return 0
	var/num_burns = get_speed()/get_acceleration() + 2 //some padding in case acceleration drops form fuel usage
	var/burns_per_grid = 1/ (burn_delay * get_speed())
	return round(num_burns/burns_per_grid)

/obj/overmap/visitable/ship/proc/decelerate(accel_limit)
	if ((!speed[1] && !speed[2]) || !can_burn())
		return
	last_burn = world.time
	var/delta = accel_limit ? min(get_burn_acceleration(), accel_limit) : get_burn_acceleration()
	var/mag = sqrt(speed[1] ** 2 + speed[2] ** 2)
	if (delta >= mag)
		adjust_speed(-speed[1], -speed[2])
	else
		adjust_speed(-(speed[1] * delta) / mag, -(speed[2] * delta) / mag)

/obj/overmap/visitable/ship/proc/accelerate(direction, accel_limit)
	if (!direction || !can_burn())
		return
	last_burn = world.time
	var/delta = accel_limit ? min(get_burn_acceleration(), accel_limit) : get_burn_acceleration()
	var/dx = (direction & EAST) ? 1 : ((direction & WEST) ? -1 : 0)
	var/dy = (direction & NORTH) ? 1 : ((direction & SOUTH) ? -1 : 0)
	if (dx && dy)
		dx *= 0.5
		dy *= 0.5
	adjust_speed(delta * dx, delta * dy)

/obj/overmap/visitable/ship/Process()
	. = ..()
	sensor_visibility = min(round(base_sensor_visibility + get_speed_sensor_increase(), 1), 100)

/obj/overmap/visitable/ship/on_update_icon()
	..()

	for(var/obj/machinery/computer/ship/machine in consoles)
		if(machine.z in map_z)
			for(var/weakref/W in machine.viewers)
				var/mob/M = W.resolve()
				if(istype(M) && M.client)
					M.client.pixel_x = pixel_x
					M.client.pixel_y = pixel_y

/obj/overmap/visitable/ship/proc/burn()
	for(var/datum/ship_engine/E in engines)
		. += E.burn()

/obj/overmap/visitable/ship/proc/get_total_thrust()
	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()

/obj/overmap/visitable/ship/proc/can_burn()
	if(halted)
		return 0
	if (world.time < last_burn + burn_delay)
		return 0
	for(var/datum/ship_engine/E in engines)
		. |= E.can_burn()

//deciseconds to next step
/obj/overmap/visitable/ship/proc/ETA()
	. = INFINITY
	for(var/i = 1 to 2)
		if(abs(speed[i]) >= min_speed)
			. = min(., ((speed[i] > 0 ? 1 : -1) - position[i]) / speed[i])
	. = max(ceil(.),0)

/obj/overmap/visitable/ship/unhalt()
	if(!SSshuttle.overmap_halted)
		halted = FALSE

/obj/overmap/visitable/ship/proc/get_helm_skill()//delete this mover operator skill to overmap obj
	return operator_skill

/obj/overmap/visitable/ship/populate_sector_objects()
	..()
	for(var/obj/machinery/computer/ship/S in SSmachines.machinery)
		S.attempt_hook_up(src)
	for(var/datum/ship_engine/E in ship_engines)
		if(check_ownership(E.holder))
			engines |= E

/obj/overmap/visitable/ship/proc/get_landed_info()
	return "This ship cannot land."

/obj/overmap/visitable/ship/proc/get_speed_sensor_increase()
	return min(get_speed() * 1000, 50) //Engines should never increase sensor visibility by more than 50.
