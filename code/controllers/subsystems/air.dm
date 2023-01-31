/*

Overview:
	The air controller does everything. There are tons of procs in here.

Class Vars:
	zones - All zones currently holding one or more turfs.
	edges - All processing edges.

	tiles_to_update - Tiles scheduled to update next tick.
	zones_to_update - Zones which have had their air changed and need air archival.
	active_hotspots - All processing fire objects.

	active_zones - The number of zones which were archived last tick. Used in debug verbs.
	next_id - The next UID to be applied to a zone. Mostly useful for debugging purposes as zones do not need UIDs to function.

Class Procs:

	mark_for_update(turf/T)
		Adds the turf to the update list. When updated, update_air_properties() will be called.
		When stuff changes that might affect airflow, call this. It's basically the only thing you need.

	add_zone(zone/Z) and remove_zone(zone/Z)
		Adds zones to the zones list. Does not mark them for update.

	air_blocked(turf/A, turf/B)
		Returns a bitflag consisting of:
		AIR_BLOCKED - The connection between turfs is physically blocked. No air can pass.
		ZONE_BLOCKED - There is a door between the turfs, so zones cannot cross. Air may or may not be permeable.

	has_valid_zone(turf/T)
		Checks the presence and validity of T's zone.
		May be called on unsimulated turfs, returning 0.

	merge(zone/A, zone/B)
		Called when zones have a direct connection and equivalent pressure and temperature.
		Merges the zones to create a single zone.

	connect(turf/simulated/A, turf/B)
		Called by turf/update_air_properties(). The first argument must be simulated.
		Creates a connection between A and B.

	mark_zone_update(zone/Z)
		Adds zone to the update list. Unlike mark_for_update(), this one is called automatically whenever
		air is returned from a simulated turf.

	equivalent_pressure(zone/A, zone/B)
		Currently identical to A.air.compare(B.air). Returns 1 when directly connected zones are ready to be merged.

	get_edge(zone/A, zone/B)
	get_edge(zone/A, turf/B)
		Gets a valid connection_edge between A and B, creating a new one if necessary.

	has_same_air(turf/A, turf/B)
		Used to determine if an unsimulated edge represents a specific turf.
		Simulated edges use connection_edge/contains_zone() for the same purpose.
		Returns 1 if A has identical gases and temperature to B.

	remove_edge(connection_edge/edge)
		Called when an edge is erased. Removes it from processing.

*/

SUBSYSTEM_DEF(air)
	name = "Air"
	priority = SS_PRIORITY_AIR
	init_order = SS_INIT_AIR
	flags = SS_POST_FIRE_TIMING

	//Geometry lists
	var/list/zones = list()
	var/list/edges = list()

	//Geometry updates lists
	var/list/tiles_to_update = list()
	var/list/zones_to_update = list()
	var/list/active_fire_zones = list()
	var/list/active_hotspots = list()
	var/list/active_edges = list()

	var/list/deferred = list()
	var/list/processing_edges
	var/list/processing_fires
	var/list/processing_hotspots
	var/list/processing_zones

	var/active_zones = 0
	var/next_id = 1

/datum/controller/subsystem/air/proc/reboot()
	// Stop processing while we rebuild.
	can_fire = FALSE

	// Make sure we don't rebuild mid-tick.
	if (state != SS_IDLE)
		report_progress("ZAS Rebuild initiated. Waiting for current air tick to complete before continuing.")
		while (state != SS_IDLE)
			stoplag()

	while (length(zones))
		var/zone/zone = zones[length(zones)]
		LIST_DEC(zones)

		zone.c_invalidate()

	edges.Cut()
	tiles_to_update.Cut()
	zones_to_update.Cut()
	active_fire_zones.Cut()
	active_hotspots.Cut()
	active_edges.Cut()

	// Re-run setup without air settling.
	Initialize(Uptime(), FALSE)

	// Update next_fire so the MC doesn't try to make up for missed ticks.
	next_fire = world.time + wait
	can_fire = TRUE


/datum/controller/subsystem/air/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		TtU: [length(tiles_to_update)] \
		ZtU: [length(zones_to_update)] \
		AFZ: [length(active_fire_zones)] \
		AH: [length(active_hotspots)] \
		AE: [length(active_edges)]\
	"})


