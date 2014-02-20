var/datum/controller/air_system/air_master

var/tick_multiplier = 2


//Geometry lists
/datum/controller/air_system/var/list/zones = list()
/datum/controller/air_system/var/list/edges = list()

//Geometry updates lists
/datum/controller/air_system/var/list/tiles_to_update = list()
/datum/controller/air_system/var/list/zones_to_update = list()
/datum/controller/air_system/var/list/active_hotspots = list()

/datum/controller/air_system/var/active_zones = 0

/datum/controller/air_system/var/current_cycle = 0
/datum/controller/air_system/var/update_delay = 5 //How long between check should it try to process atmos again.
/datum/controller/air_system/var/failed_ticks = 0 //How many ticks have runtimed?

/datum/controller/air_system/var/tick_progress = 0

/datum/controller/air_system/var/next_id = 1 //Used to keep track of zone UIDs.

/datum/controller/air_system/proc/Setup()
	//Purpose: Call this at the start to setup air groups geometry
	//    (Warning: Very processor intensive but only must be done once per round)
	//Called by: Gameticker/Master controller
	//Inputs: None.
	//Outputs: None.

	#ifndef ZASDBG
	set background = 1
	#endif

	world << "\red \b Processing Geometry..."
	sleep(-1)

	var/start_time = world.timeofday

	var/simulated_turf_count = 0

	for(var/turf/simulated/S in world)
		simulated_turf_count++
		S.update_air_properties()

	world << {"<font color='red'><b>Geometry initialized in [round(0.1*(world.timeofday-start_time),0.1)] seconds.</b>
Total Simulated Turfs: [simulated_turf_count]
Total Zones: [zones.len]
Total Unsimulated Turfs: [world.maxx*world.maxy*world.maxz - simulated_turf_count]</font>"}

//	spawn Start()


/datum/controller/air_system/proc/Start()
	//Purpose: This is kicked off by the master controller, and controls the processing of all atmosphere.
	//Called by: Master controller
	//Inputs: None.
	//Outputs: None.

	#ifndef ZASDBG
	set background = 1
	#endif

	while(1)
		Tick()
		sleep(max(5,update_delay*tick_multiplier))


/datum/controller/air_system/proc/Tick()
	. = 1 //Set the default return value, for runtime detection.

	current_cycle++

	//If there are tiles to update, do so.
	tick_progress = "updating turf properties"

	var/list/updating

	if(tiles_to_update.len)
		updating = tiles_to_update
		tiles_to_update = list()

		#ifdef ZASDBG
		var/updated = 0
		#endif
		for(var/turf/T in updating)
			T.update_air_properties()
			T.post_update_air_properties()
			T.needs_air_update = 0
			#ifdef ZASDBG
			T.overlays -= mark
			updated++
			#endif
			//sleep(1)

		#ifdef ZASDBG
		if(updated != updating.len)
			tick_progress = "[updating.len - updated] tiles left unupdated."
			world << "\red [tick_progress]"
			. = 0
		#endif

	//Where gas exchange happens.
	if(.)
		tick_progress = "processing edges"

	for(var/connection_edge/edge in edges)
		edge.tick()

	//Process fires.
	if(.)
		tick_progress = "processing fire"

	for(var/obj/fire/fire in active_hotspots)
		fire.process()

	//Process zones.
	if(.)
		tick_progress = "updating zones"

	active_zones = zones_to_update.len
	if(zones_to_update.len)
		updating = zones_to_update
		zones_to_update = list()
		for(var/zone/zone in updating)
			zone.tick()
			zone.needs_update = 0

	if(.)
		tick_progress = "success"

/datum/controller/air_system/proc/add_zone(zone/z)
	zones.Add(z)
	z.name = "Zone [next_id++]"
	mark_zone_update(z)

/datum/controller/air_system/proc/remove_zone(zone/z)
	zones.Remove(z)

/datum/controller/air_system/proc/air_blocked(turf/A, turf/B)
	#ifdef ZASDBG
	ASSERT(isturf(A))
	ASSERT(isturf(B))
	#endif
	var/ablock = A.c_airblock(B)
	if(ablock == BLOCKED) return BLOCKED
	return ablock | B.c_airblock(A)

/datum/controller/air_system/proc/has_valid_zone(turf/simulated/T)
	#ifdef ZASDBG
	ASSERT(istype(T))
	#endif
	return istype(T) && T.zone && !T.zone.invalid

/datum/controller/air_system/proc/merge(zone/A, zone/B)
	#ifdef ZASDBG
	ASSERT(istype(A))
	ASSERT(istype(B))
	ASSERT(A != B)
	#endif
	if(A.contents.len < B.contents.len)
		A.c_merge(B)
		mark_zone_update(B)
	else
		B.c_merge(A)
		mark_zone_update(A)

/datum/controller/air_system/proc/connect(turf/simulated/A, turf/simulated/B)
	#ifdef ZASDBG
	ASSERT(istype(A))
	ASSERT(isturf(B))
	ASSERT(A.zone)
	//ASSERT(B.zone)
	ASSERT(A != B)
	#endif

	var/block = air_master.air_blocked(A,B)
	if(block & AIR_BLOCKED) return

	var/direct = !(block & ZONE_BLOCKED)
	var/space = !istype(B)

	if(direct && !space)
		if(equivalent_pressure(A.zone,B.zone) || current_cycle == 0)
			merge(A.zone,B.zone)
			return

	var
		a_to_b = get_dir(A,B)
		b_to_a = get_dir(B,A)

	if(A.connections.get(a_to_b)) return
	if(!space)
		if(A.zone == B.zone) return
		if(B.connections.get(b_to_a)) return

	var/connection/c = new /connection(A,B)

	A.connections.place(c, a_to_b)
	if(!space) B.connections.place(c, b_to_a)

	if(direct) c.mark_direct()

/datum/controller/air_system/proc/mark_for_update(turf/T)
	#ifdef ZASDBG
	ASSERT(isturf(T))
	#endif
	if(T.needs_air_update) return
	tiles_to_update |= T
	#ifdef ZASDBG
	T.overlays += mark
	#endif
	T.needs_air_update = 1

/datum/controller/air_system/proc/mark_zone_update(zone/Z)
	#ifdef ZASDBG
	ASSERT(istype(Z))
	#endif
	if(Z.needs_update) return
	zones_to_update.Add(Z)
	Z.needs_update = 1

/datum/controller/air_system/proc/equivalent_pressure(zone/A, zone/B)
	return A.air.compare(B.air)

/datum/controller/air_system/proc/active_zones()
	return active_zones

/datum/controller/air_system/proc/get_edge(zone/A, zone/B)

	if(istype(B))
		for(var/connection_edge/zone/edge in A.edges)
			if(edge.contains_zone(B)) return edge
		var/connection_edge/edge = new/connection_edge/zone(A,B)
		edges.Add(edge)
		return edge
	else
		for(var/connection_edge/unsimulated/edge in A.edges)
			if(has_same_air(edge.B,B)) return edge
		var/connection_edge/edge = new/connection_edge/unsimulated(A,B)
		edges.Add(edge)
		return edge

/datum/controller/air_system/proc/has_same_air(turf/A, turf/B)
	if(A.oxygen != B.oxygen) return 0
	if(A.nitrogen != B.nitrogen) return 0
	if(A.toxins != B.toxins) return 0
	if(A.carbon_dioxide != B.carbon_dioxide) return 0
	if(A.temperature != B.temperature) return 0
	return 1

/datum/controller/air_system/proc/remove_edge(connection/c)
	edges.Remove(c)