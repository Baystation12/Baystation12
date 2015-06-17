/obj/effect/fluid/proc/can_spread_into(var/turf/simulated/target)
	// Basic checks.
	if (!target || target.density || !Adjacent(target))
		return 0
	var/flowdir = get_dir(src,target)
	for(var/obj/O in target.contents)
		if(!O.can_liquid_pass(flowdir))
			return 0
	return 1

/obj/effect/fluid/proc/set_depth(var/newdepth)
	newdepth = max(0,newdepth)
	if(depth != newdepth)
		depth = newdepth
		schedule_icon_update()
		refresh()

/obj/effect/fluid/proc/lose_fluid(var/amt)
	if(depth == FLUID_DELETING)
		return 0
	set_depth(depth - amt)
	if(depth <= 0)
		//evaporate()
	else
		schedule_icon_update()
	return 1

/obj/effect/fluid/proc/recieve_fluid(var/amt)
	if(depth == FLUID_DELETING)
		return 0
	set_depth(depth + amt)
	schedule_icon_update()
	return 1

/obj/effect/fluid/proc/equalize(var/create_new_fluids)

	// Sanity.
	if(depth == FLUID_DELETING)
		return

	if(!base_turf || loc != base_turf)
		depth = FLUID_DELETING
		qdel(src)
		return

	//debug color = "#66D1FF"

	// Handle spreading.
	if(depth > FLUID_EVAPORATION_POINT)

		// Get a list of windows barring us from spreading from this turf.
		var/list/blocked_dirs = list()
		for(var/obj/structure/window/W in base_turf)
			blocked_dirs |= W.dir
		for(var/obj/machinery/door/window/D in base_turf)
			blocked_dirs |= D.dir

		// Get a list of feasible spread targets.
		var/avg_depth = depth
		var/list/equalize_fluids = list()
		for(var/turf/simulated/T in range(1,src))

			// Do not average with inaccessible turfs.
			if(!can_spread_into(T) || (get_dir(src,T) in blocked_dirs))
				continue

			// Check if there is already fluid here.
			var/obj/effect/fluid/F = locate() in T.contents

			// If not exists, make one and handle it post-equalizing.
			if(!F)
				if(create_new_fluids)
					refresh()
					new_fluids |= PoolOrNew(/obj/effect/fluid, T)
				continue
			// If it's currently handling deleting itself, ignore it for now.
			else if(F.depth == FLUID_DELETING || (F in new_fluids))
				continue

			// Grab the depth of the turf and add it to the tracking list for updating.
			avg_depth += F.depth
			equalize_fluids |= F
		// Apply and update new average depth.
		avg_depth = round(avg_depth/(equalize_fluids.len+1))
		if(equalize_fluids.len > 1)
			for(var/obj/effect/fluid/F in equalize_fluids)
				// Determine rate of flow.
				var/depth_change = avg_depth - F.depth
				if(abs(depth_change) >= FLUID_EVAPORATION_POINT)
					var/dir_key
					if(depth_change > 0)
						dir = get_dir(src,F)
						dir_key = "[dir]"
					else if(depth_change < 0)
						dir = get_dir(F,src)
						depth_change = abs(depth_change)
						dir_key = "[dir]"
					// Keep the largest flow (todo revisit)
					if(dir_key)
						if(!islist(fluid_flows)) fluid_flows = list()
						if(isnull(fluid_flows[dir_key]) || depth_change > fluid_flows[dir_key])
							fluid_flows[dir_key] = depth_change
				// Apply new depth.
				F.set_depth(avg_depth)
		set_depth(avg_depth)
		return

	if(depth != FLUID_DELETING && depth <= FLUID_EVAPORATION_POINT)
		if(prob(50))
			lose_fluid(rand(1,5))
		refresh()
		//debug color = "#FF0000"

/obj/effect/fluid/proc/apply_flow()
	if(!islist(fluid_flows)) fluid_flows = list()
	if(!fluid_flows.len) return
	for(var/flow_dir in fluid_flows)
		if(flow_dir == "0") continue
		for(var/atom/movable/AM in base_turf)
			AM.water_act(fluid_flows[flow_dir],text2num(flow_dir))
	fluid_flows.Cut()

/obj/effect/fluid/proc/evaporate()

	if(depth == FLUID_DELETING)
		return
	depth = FLUID_DELETING
	processing_fluids -= src
	processing_objects -= src
	updating_fluids -= src
	animate(src,time=(FLUID_SCHEDULE_INTERVAL*2),alpha=0) // Fade out.
	sleep(FLUID_SCHEDULE_INTERVAL*2)
	qdel(src)

/obj/effect/fluid/ex_act()
	evaporate()

/obj/effect/fluid/fire_act()
	evaporate()
