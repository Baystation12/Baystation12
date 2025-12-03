// Very oversimplified engine/booster. It takes a target and instantly adjusts the speed of the projectile to move towards it
/obj/item/missile_equipment/thruster
	name = "missile booster"
	desc = "A simple but powerful and modular booster that can be fitted in most missiles. This one comes with an embedded targeting computer."
	icon_state = "target"
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 3)
	matter = list(MATERIAL_ALUMINIUM = 4000, MATERIAL_PHORON = 3000)
	cooldown = 5
	slot = MISSILE_PART_THRUSTER
	var/atom/target
	var/fuel_consumption = 0.3
	var/overmap_speed = 1 / (10 SECONDS)
	var/target_range = 50

/obj/item/missile_equipment/thruster/preset/Initialize()
	. = ..()
	new /obj/item/tank/hydrogen(src)

/obj/item/missile_equipment/thruster/examine(mob/user)
	. = ..()
	var/obj/item/tank/fuel_tank = locate() in src
	if (fuel_tank)
		to_chat(user, "It has \a [fuel_tank] installed.")
	else
		to_chat(user, SPAN_WARNING("It is missing a fuel tank."))

/obj/item/missile_equipment/thruster/get_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_MULTITOOL] = "<p>Sets target. Some types set a target automatically.</p>"
	.[CODEX_INTERACTION_HAND] = "<p>Removes attached fuel tank.</p>"
	.[CODEX_INTERACTION_CLICKDRAG] = "<p>Removes attached fuel tank.</p>"
	.["Fuel Tank"] = "<p>Adds fuel tank to the thruster. Can only have one tank.</p>"

/obj/item/missile_equipment/thruster/do_overmap_work(obj/overmap/projectile/projectile)
	if (!..() || isnull(target))
		return FALSE

	if (!try_consume_fuel())
		return FALSE

	projectile.adjust_speed(-projectile.speed[1], -projectile.speed[2])

	if (projectile.loc == get_turf(target))
		return TRUE

	var/target_dir = get_dir(projectile, target)

	var/dir_x = SIGN((target_dir & EAST) * 1 + (target_dir & WEST) * -1)
	var/dir_y = SIGN((target_dir & NORTH) * 1 + (target_dir & SOUTH) * -1)
	if (dir_x == dir_y && dir_x == 0)
		return

	projectile.dir = target_dir
	projectile.adjust_speed(dir_x * overmap_speed, dir_y * overmap_speed)
	return TRUE

/obj/item/missile_equipment/thruster/proc/try_consume_fuel()
	if (!fuel_consumption)
		return TRUE
	var/obj/item/tank/fuel_tank = locate() in src
	if (!fuel_tank)
		return FALSE
	var/total_flammable_gas_moles = fuel_tank.air_contents.get_by_flag(XGM_GAS_FUEL)
	if (total_flammable_gas_moles < fuel_consumption) //not enough fuel
		return FALSE
	fuel_tank.remove_air_by_flag(XGM_GAS_FUEL, fuel_consumption)
	return TRUE

/obj/item/missile_equipment/thruster/should_enter(obj/overmap/overmap_site)
	if (overmap_site == target)
		return TRUE
	return FALSE

/obj/item/missile_equipment/thruster/proc/is_target_valid(obj/overmap/visitable/overmap_site)
	return (istype(overmap_site) && (overmap_site.sector_flags & OVERMAP_SECTOR_IN_SPACE) && !(overmap_site.sector_flags & OVERMAP_SECTOR_UNTARGETABLE) && LAZYLEN(overmap_site.map_z) && !(z in overmap_site.map_z))

/obj/item/missile_equipment/thruster/proc/remove_tank(mob/user as mob)
	if (length(contents) > 0)
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.put_in_hands(contents[1])
		return TRUE
	return FALSE

/obj/item/missile_equipment/thruster/attack_hand(mob/user as mob)
	if (user.get_inactive_hand() == src && remove_tank(user))
		return TRUE
	. = ..()

/obj/item/missile_equipment/thruster/MouseDrop(atom/over_atom, atom/source_loc, atom/over_loc, source_control, over_control, list/mouse_params)
	if (usr == over_atom)
		remove_tank(usr)
		return

/obj/item/missile_equipment/thruster/attack_robot(mob/user)
	if (Adjacent(user))
		remove_tank(user)

/obj/item/missile_equipment/thruster/use_tool(obj/item/tool, mob/user)
	if (istype(tool, /obj/item/tank))
		var/obj/item/tank/tank = locate() in src
		if (tank)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [tank] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		playsound(src, 'sound/items/Deconstruct.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] inserts \a [tool] in \the [src]."),
			SPAN_NOTICE("You insert \the [tool] in \the [src].")
		)
		return TRUE
	return ..()

/obj/item/missile_equipment/thruster/can_configure()
	return TRUE

/obj/item/missile_equipment/thruster/configure(mob/user)
	var/list/obj/overmap/possible_targets = list()

	var/turf/turf_location = get_turf(src)
	var/obj/overmap/visitable/ship/ship = waypoint_sector(turf_location)
	if (!ship || !istype(ship))
		return TRUE

	var/obj/machinery/shipsensors/sensors = null
	for (var/obj/machinery/shipsensors/found_sensors in SSmachines.machinery)
		if (ship.check_ownership(found_sensors) && found_sensors.powered())
			sensors = found_sensors
			break
	if (!sensors)
		to_chat(user, SPAN_NOTICE("The targeting computer display indicates that there is no valid sensor array to utilize for target seeking."))
		return TRUE

	for (var/turf/T in trange(sensors.range, get_turf(ship)))
		for (var/obj/overmap/O in T)
			if (is_target_valid(O))
				possible_targets["[O.name] ([O.x]-[O.y])"] = O

	if (!LAZYLEN(possible_targets))
		to_chat(user, SPAN_NOTICE("The targeting computer display indicates that there are no valid targets."))
		return TRUE

	var/selected_target = input("Select a target") as null|obj in possible_targets
	if (!selected_target)
		return TRUE

	var/obj/overmap/target_actual = possible_targets[selected_target]
	if (!target_actual)
		to_chat(user, SPAN_NOTICE("Target lost."))
		return TRUE
	target = target_actual
	to_chat(user, SPAN_NOTICE("Target successfully set to [target]."))
	return TRUE

/obj/item/missile_equipment/thruster/on_enter_level(z_level)
	var/turf/target_turf = pick_turf_in_range(get_turf(loc), target_range, list(
		GLOBAL_PROC_REF(is_not_space_turf),
		GLOBAL_PROC_REF(is_not_open_space)
	))
	if (target_turf && istype(target_turf))
		return list(target_turf.x, target_turf.y)
	return null

/obj/item/missile_equipment/payload/explosive/on_trigger(atom/triggerer)
	// detonate the fuel tank
	var/obj/item/tank/fuel_tank = locate() in src
	if (fuel_tank)
		var/turf/simulated/T = get_turf(loc)
		if (!T)
			return ..()
		var/strength = ((fuel_tank.air_contents.return_pressure() - TANK_FRAGMENT_PRESSURE)/TANK_FRAGMENT_SCALE)
		var/mult = ((fuel_tank.air_contents.volume/140)**(1/2)) * (fuel_tank.air_contents.total_moles**2/3)/((29*0.64) **2/3)
		var/range = mult * strength
		T.assume_air(fuel_tank.air_contents)
		explosion(T, round(min(BOMBCAP_RADIUS, range)), EX_ACT_LIGHT)
	..()
