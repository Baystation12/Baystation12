SUBSYSTEM_DEF(ao)
	name = "Ambient Occlusion"
	init_order = SS_INIT_MISC_LATE
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	flags = SS_NO_INIT
	var/static/list/image_cache = list()
	var/static/list/turf/queue = list()


/datum/controller/subsystem/ao/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Queue: [length(queue)]")


/datum/controller/subsystem/ao/fire(resume, no_mc_tick)
	if (!length(queue))
		return
	var/cut_until = 1
	for (var/turf/turf as anything in queue)
		++cut_until
		if(QDELETED(turf))
			continue
		if (turf.ao_queued == AO_UPDATE_REBUILD)
			var/previous_neighbours = turf.ao_neighbors
			turf.calculate_ao_neighbors()
			if (previous_neighbours != turf.ao_neighbors)
				turf.update_ao()
		turf.ao_queued = AO_UPDATE_NONE
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()
