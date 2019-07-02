// Very oversimplified engine/booster. It takes a target and instantly adjusts the speed of the projectile to move towards it
/obj/item/missile_equipment/thruster
	name = "missile booster"
	desc = "A simple but powerful and modular booster that can be fitted in most missiles. This one comes with an embedded targeting computer."
	icon_state = "target"

	cooldown = 5

	var/atom/target
	var/fuel = 60 // how many times can the engine do work until its out of fuel
	var/max_fuel = 100
	var/thrust = 0.0005

/obj/item/missile_equipment/thruster/do_overmap_work(var/obj/effect/overmap/projectile/P)
	if(!..() || isnull(target) || !fuel)
		return 0

	var/turf/T = get_turf(target)

	// Find the direct heading towards the target
	var/list/heading = list(0,0)
	if(T.x > P.x)
		heading[1] = 1
	else if(T.x < P.x)
		heading[1] = -1

	if(T.y > P.y)
		heading[2] = 1
	else if(T.y < P.y)
		heading[2] = -1

	var/heading_length = sqrt(heading[1]**2 + heading[2]**2)

	// This means we're at the target location
	if(heading_length == 0)
		P.set_velocity(0, 0)
		return 1

	var/list/normalized_heading = list(heading[1] / heading_length, heading[2] / heading_length)

	var/list/old_heading = list(0,0)
	var/heading_flag = P.get_heading()
	if(heading_flag & WEST)
		old_heading[1] = -1
	else if(heading_flag & EAST)
		old_heading[1] = 1

	if(heading_flag & NORTH)
		old_heading[2] = 1
	else if(heading_flag & SOUTH)
		old_heading[2] = -1

	var/speed = P.get_speed()
	// If the missile isn't moving, kick it off
	if(speed == 0)
		speed = 0.005

	// the missile accelerates whenever it's going in a straight line
	if(old_heading[1] == heading[1] && old_heading[2] == heading[2])
		speed += thrust

	P.set_velocity(normalized_heading[1] * speed, normalized_heading[2] * speed)
	fuel--
	return 1

/obj/item/missile_equipment/thruster/should_enter(var/obj/effect/overmap/O)
	if(O == target)
		return TRUE
	return FALSE

/obj/item/missile_equipment/thruster/proc/is_target_valid(var/obj/effect/overmap/O)
	return ((O.sector_flags & OVERMAP_SECTOR_IN_SPACE) && !(O.sector_flags & OVERMAP_SECTOR_UNTARGETABLE) && LAZYLEN(O.map_z))

/obj/item/missile_equipment/thruster/attackby(var/obj/item/I, var/mob/user)
	if(isMultitool(I))
		var/list/obj/effect/overmap/possible_targets = list()

		var/turf/turf_location = get_turf(src)
		var/obj/effect/overmap/ship/ship = waypoint_sector(turf_location)
		if(!ship || !istype(ship))
			return

		var/obj/machinery/shipsensors/sensors = null
		for(var/obj/machinery/shipsensors/S in SSmachines.machinery)
			if(ship.check_ownership(S) && S.powered() && S.health && S.in_vacuum())
				sensors = S
				break
		if(!sensors)
			to_chat(user, SPAN_NOTICE("The targeting computer display indicates that there is no valid sensor array to utilize for target seeking."))
			return

		for(var/turf/T in trange(sensors.range, get_turf(ship)))
			for(var/obj/effect/overmap/O in T)
				if(is_target_valid(O))
					possible_targets[O] = "[O.name] ([O.x]-[O.y])"

		if(!LAZYLEN(possible_targets))
			to_chat(user, SPAN_NOTICE("The targeting computer display indicates that there are no valid targets."))
			return

		var/obj/effect/overmap/tgt = input("Select a target") as null|obj in possible_targets
		if(!tgt)
			return

		target = tgt
		to_chat(user, SPAN_NOTICE("Target successfully set to [target]."))
		return

	..()

