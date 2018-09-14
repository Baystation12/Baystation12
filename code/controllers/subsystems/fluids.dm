var/datum/controller/subsystem/fluids/SSfluids

/datum/controller/subsystem/fluids
	name = "Fluids"
	wait = 10
	flags = SS_NO_INIT

	var/next_water_act = 0
	var/water_act_delay = 15 // A bit longer than machines.

	var/list/active_fluids = list()
	var/list/water_sources = list()
	var/list/pushing_atoms = list()
	var/list/hygiene_props = list()

	var/tmp/list/processing_sources
	var/tmp/list/processing_fluids

	var/tmp/active_fluids_copied_yet = FALSE
	var/af_index = 1
	var/downward_fluid_overlay_position = 1 // Bit of an odd hack, set in fluid spread code to determine which overlay
	                                        // in the list is 'down'. More maintainer-friendly than hardcoding it.
	var/list/fluid_images = list()

	var/list/gurgles = list(
		'sound/effects/gurgle1.ogg',
		'sound/effects/gurgle2.ogg',
		'sound/effects/gurgle3.ogg',
		'sound/effects/gurgle4.ogg'
		)

/datum/controller/subsystem/fluids/New()
	NEW_SS_GLOBAL(SSfluids)

/datum/controller/subsystem/fluids/stat_entry()
	..("A:[active_fluids.len] S:[water_sources.len]")

