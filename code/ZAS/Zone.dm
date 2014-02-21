
/zone/var/name
/zone/var/invalid = 0
/zone/var/list/contents = list()

/zone/var/needs_update = 0

/zone/var/list/edges = list()

/zone/var/datum/gas_mixture/air = new

/zone/New()
	air_master.add_zone(src)
	air.temperature = TCMB
	air.group_multiplier = 1
	air.volume = CELL_VOLUME

/zone/proc/add(turf/simulated/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(!air_master.has_valid_zone(T))
#endif

	var/datum/gas_mixture/turf_air = T.return_air()
	add_tile_air(turf_air)
	T.zone = src
	contents.Add(T)
	T.set_graphic(air.graphic)

/zone/proc/remove(turf/simulated/T)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(T))
	ASSERT(T.zone == src)
	soft_assert(T in contents, "Lists are weird broseph")
#endif
	contents.Remove(T)
	T.zone = null
	T.set_graphic(0)
	if(contents.len)
		air.group_multiplier = contents.len
	else
		c_invalidate()

/zone/proc/c_merge(zone/into)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif
	c_invalidate()
	for(var/turf/simulated/T in contents)
		into.add(T)
		#ifdef ZASDBG
		T.dbg(merged)
		#endif

/zone/proc/c_invalidate()
	invalid = 1
	air_master.remove_zone(src)
	#ifdef ZASDBG
	for(var/turf/simulated/T in contents)
		T.dbg(invalid_zone)
	#endif

/zone/proc/rebuild()
	c_invalidate()
	for(var/turf/simulated/T in contents)
		//T.dbg(invalid_zone)
		T.needs_air_update = 0 //Reset the marker so that it will be added to the list.
		air_master.mark_for_update(T)

/zone/proc/add_tile_air(datum/gas_mixture/tile_air)
	//air.volume += CELL_VOLUME
	air.group_multiplier = 1
	air.multiply(contents.len)
	air.merge(tile_air)
	air.divide(contents.len+1)
	air.group_multiplier = contents.len+1

/zone/proc/tick()
	air.archive()
	if(air.check_tile_graphic())
		for(var/turf/simulated/T in contents)
			T.set_graphic(air.graphic)

/zone/proc/remove_connection(connection/c)
	return

/zone/proc/add_connection(connection/c)
	return

/zone/proc/dbg_data(mob/M)
	M << name
	M << "O2: [air.oxygen] N2: [air.nitrogen] CO2: [air.carbon_dioxide] P: [air.toxins]"
	M << "P: [air.return_pressure()] kPa V: [air.volume]L T: [air.temperature]°K ([air.temperature - T0C]°C)"
	M << "O2 per N2: [(air.nitrogen ? air.oxygen/air.nitrogen : "N/A")] Moles: [air.total_moles]"
	M << "Simulated: [contents.len] ([air.group_multiplier])"
	//M << "Unsimulated: [unsimulated_contents.len]"
	//M << "Edges: [edges.len]"
	if(invalid) M << "Invalid!"
	var/zone_edges = 0
	var/space_edges = 0
	var/space_coefficient = 0
	for(var/connection_edge/E in edges)
		if(E.type == /connection_edge/zone) zone_edges++
		else
			space_edges++
			space_coefficient += E.coefficient

	M << "Zone Edges: [zone_edges]"
	M << "Space Edges: [space_edges] ([space_coefficient] connections)"

	//for(var/turf/T in unsimulated_contents)
	//	M << "[T] at ([T.x],[T.y])"