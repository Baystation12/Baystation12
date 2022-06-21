SUBSYSTEM_DEF(ao)
	name = "Ambient Occlusion"
	init_order = SS_INIT_MISC_LATE
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	flags = SS_NO_INIT
	var/static/list/queue = list()
	var/static/list/cache = list()


/datum/controller/subsystem/ao/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Queue: [queue.len]")


/datum/controller/subsystem/ao/fire(resume, no_mc_tick)
	if (!resume)
		queue = cache.Copy()
	var/turf/target
	for (var/i = queue.len to 1 step -1)
		target = queue[i]
		if(QDELETED(target))
			continue
		if (target.ao_queued == AO_UPDATE_REBUILD)
			var/previous_neighbours = target.ao_neighbors
			target.calculate_ao_neighbors()
			if (previous_neighbours != target.ao_neighbors)
				target.update_ao()
		target.ao_queued = AO_UPDATE_NONE
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return
