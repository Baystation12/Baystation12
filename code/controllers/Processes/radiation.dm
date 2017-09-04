/datum/controller/process/radiation
	var/repository/radiation/linked = null

/datum/controller/process/radiation/setup()
	name = "radiation controller"
	schedule_interval = 20 // every 2 seconds
	linked = radiation_repository

/datum/controller/process/radiation/doWork()
	sources_decay()
	cache_expires()
	irradiate_targets()

// Step 1 - Sources Decay
/datum/controller/process/radiation/proc/sources_decay()
	var/list/sources = linked.sources
	for(var/thing in sources)
		var/datum/radiation_source/S = thing
		if(QDELETED(S))
			sources.Remove(S)
			continue
		if(S.decay)
			S.update_rad_power(S.rad_power - config.radiation_decay_rate)
		if(S.rad_power <= config.radiation_lower_limit)
			sources.Remove(S)
		SCHECK // This scheck probably just wastes resources, but better safe than sorry in this case.

// Step 2 - Cache Expires
/datum/controller/process/radiation/proc/cache_expires()
	var/list/resistance_cache = linked.resistance_cache
	for(var/thing in resistance_cache)
		var/turf/T = thing
		if(QDELETED(T))
			resistance_cache.Remove(T)
			continue
		if((length(T.contents) + 1) != resistance_cache[T])
			resistance_cache.Remove(T) // If its stale REMOVE it! It will get added if its needed.
		SCHECK

// Step 3 - Registered irradiatable things are checked for radiation
/datum/controller/process/radiation/proc/irradiate_targets()
	var/list/registered_listeners = GLOB.living_mob_list_ // For now just use this. Nothing else is interested anyway.
	if(length(linked.sources) > 0)
		for(var/thing in registered_listeners)
			var/atom/A = thing
			if(QDELETED(A))
				continue
			var/turf/T = get_turf(thing)
			var/rads = linked.get_rads_at_turf(T)
			if(rads)
				A.rad_act(rads)
		SCHECK

/datum/controller/process/radiation/statProcess()
	..()
	stat(null, "[linked.sources.len] sources, [linked.resistance_cache.len] cached turfs")