/datum/controller/subsystem/air/Initialize(start_uptime, simulate = TRUE)
	report_progress("Processing Geometry...")
	var/simulated_turf_count = 0
	for(var/turf/simulated/S)
		simulated_turf_count++
		S.update_air_properties()
		CHECK_TICK
	report_progress({"Total Simulated Turfs: [simulated_turf_count]
Total Zones: [length(zones)]
Total Edges: [length(edges)]
Total Active Edges: [length(active_edges) ? SPAN_DANGER("[length(active_edges)]") : "None"]
Total Unsimulated Turfs: [world.maxx*world.maxy*world.maxz - simulated_turf_count]
Geometry processing completed in [(Uptime() - start_uptime)/10] seconds!
"})
	if (simulate)
		report_progress("Settling air...")
		start_uptime = Uptime()
		fire(FALSE, TRUE)
		report_progress("Air settling completed in [(Uptime() - start_uptime)/10] seconds!")


/datum/controller/subsystem/air/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		processing_edges = active_edges.Copy()
		processing_fires = active_fire_zones.Copy()
		processing_hotspots = active_hotspots.Copy()

	var/list/curr_tiles = tiles_to_update
	var/list/curr_defer = deferred
	var/list/curr_edges = processing_edges
	var/list/curr_fire = processing_fires
	var/list/curr_hotspot = processing_hotspots
	var/list/curr_zones = zones_to_update

	while (length(curr_tiles))
		var/turf/T = curr_tiles[length(curr_tiles)]
		LIST_DEC(curr_tiles)

		if (!T)
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				return

			continue

		//check if the turf is self-zone-blocked
		var/c_airblock
		ATMOS_CANPASS_TURF(c_airblock, T, T)
		if(c_airblock & ZONE_BLOCKED)
			deferred += T
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				return
			continue

		T.update_air_properties()
		T.post_update_air_properties()
		T.needs_air_update = 0
		#ifdef ZASDBG
		T.overlays -= mark
		updated++
		#endif

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	while (length(curr_defer))
		var/turf/T = curr_defer[length(curr_defer)]
		LIST_DEC(curr_defer)

		T.update_air_properties()
		T.post_update_air_properties()
		T.needs_air_update = 0
		#ifdef ZASDBG
		T.overlays -= mark
		updated++
		#endif

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	while (length(curr_edges))
		var/connection_edge/edge = curr_edges[length(curr_edges)]
		LIST_DEC(curr_edges)

		if (!edge)
			if (no_mc_tick)
				CHECK_TICK
			else if (MC_TICK_CHECK)
				return
			continue

		edge.tick()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	while (length(curr_fire))
		var/zone/Z = curr_fire[length(curr_fire)]
		LIST_DEC(curr_fire)

		Z.process_fire()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	while (length(curr_hotspot))
		var/obj/hotspot/F = curr_hotspot[length(curr_hotspot)]
		LIST_DEC(curr_hotspot)

		F.Process()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

	while (length(curr_zones))
		var/zone/Z = curr_zones[length(curr_zones)]
		LIST_DEC(curr_zones)

		Z.tick()
		Z.needs_update = FALSE

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/air/proc/add_zone(zone/z)
	zones += z
	z.name = "Zone [next_id++]"
	mark_zone_update(z)

/datum/controller/subsystem/air/proc/remove_zone(zone/z)
	zones -= z
	zones_to_update -= z
	if (processing_zones)
		processing_zones -= z

/datum/controller/subsystem/air/proc/air_blocked(turf/A, turf/B)
	#ifdef ZASDBG
	ASSERT(isturf(A))
	ASSERT(isturf(B))
	#endif
	var/ablock
	ATMOS_CANPASS_TURF(ablock, A, B)
	if(ablock == BLOCKED)
		return BLOCKED
	ATMOS_CANPASS_TURF(., B, A)
	return ablock | .

/datum/controller/subsystem/air/proc/merge(zone/A, zone/B)
	#ifdef ZASDBG
	ASSERT(istype(A))
	ASSERT(istype(B))
	ASSERT(!A.invalid)
	ASSERT(!B.invalid)
	ASSERT(A != B)
	#endif
	if(length(A.contents) < length(B.contents))
		A.c_merge(B)
		mark_zone_update(B)
	else
		B.c_merge(A)
		mark_zone_update(A)

/datum/controller/subsystem/air/proc/connect(turf/simulated/A, turf/simulated/B)
	#ifdef ZASDBG
	ASSERT(istype(A))
	ASSERT(isturf(B))
	ASSERT(A.zone)
	ASSERT(!A.zone.invalid)
	//ASSERT(B.zone)
	ASSERT(A != B)
	#endif

	var/block = air_blocked(A,B)
	if(block & AIR_BLOCKED) return

	var/direct = !(block & ZONE_BLOCKED)
	var/space = !istype(B)

	if(!space)
		if(min(length(A.zone.contents), length(B.zone.contents)) < ZONE_MIN_SIZE || (direct && (equivalent_pressure(A.zone,B.zone) || times_fired == 0)))
			merge(A.zone,B.zone)
			return

	var/a_to_b = get_dir(A,B)
	var/b_to_a = get_dir(B,A)

	if(!A.connections) A.connections = new
	if(!B.connections) B.connections = new

	if(A.connections.get(a_to_b))
		return
	if(B.connections.get(b_to_a))
		return
	if(!space)
		if(A.zone == B.zone) return


	var/connection/c = new /connection(A,B)

	A.connections.place(c, a_to_b)
	B.connections.place(c, b_to_a)

	if(direct) c.mark_direct()

/datum/controller/subsystem/air/proc/mark_for_update(turf/T)
	#ifdef ZASDBG
	ASSERT(isturf(T))
	#endif
	if(T.needs_air_update)
		return
	tiles_to_update += T
	#ifdef ZASDBG
	T.overlays += mark
	#endif
	T.needs_air_update = 1

/datum/controller/subsystem/air/proc/mark_zone_update(zone/Z)
	#ifdef ZASDBG
	ASSERT(istype(Z))
	#endif
	if(Z.needs_update)
		return
	zones_to_update += Z
	Z.needs_update = 1

/datum/controller/subsystem/air/proc/mark_edge_sleeping(connection_edge/E)
	#ifdef ZASDBG
	ASSERT(istype(E))
	#endif
	if(E.sleeping)
		return
	active_edges -= E
	E.sleeping = 1

/datum/controller/subsystem/air/proc/mark_edge_active(connection_edge/E)
	#ifdef ZASDBG
	ASSERT(istype(E))
	#endif
	if(!E.sleeping)
		return
	active_edges += E
	E.sleeping = 0

/datum/controller/subsystem/air/proc/equivalent_pressure(zone/A, zone/B)
	return A.air.compare(B.air)

/datum/controller/subsystem/air/proc/get_edge(zone/A, zone/B)
	if(istype(B))
		for(var/connection_edge/zone/edge in A.edges)
			if(edge.contains_zone(B))
				return edge
		var/connection_edge/edge = new/connection_edge/zone(A,B)
		edges += edge
		edge.recheck()
		return edge
	else
		for(var/connection_edge/unsimulated/edge in A.edges)
			if(has_same_air(edge.B,B))
				return edge
		var/connection_edge/edge = new/connection_edge/unsimulated(A,B)
		edges += edge
		edge.recheck()
		return edge

/datum/controller/subsystem/air/proc/has_same_air(turf/A, turf/B)
	if(A.initial_gas)
		if(!B.initial_gas)
			return 0
		for(var/g in A.initial_gas)
			if(A.initial_gas[g] != B.initial_gas[g])
				return 0
	if(B.initial_gas)
		if(!A.initial_gas)
			return 0
		for(var/g in B.initial_gas)
			if(A.initial_gas[g] != B.initial_gas[g])
				return 0
	if(A.temperature != B.temperature)
		return 0
	return 1

/datum/controller/subsystem/air/proc/remove_edge(connection_edge/E)
	edges -= E
	if(!E.sleeping)
		active_edges -= E
	if(processing_edges)
		processing_edges -= E
