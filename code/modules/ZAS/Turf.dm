/turf/simulated/var/zone/zone
/turf/simulated/var/open_directions

/turf/var/needs_air_update = 0
/turf/var/datum/gas_mixture/air

/turf/simulated/proc/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	if(graphic_add && graphic_add.len)
		vis_contents += graphic_add
	if(graphic_remove && graphic_remove.len)
		vis_contents -= graphic_remove

/turf/proc/update_air_properties()
	var/block = c_airblock(src)
	if(block & AIR_BLOCKED)
		//dbg(blocked)
		return 1

	#ifdef MULTIZAS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/unsim = get_step(src, d)

		if(!unsim)
			continue

		block = unsim.c_airblock(src)

		if(block & AIR_BLOCKED)
			//unsim.dbg(air_blocked, turn(180,d))
			continue

		var/r_block = c_airblock(unsim)

		if(r_block & AIR_BLOCKED)
			continue

		if(istype(unsim, /turf/simulated))

			var/turf/simulated/sim = unsim
			if(TURF_HAS_VALID_ZONE(sim))
				SSair.connect(sim, src)

/*
	Simple heuristic for determining if removing the turf from it's zone will not partition the zone (A very bad thing).
	Instead of analyzing the entire zone, we only check the nearest 3x3 turfs surrounding the src turf.
	This implementation may produce false negatives but it (hopefully) will not produce any false postiives.
*/

/turf/simulated/proc/can_safely_remove_from_zone()
	if(!zone) return 1

	var/check_dirs = get_zone_neighbours(src)
	var/unconnected_dirs = check_dirs

	#ifdef MULTIZAS
	var/to_check = GLOB.cornerdirsz
	#else
	var/to_check = GLOB.cornerdirs
	#endif

	for(var/dir in to_check)

		//for each pair of "adjacent" cardinals (e.g. NORTH and WEST, but not NORTH and SOUTH)
		if((dir & check_dirs) == dir)
			//check that they are connected by the corner turf
			var/connected_dirs = get_zone_neighbours(get_step(src, dir))
			if(connected_dirs && (dir & GLOB.reverse_dir[connected_dirs]) == dir)
				unconnected_dirs &= ~dir //they are, so unflag the cardinals in question

	//it is safe to remove src from the zone if all cardinals are connected by corner turfs
	return !unconnected_dirs

//helper for can_safely_remove_from_zone()
/turf/simulated/proc/get_zone_neighbours(turf/simulated/T)
	. = 0
	if(istype(T) && T.zone)
		#ifdef MULTIZAS
		var/to_check = GLOB.cardinalz
		#else
		var/to_check = GLOB.cardinal
		#endif
		for(var/dir in to_check)
			var/turf/simulated/other = get_step(T, dir)
			if(istype(other) && other.zone == T.zone && !(other.c_airblock(T) & AIR_BLOCKED) && get_dist(src, other) <= 1)
				. |= dir

