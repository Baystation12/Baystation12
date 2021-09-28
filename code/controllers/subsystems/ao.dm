SUBSYSTEM_DEF(ao)
	name = "Ambient Occlusion"
	init_order = SS_INIT_MISC_LATE
	wait = 1
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
	flags = SS_NO_INIT

	var/static/list/queue = list()
	var/static/list/cache = list()


/datum/controller/subsystem/ao/stat_entry(msg)
	..("[msg] P: [queue.len]")


/datum/controller/subsystem/ao/fire(resumed, no_mc_tick)
	if (!queue.len)
		return
	var/turf/T
	var/neighbors
	for (var/i = queue.len to 1 step -1)
		T = queue[i]
		if (QDELETED(T))
			continue
		if (T.ao_queued == AO_UPDATE_REBUILD)
			neighbors = T.ao_neighbors
			T.calculate_ao_neighbors()
			if (T.ao_neighbors != neighbors)
				T.update_ao()
		else
			T.update_ao()
		T.ao_queued = AO_UPDATE_NONE
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return
	queue.Cut()
