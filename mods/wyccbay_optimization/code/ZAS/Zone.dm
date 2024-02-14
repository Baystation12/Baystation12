//OVERRIDE

/zone/add(turf/simulated/turf_to_add)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(turf_to_add))
	ASSERT(!SSair.has_valid_zone(turf_to_add))
#endif

	var/datum/gas_mixture/turf_air = turf_to_add.return_air()
	add_tile_air(turf_air)
	turf_to_add.zone = src
	contents += turf_to_add

	if(turf_to_add.hotspot)
		fire_tiles += turf_to_add
		SSair.active_fire_zones |= src

	turf_to_add.update_graphic(air.graphic)

/zone/remove(turf/simulated/turf_to_remove)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(turf_to_remove))
	ASSERT(turf_to_remove.zone == src)
	soft_assert(turf_to_remove in contents, "Lists are weird broseph")
#endif
	contents -= turf_to_remove
	fire_tiles -= turf_to_remove
	turf_to_remove.zone = null
	turf_to_remove.update_graphic(graphic_remove = air.graphic)
	if(length(contents))
		air.group_multiplier = length(contents)
	else
		c_invalidate()

/zone/c_merge(zone/into)
#ifdef ZASDBG
	ASSERT(!invalid)
	ASSERT(istype(into))
	ASSERT(into != src)
	ASSERT(!into.invalid)
#endif
	c_invalidate()
	for(var/turf/simulated/inner_turf in contents)
		into.add(inner_turf)
		inner_turf.update_graphic(graphic_remove = air.graphic)
		#ifdef ZASDBG
		inner_turf.dbg(merged)
		#endif

	//rebuild the old zone's edges so that they will be possessed by the new zone
	for(var/connection_edge/edge in edges)
		if(edge.contains_zone(into))
			continue //don't need to rebuild this edge

		for(var/turf/connecting_turf in edge.connecting_turfs)
			SSair.mark_for_update(connecting_turf)

/zone/c_invalidate()
	invalid = TRUE
	SSair.remove_zone(src)
	#ifdef ZASDBG
	for(var/turf/simulated/inner_turf in contents)
		inner_turf.dbg(invalid_zone)
	#endif

/zone/rebuild()
	if(invalid) return //Short circuit for explosions where rebuild is called many times over.
	c_invalidate()
	for(var/turf/simulated/inner_turf in contents)
		inner_turf.update_graphic(graphic_remove = air.graphic) //we need to remove the overlays so they're not doubled when the zone is rebuilt
		inner_turf.needs_air_update = FALSE //Reset the marker so that it will be added to the list.
		SSair.mark_for_update(inner_turf)

/zone/add_tile_air(datum/gas_mixture/tile_air)
	//air.volume += CELL_VOLUME
	air.group_multiplier = 1
	air.multiply(length(contents))
	air.merge(tile_air)
	air.divide(length(contents) + 1)
	air.group_multiplier = length(contents) + 1

/zone/tick()

	// Update fires.
	if(air.temperature >= PHORON_FLASHPOINT && !(src in SSair.active_fire_zones) && air.check_combustability() && length(contents))
		var/turf/turf_to_ignite = pick(contents)
		if(istype(turf_to_ignite))
			turf_to_ignite.create_fire(vsc.fire_firelevel_multiplier)