/turf/simulated/update_air_properties()

	if(zone && zone.invalid) //this turf's zone is in the process of being rebuilt
		c_copy_air() //not very efficient :(
		zone = null //Easier than iterating through the list at the zone.

	var/s_block = c_airblock(src)
	if(s_block & AIR_BLOCKED)
		#ifdef ZASDBG
		if(verbose) log_debug("Self-blocked.")
		//dbg(blocked)
		#endif
		if(zone)
			var/zone/z = zone

			if(can_safely_remove_from_zone()) //Helps normal airlocks avoid rebuilding zones all the time
				c_copy_air() //we aren't rebuilding, but hold onto the old air so it can be readded
				z.remove(src)
			else
				z.rebuild()

		return 1

	var/previously_open = open_directions
	open_directions = 0

	var/list/postponed
	#ifdef MULTIZAS
	for(var/d = 1, d < 64, d *= 2)
	#else
	for(var/d = 1, d < 16, d *= 2)
	#endif

		var/turf/unsim = get_step(src, d)

		if(!unsim) //edge of map
			continue

		var/block = unsim.c_airblock(src)
		if(block & AIR_BLOCKED)

			#ifdef ZASDBG
			if(verbose) log_debug("[d] is blocked.")
			//unsim.dbg(air_blocked, turn(180,d))
			#endif

			continue

		var/r_block = c_airblock(unsim)
		if(r_block & AIR_BLOCKED)

			#ifdef ZASDBG
			if(verbose) log_debug("[d] is blocked.")
			//dbg(air_blocked, d)
			#endif

			//Check that our zone hasn't been cut off recently.
			//This happens when windows move or are constructed. We need to rebuild.
			if((previously_open & d) && istype(unsim, /turf/simulated))
				var/turf/simulated/sim = unsim
				if(zone && sim.zone == zone)
					zone.rebuild()
					return

			continue

		open_directions |= d

		if(istype(unsim, /turf/simulated))

			var/turf/simulated/sim = unsim
			sim.open_directions |= GLOB.reverse_dir[d]

			if(TURF_HAS_VALID_ZONE(sim))

				//Might have assigned a zone, since this happens for each direction.
				if(!zone)

					//We do not merge if
					//    they are blocking us and we are not blocking them, or if
					//    we are blocking them and not blocking ourselves - this prevents tiny zones from forming on doorways.
					if(((block & ZONE_BLOCKED) && !(r_block & ZONE_BLOCKED)) || ((r_block & ZONE_BLOCKED) && !(s_block & ZONE_BLOCKED)))
						#ifdef ZASDBG
						if(verbose) log_debug("[d] is zone blocked.")

						//dbg(zone_blocked, d)
						#endif

						//Postpone this tile rather than exit, since a connection can still be made.
						if(!postponed) postponed = list()
						postponed.Add(sim)

					else

						sim.zone.add(src)

						#ifdef ZASDBG
						dbg(assigned)
						if(verbose) log_debug("Added to [zone]")
						#endif

				else if(sim.zone != zone)

					#ifdef ZASDBG
					if(verbose) log_debug("Connecting to [sim.zone]")
					#endif

					SSair.connect(src, sim)


			#ifdef ZASDBG
				else if(verbose) log_debug("[d] has same zone.")

			else if(verbose) log_debug("[d] has invalid zone.")
			#endif

		else

			//Postponing connections to tiles until a zone is assured.
			if(!postponed) postponed = list()
			postponed.Add(unsim)

	if(!TURF_HAS_VALID_ZONE(src)) //Still no zone, make a new one.
		var/zone/newzone = new/zone()
		newzone.add(src)

	#ifdef ZASDBG
		dbg(created)

	ASSERT(zone)
	#endif

	//At this point, a zone should have happened. If it hasn't, don't add more checks, fix the bug.

	for(var/turf/T in postponed)
		SSair.connect(src, T)

/turf/proc/post_update_air_properties()
	if(connections) connections.update_all()

/turf/assume_air(datum/gas_mixture/giver) //use this for machines to adjust air
	return 0

/turf/proc/assume_gas(gasid, moles, temp = 0)
	return 0

/turf/return_air()
	//Create gas mixture to hold data for passing
	var/datum/gas_mixture/GM = new

	if(initial_gas)
		GM.gas = initial_gas.Copy()
	GM.temperature = temperature
	GM.update_values()

	return GM

/turf/remove_air(amount as num)
	var/datum/gas_mixture/GM = return_air()
	return GM.remove(amount)

/turf/simulated/assume_air(datum/gas_mixture/giver)
	var/datum/gas_mixture/my_air = return_air()
	my_air.merge(giver)

/turf/simulated/assume_gas(gasid, moles, temp = null)
	var/datum/gas_mixture/my_air = return_air()

	if(isnull(temp))
		my_air.adjust_gas(gasid, moles)
	else
		my_air.adjust_gas_temp(gasid, moles, temp)

	return 1

/turf/simulated/return_air()
	if(zone)
		if(!zone.invalid)
			SSair.mark_zone_update(zone)
			return zone.air
		else
			if(!air)
				make_air()
			c_copy_air()
			return air
	else
		if(!air)
			make_air()
		return air

/turf/proc/make_air()
	air = new/datum/gas_mixture
	air.temperature = temperature
	if(initial_gas)
		air.gas = initial_gas.Copy()
	air.update_values()

/turf/simulated/proc/c_copy_air()
	if(!air) air = new/datum/gas_mixture
	air.copy_from(zone.air)
	air.group_multiplier = 1

//For meltables

/obj/proc/can_melt(temp)
	return FALSE

/obj/structure/can_melt(temp)
	if (material && temp > material.melting_point)
		return TRUE
	return FALSE

/obj/structure/girder/can_melt(temp)
	if (!material)// they usually don't have those
		material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	. = ..()

/obj/structure/grille/can_melt(temp)
	if (!material)
		material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	. = ..()

/obj/machinery/portable_atmospherics/canister/can_melt(temp)
	if(temp > temperature_resistance)
		return TRUE
	return FALSE

/obj/machinery/door/firedoor/can_melt(temp)
	var/material/default_material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	if (temp > (default_material.melting_point + 400))
		return TRUE
	return FALSE

