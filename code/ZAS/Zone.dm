zone
	var/name
	var/invalid = 0
	var/list/contents = list()
	var/list/unsimulated_contents = list()

	var/needs_update = 0

	var/list/edges = list()

	var/datum/gas_mixture/air = new

	New()
		air_master.new_zone(src)
		air.temperature = TCMB
		air.group_multiplier = 1
		air.volume = CELL_VOLUME

	proc/add(turf/simulated/T)
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


	proc/add_unsimulated(turf/T)
	#ifdef ZASDBG
		ASSERT(!invalid)
		ASSERT(istype(T))
		ASSERT(!istype(T,/turf/simulated))
	#endif
		unsimulated_contents |= T

	proc/remove(turf/simulated/T)
	#ifdef ZASDBG
		ASSERT(!invalid)
		ASSERT(istype(T))
		ASSERT(T.zone == src)
	#endif
		contents.Remove(T)
		T.zone = null
		if(contents.len)
			air.group_multiplier = contents.len
		else
			c_invalidate()

	proc/c_merge(zone/into)
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
		into.unsimulated_contents |= unsimulated_contents

	proc/c_invalidate()
		invalid = 1
		air_master.invalid_zone(src)
		#ifdef ZASDBG
		for(var/turf/simulated/T in contents)
			T.dbg(invalid_zone)
		#endif

	proc/rebuild()
		c_invalidate()
		for(var/turf/simulated/T in contents)
			//T.dbg(invalid_zone)
			air_master.mark_for_update(T)

	proc/add_tile_air(datum/gas_mixture/tile_air)
		//air.volume += CELL_VOLUME
		air.group_multiplier = 1
		air.multiply(contents.len)
		air.merge(tile_air)
		air.divide(contents.len+1)
		air.group_multiplier = contents.len+1

	proc/tick()
		air.archive()
		if(air.check_tile_graphic())
			for(var/turf/simulated/T in contents)
				T.set_graphic(air.graphic)

	proc/remove_connection(connection/c)
		return

	proc/add_connection(connection/c)
		return

	proc/dbg_data(mob/M)
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

	proc/status()
		return 1