/datum/controller/subsystem/fluids/fire(resumed = 0)
	if (!resumed)
		processing_sources = water_sources.Copy()
		active_fluids_copied_yet = FALSE
		af_index = 1

	var/flooded_a_neighbor // Not used, required by FLOOD_TURF_NEIGHBORS.
	var/list/curr_sources = processing_sources
	while (curr_sources.len)
		var/turf/T = curr_sources[curr_sources.len]
		curr_sources.len--

		FLOOD_TURF_NEIGHBORS(T, FALSE)

		if (MC_TICK_CHECK)
			return

	if (!active_fluids_copied_yet)
		active_fluids_copied_yet = TRUE
		processing_fluids = active_fluids.Copy()

	// We need to iterate through this list a few times, so we're using indexes instead of a while-truncate loop.
	while (af_index <= processing_fluids.len)
		var/obj/effect/fluid/F = processing_fluids[af_index++]
		if (QDELETED(F))
			processing_fluids -= F
		else
			// Spread out and collect neighbors for equalizing later. Hardcoded here for performance reasons.
			if(!F.loc || F.loc != F.start_loc || !F.loc.CanFluidPass())
				qdel(F)
				continue

			if(F.fluid_amount <= FLUID_EVAPORATION_POINT)
				continue

			F.equalizing_fluids = list(F)

			// Flood downwards if there's open space below us.
			if(HasBelow(F.z))
				var/turf/current = get_turf(F)
				if(istype(current, /turf/simulated/open))
					var/turf/T = GetBelow(F)
					var/obj/effect/fluid/other = locate() in T
					if(!istype(other) || other.fluid_amount < FLUID_MAX_DEPTH)
						if(!other)
							other = new /obj/effect/fluid(T)
						F.equalizing_fluids += other
						downward_fluid_overlay_position = F.equalizing_fluids.len
			UPDATE_FLUID_BLOCKED_DIRS(F.start_loc)
			for(var/spread_dir in GLOB.cardinal)
				if(F.start_loc.fluid_blocked_dirs & spread_dir)
					continue
				var/turf/T = get_step(F.start_loc, spread_dir)
				var/coming_from = GLOB.reverse_dir[spread_dir]
				if(!istype(T) || T.flooded)
					continue
				UPDATE_FLUID_BLOCKED_DIRS(T)
				if((T.fluid_blocked_dirs & coming_from) || !T.CanFluidPass(coming_from))
					continue
				var/obj/effect/fluid/other = locate() in T.contents
				if(other && (QDELETED(other) || other.fluid_amount <= FLUID_DELETING))
					continue
				if(!other)
					other = new /obj/effect/fluid(T)
					other.temperature = F.temperature
				F.equalizing_fluids += other

		if (MC_TICK_CHECK)
			return

	af_index = 1

	while (af_index <= processing_fluids.len)
		var/obj/effect/fluid/F = processing_fluids[af_index++]
		if (QDELETED(F))
			processing_fluids -= F
		else
			// Equalize across our neighbors. Hardcoded here for performance reasons.
			if(!F.loc || F.loc != F.start_loc || !F.equalizing_fluids || !F.equalizing_fluids.len || F.fluid_amount <= FLUID_EVAPORATION_POINT)
				continue

			F.equalize_avg_depth = 0
			F.equalize_avg_temp = 0
			F.flow_amount = 0

			// Flow downward first, since gravity. TODO: add check for gravity.
			if(F.equalizing_fluids.len >= downward_fluid_overlay_position)
				var/obj/effect/fluid/downward_fluid = F.equalizing_fluids[downward_fluid_overlay_position]
				if(downward_fluid.z == F.z-1) // It's below us.
					F.equalizing_fluids -= downward_fluid
					var/transfer_amount = min(F.fluid_amount, (FLUID_MAX_DEPTH-downward_fluid.fluid_amount))
					if(transfer_amount > 0)
						SET_FLUID_DEPTH(downward_fluid, downward_fluid.fluid_amount + transfer_amount)
						LOSE_FLUID(F, transfer_amount)
						if(F.fluid_amount <= FLUID_EVAPORATION_POINT)
							continue

			var/setting_dir = 0

			for(var/obj/effect/fluid/other in F.equalizing_fluids)
				if(!istype(other) || QDELETED(other) || other.fluid_amount <= FLUID_DELETING)
					F.equalizing_fluids -= other
					continue
				F.equalize_avg_depth += other.fluid_amount
				F.equalize_avg_temp += other.temperature

				var/flow_amount = F.fluid_amount - other.fluid_amount
				if(F.flow_amount < flow_amount && flow_amount >= FLUID_PUSH_THRESHOLD)
					F.flow_amount = flow_amount
					setting_dir = get_dir(F, other)

			F.set_dir(setting_dir)

			if(islist(F.equalizing_fluids) && F.equalizing_fluids.len > 1)
				F.equalize_avg_depth = Floor(F.equalize_avg_depth/F.equalizing_fluids.len)
				F.equalize_avg_temp = Floor(F.equalize_avg_temp/F.equalizing_fluids.len)
				for(var/thing in F.equalizing_fluids)
					var/obj/effect/fluid/other = thing
					if(!QDELETED(other))
						SET_FLUID_DEPTH(other, F.equalize_avg_depth)
						other.temperature = F.equalize_avg_temp
			F.equalizing_fluids.Cut()
			if(istype(F.loc, /turf/space))
				LOSE_FLUID(F, max((FLUID_EVAPORATION_POINT-1),F.fluid_amount * 0.5))

		if (MC_TICK_CHECK)
			return

	af_index = 1

	while (af_index <= processing_fluids.len)
		var/obj/effect/fluid/F = processing_fluids[af_index++]
		if (QDELETED(F))
			processing_fluids -= F
		else
			if (!F.loc || F.loc != F.start_loc)
				qdel(F)

			if(F.flow_amount >= 10)
				if(prob(1))
					playsound(F.loc, 'sound/effects/slosh.ogg', 25, 1)
				for(var/atom/movable/AM in F.loc.contents)
					if(isnull(pushing_atoms[AM]) && AM.is_fluid_pushable(F.flow_amount))
						pushing_atoms[AM] = TRUE
						step(AM, F.dir)

			if (F.fluid_amount <= FLUID_EVAPORATION_POINT & prob(10))
				LOSE_FLUID(F, rand(1, 3))

			if (F.fluid_amount <= FLUID_DELETING)
				qdel(F)
			else
				F.update_icon()

		if (MC_TICK_CHECK)
			return

	pushing_atoms.Cut()

	// Sometimes, call water_act().
	if(world.time >= next_water_act)
		next_water_act = world.time + water_act_delay
		af_index = 1
		while (af_index <= processing_fluids.len)
			var/obj/effect/fluid/F = processing_fluids[af_index++]
			var/turf/T = get_turf(F)
			if(istype(T) && !QDELETED(F))
				for(var/atom/movable/A in T.contents)
					if(A.simulated && !A.waterproof)
						A.water_act(F.fluid_amount)
			if (MC_TICK_CHECK)
				return