//HEAT DAMAGE PROCS*********************************************************************************************************************************************************

/atom/proc/heat_damage(temp)
	return

//TURFS
/turf/simulated/floor/heat_damage(temp)
	var/material/default_material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	if (temp > default_material.melting_point)
		fire_act(null, temp, null)

/turf/simulated/wall/heat_damage(temp)
	burn(temp)
	if (temp > material.melting_point)
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		take_damage(log(RAND_F(0.9, 1.1) * (temp - material.melting_point)))

//STRUCTURES
/obj/structure/heat_damage(temp)//we don't need to check for materials, can_melt should be called first, it should handle it
	if (temp > (material.melting_point))
		take_damage(log(RAND_F(0.9, 1.1) * (temp - material.melting_point)))

/obj/structure/window/heat_damage(temp)
	for(var/obj/machinery/door/protector in loc.contents)
		if (istype(protector, /obj/machinery/door/blast) || istype(protector, /obj/machinery/door/firedoor))
			if (protector.density == 1)//YOU SAVED ME! OH, MY HERO!
				return
	var/melting_point = material.melting_point
	if (reinf_material)
		melting_point += 0.25*reinf_material.melting_point
	if (temp > melting_point)
		playsound(loc, 'sound/effects/Glasshit.ogg', 50, 1)
		take_damage(log(RAND_F(0.9, 1.1) * (temp - material.melting_point)))

//MACHINERY
/obj/machinery/portable_atmospherics/canister/heat_damage(temp)
	if(temp > temperature_resistance)
		health -= 5
		healthcheck()

/obj/machinery/door/firedoor/heat_damage(temp)
	var/material/default_material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	if (temp > (default_material.melting_point) + 400)
		take_damage(log(RAND_F(0.9, 1.1) * (temp - default_material.melting_point)))

/obj/machinery/door/firedoor/take_damage(damage)
	health -= damage
	if (health <= 0)
		stat |= BROKEN
		deconstruct()

//HEAT DAMAGE PROCS NO MORE*********************************************************************************************************************************************************

/turf/simulated
	var/list/meltable_turfs = list()
	var/list/meltable_nonturfs = list()

//called by the zone every time the air contents change AND the temperature is higher than usual, we check for turfs here and determine if we need to start processing
/turf/simulated/proc/check_meltables(stop)
	meltable_turfs.Cut()
	if (stop)
		meltable_nonturfs.Cut()
		STOP_PROCESSING(SSturf, src)
		return

	var/material/default_material = SSmaterials.get_material_by_name(MATERIAL_STEEL)
	if (zone.air.temperature > default_material.melting_point && !is_plating())
		meltable_turfs |= src
	var/turf/cardinal = CardinalTurfs(FALSE)
	for(var/turf/simulated/meltable_turf in cardinal)
		if (istype(meltable_turf, /turf/simulated/wall))
			meltable_turfs |= meltable_turf

	if (!is_processing)//if we're processing, we're doing this anyway
		check_meltable_nonturfs()
	if (!is_processing && (meltable_turfs.len != 0 || meltable_nonturfs.len != 0))
		START_PROCESSING(SSturf, src)

/turf/simulated/proc/check_meltable_nonturfs()
	var/datum/gas_mixture/air_contents = return_air()
	meltable_nonturfs.Cut()
	for(var/obj/meltable in contents)
		if (meltable.can_melt(air_contents.temperature))
			meltable_nonturfs |= meltable

	var/turf/cardinal = CardinalTurfs(FALSE)
	for(var/turf/T in cardinal)

		for(var/obj/structure/window/meltable in T.contents)
			meltable_nonturfs |= meltable
		for(var/obj/machinery/door/firedoor/meltable in T.contents)
			if (meltable.can_melt(air_contents.temperature) && meltable.density)
				meltable_nonturfs |= meltable

/turf/simulated/Process()
	if (!zone)// something went... uh... wrong
		meltable_turfs.Cut()
		meltable_nonturfs.Cut()
		STOP_PROCESSING(SSturf, src)
		return

	var/datum/gas_mixture/air_contents = return_air()

	check_meltable_nonturfs()//we need to keep track of nonturfs in case they moved, the zone isn't going to call check_meltables for them since they don't change anything

	if (meltable_turfs.len == 0 && meltable_nonturfs.len == 0)
		STOP_PROCESSING(SSturf, src)
		return

	for(var/turf/meltable in meltable_turfs)
		meltable.heat_damage(air_contents.temperature)

	for(var/obj/meltable in meltable_nonturfs)
		meltable.heat_damage(air_contents.temperature)
