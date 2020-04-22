/turf/simulated/var/zone/zone
// invariant: open_directions_(air|zone) & ~cell_consistent_directions == 0
// -> all non-consistent directions are considered closed

/turf/var/open_directions_air
/turf/var/open_directions_zone
/turf/var/cell_consistent_directions
/turf/var/self_air_blocked

/turf/simulated/var/zone_consistent_open

/turf/var/needs_air_update = 0
/turf/var/datum/gas_mixture/air

/turf/proc/update_open_directions(dobg = 0)
	// by ANDing with cell_consistent_directions, we set all non-consistent directions to 0 / BLOCKED
	open_directions_air &= cell_consistent_directions
	open_directions_zone &= cell_consistent_directions

	var/c_airblock
	ATMOS_CANPASS_TURF(c_airblock, src, src)

	// self-air-blocked means "this cell can't hold air". inform the neighbours.
	if(c_airblock & AIR_BLOCKED)
		for(var/d = 1, d <= DOWN, d *= 2)
			var/turf/nbr = GET_ZSTEP(src, d)
			if(nbr)
				var/rev_d = GLOB.reverse_dir[d]
				nbr.open_directions_air &= ~rev_d
				nbr.open_directions_zone &= ~rev_d
				nbr.cell_consistent_directions |= rev_d

		open_directions_air = 0
		open_directions_zone = 0
		cell_consistent_directions = NORTH|SOUTH|EAST|WEST|UP|DOWN
		self_air_blocked = 1

		return
	
	self_air_blocked = 0

	for(var/d = 1, d <= DOWN, d *= 2)
		// neighbouring tile has already done the work, skip.
		if(cell_consistent_directions & d)
			continue

		var/turf/nbr = GET_ZSTEP(src, d)

		// at edge of map, skip.
		if(!nbr)
			continue

		var/rev_d = GLOB.reverse_dir[d]
		ATMOS_CANPASS_TURF(c_airblock, src, nbr)
		if(c_airblock != BLOCKED)
			ATMOS_CANPASS_TURF(., nbr, src)
			c_airblock |= .

		if(!(c_airblock & AIR_BLOCKED))
			open_directions_air |= d
			nbr.open_directions_air |= rev_d

		if(!(c_airblock & ZONE_BLOCKED))
			open_directions_zone |= d
			nbr.open_directions_zone |= rev_d

		nbr.cell_consistent_directions |= rev_d
	
	cell_consistent_directions = NORTH|SOUTH|EAST|WEST|UP|DOWN

	return null


/turf/simulated/proc/update_graphic(list/graphic_add = null, list/graphic_remove = null)
	if(graphic_add && graphic_add.len)
		vis_contents += graphic_add
	if(graphic_remove && graphic_remove.len)
		vis_contents -= graphic_remove

/turf/proc/update_air_properties()
	if(self_air_blocked)
		return 1

	for(var/d = 1, d < 64, d *= 2)
		if(!(open_directions_air & d))
			continue

		var/turf/unsim = GET_ZSTEP(src, d)

		if(!unsim)
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

	for(var/dir in GLOB.cornerdirsz)

		//for each pair of "adjacent" cardinals (e.g. NORTH and WEST, but not NORTH and SOUTH)
		if((dir & check_dirs) == dir)
			//check that they are connected by the corner turf
			var/connected_dirs = get_zone_neighbours(get_zstep(src, dir))
			if(connected_dirs && (dir & GLOB.reverse_dir[connected_dirs]) == dir)
				unconnected_dirs &= ~dir //they are, so unflag the cardinals in question

	//it is safe to remove src from the zone if all cardinals are connected by corner turfs
	return !unconnected_dirs

//helper for can_safely_remove_from_zone()
/turf/simulated/proc/get_zone_neighbours(turf/simulated/T)
	. = 0
	if(istype(T) && T.zone)
		var/to_check = GLOB.cardinalz
		for(var/dir in to_check)
			var/turf/simulated/other = GET_ZSTEP(T, dir)
			if(istype(other) && other.zone == T.zone && !(other.c_airblock(T) & AIR_BLOCKED) && get_dist(src, other) <= 1)
				. |= dir

/turf/simulated/update_air_properties()
	if(cell_consistent_directions != NORTH|SOUTH|EAST|WEST|UP|DOWN)
		update_open_directions()

	if(zone && zone.invalid) //this turf's zone is in the process of being rebuilt
		c_copy_air() //not very efficient :(
		zone = null //Easier than iterating through the list at the zone.

	if(self_air_blocked)
		#ifdef ZASDBG
		if(GLOB.zas_debug_verbose) log_debug("Self-blocked.")
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

	var/previously_open = zone_consistent_open
	zone_consistent_open = 0

	var/list/postponed
	for(var/d = 1, d < 64, d *= 2)
		var/turf/unsim = GET_ZSTEP(src, d)

		if(!unsim) //edge of map
			#ifdef ZASDBG
			if(GLOB.zas_debug_verbose) log_debug("[d] is null.")
			#endif
			continue

		if(!(open_directions_air & d))
			#ifdef ZASDBG
			if(GLOB.zas_debug_verbose) log_debug("[d] is blocked.")
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

		zone_consistent_open |= d

		if(istype(unsim, /turf/simulated))

			var/turf/simulated/sim = unsim

			if(TURF_HAS_VALID_ZONE(sim))

				//Might have assigned a zone, since this happens for each direction.
				if(!TURF_HAS_VALID_ZONE(src))

					//We do not merge if
					//    they are blocking us and we are not blocking them, or if
					//    we are blocking them and not blocking ourselves - this prevents tiny zones from forming on doorways.
					//if(((block & ZONE_BLOCKED) && !(r_block & ZONE_BLOCKED)) || ((r_block & ZONE_BLOCKED) && !(s_block & ZONE_BLOCKED)))
					if(!(open_directions_zone & d))
						#ifdef ZASDBG
						if(GLOB.zas_debug_verbose) log_debug("[d] is zone blocked.")

						//dbg(zone_blocked, d)
						#endif

						//Postpone this tile rather than exit, since a connection can still be made.
						LAZYADD(postponed, sim)

					else

						sim.zone.add(src)

						#ifdef ZASDBG
						dbg(assigned)
						if(GLOB.zas_debug_verbose) log_debug("Added to [zone]")
						#endif

				else if(sim.zone != zone)

					#ifdef ZASDBG
					if(GLOB.zas_debug_verbose) log_debug("Connecting to [sim.zone]")
					#endif

					SSair.connect(src, sim)


			#ifdef ZASDBG
				else if(GLOB.zas_debug_verbose) log_debug("[d] has same zone.")

			else if(GLOB.zas_debug_verbose) log_debug("[d] has invalid zone.")
			#endif

		else

			//Postponing connections to tiles until a zone is assured.
			if(!postponed) postponed = list()
			postponed.Add(unsim)
			LAZYADD(postponed, unsim)

	if(!TURF_HAS_VALID_ZONE(src)) //Still no zone, make a new one.
		var/zone/newzone = new/zone()
		newzone.add(src)

	#ifdef ZASDBG
		dbg(created)

	ASSERT(zone)
	ASSERT(zone_consistent_open == open_directions_air)
	if(GLOB.zas_debug_verbose) log_debug("[length(postponed)] postponed cells.")
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
			zone = null
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