// Anti-missile missile booster with more fuel and more thrust per unit of fuel
// Intended for use with the anti-missile equipment
/obj/item/missile_equipment/thruster/hunter
	name = "HUNTER warp booster"
	desc = "An advanced booster specifically designed to plot courses towards and catch up to rapidly moving objects such as other missiles."
	icon_state = "seeker"

	fuel = 40
	thrust = 0.01

/obj/item/missile_equipment/thruster/hunter/is_target_valid(var/obj/effect/overmap/O)
	return istype(O, /obj/effect/overmap/projectile)

// Takes in coordinates and flies to said coordinates (although very slowly, so the range isn't great)
/obj/item/missile_equipment/thruster/point
	name = "pointman missile booster"
	desc = "A missile booster designed to travel to and rest at a given point. Steers away from structures."
	icon_state = "dumbfire"

	thrust = 0.0005

/obj/item/missile_equipment/thruster/point/attackby(var/obj/item/I, var/mob/user)
	if(isMultitool(I))
		var/target_x = input(user, "Enter target X coordinate", "Input coordinates") as null|num
		var/target_y = input(user, "Enter target Y coordinate", "Input coordinates") as null|num
		if(!target_x || !target_y || target_x <= 0 || target_x >= GLOB.using_map.overmap_size || target_y <= 0 || target_y >= GLOB.using_map.overmap_size)
			to_chat(user, SPAN_NOTICE("The targeting computer display lets you know that's an invalid target."))
			return

		var/turf/tgt = locate(target_x, target_y, GLOB.using_map.overmap_z)
		if(!tgt)
			to_chat(user, SPAN_NOTICE("The targeting computer display indicates that the target wasn't valid."))
			return

		target = tgt
		to_chat(user, SPAN_NOTICE("Target successfully set to [target]."))
		return

	..()

/obj/item/missile_equipment/thruster/planet
	name = "planetary missile booster"
	desc = "The standard fare missile booster, but with planetary flight capabilities."
	icon_state = "planet"

	var/turf/planetary_target

/obj/item/missile_equipment/thruster/planet/is_target_valid(var/obj/effect/overmap/O)
	return istype(O, /obj/effect/overmap/sector/exoplanet)

// Immediately move the missile to the target on arrival
/obj/item/missile_equipment/thruster/planet/on_enter_level(var/z_level)
	if(z_level == planetary_target.z)
		// Effectively apply a small random offset from the target
		var/turf/impact_turf = planetary_target
		for(var/turf/T in shuffle(trange(3, planetary_target)))
			if(!T.contains_dense_objects())
				impact_turf = T
				break

		in_missile.forceMove(impact_turf)
		in_missile.detonate(impact_turf)

	return null

/obj/item/missile_equipment/thruster/planet/attackby(var/obj/item/I, var/mob/user)
	..()

	// If we set a target, follow up with setting a specific x/y target on the planet
	if(target && isMultitool(I))
		var/target_x = input(user, "Enter planetary target X coordinate", "Input coordinates") as null|num
		var/target_y = input(user, "Enter planetary target Y coordinate", "Input coordinates") as null|num
		if(!target_x || !target_y || target_x <= 0 || target_x >= world.maxx || target_y <= 0 || target_y >= world.maxx)
			to_chat(user, SPAN_NOTICE("The targeting computer display indicates that the target wasn't valid."))
			return

		var/obj/effect/overmap/sector/exoplanet/planet = target
		var/turf/tgt = locate(target_x, target_y, planet.map_z[planet.map_z.len])
		if(!tgt || tgt.contains_dense_objects())
			to_chat(user, SPAN_NOTICE("The targeting computer display indicates that the target wasn't valid."))
			return

		planetary_target = tgt
		to_chat(user, SPAN_NOTICE("Planetary target successfully set to [target_x]-[target_y]."))
		return