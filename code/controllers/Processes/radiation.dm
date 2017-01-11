/datum/controller/process/radiation
	var/repository/radiation/linked = null
	var/counter = 1

/datum/controller/process/radiation/setup()
	name = "radiation controller"
	schedule_interval = 30 // every 3 seconds
	linked = radiation_repository

/datum/controller/process/radiation/doWork()
//	set background = 1
	for(var/thing in linked.irradiated_turfs)
		var/turf/T = thing
		if(!T)
			linked.irradiated_turfs.Remove(T)
			continue
		linked.irradiated_turfs[T] -= config.radiation_decay_rate
		if(linked.irradiated_turfs[T] <= config.radiation_lower_limit)
			linked.irradiated_turfs.Remove(T)
		SCHECK
	for(var/thing in linked.irradiated_mobs)
		var/mob/living/L = thing
		if(!L)
			linked.irradiated_mobs.Remove(L)
			continue
		if(get_turf(L) in linked.irradiated_turfs)
			L.rad_act(linked.irradiated_turfs[get_turf(L)])
		if(!L.radiation)
			linked.irradiated_mobs.Remove(L)
		SCHECK
	for(var/thing in linked.sources)
		if(!thing)
			linked.sources.Remove(thing)
			continue
		var/atom/emitter = thing
		linked.radiate(emitter, emitter.rad_power)
		to_process.Cut()
		SCHECK
	counter++
	if((counter % 2) == 0)
		for(var/thing in linked.resistance_cache)
			if(!thing)
				linked.resistance_cache.Remove(thing)
				continue
			var/turf/T = thing
			if((length(T.contents) + 1) != linked.resistance_cache[T])
				T.calc_rad_resistance()
			SCHECK