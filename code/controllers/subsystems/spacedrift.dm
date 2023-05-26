//ported from TG 30/03/2020
SUBSYSTEM_DEF(spacedrift)
	name = "Space Drift"
	priority = SS_PRIORITY_SPACEDRIFT
	wait = 5
	flags = SS_NO_INIT|SS_KEEP_TIMING
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/currentrun = list()
	var/list/processing = list()

/datum/controller/subsystem/spacedrift/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("P:[length(processing)]")


/datum/controller/subsystem/spacedrift/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while (length(currentrun))
		var/atom/movable/AM = currentrun[length(currentrun)]
		LIST_DEC(currentrun)
		if (!AM)
			processing -= AM
			if (MC_TICK_CHECK)
				return
			continue

		if (AM.inertia_next_move > world.time)
			if (MC_TICK_CHECK)
				return
			continue

		if (!AM.loc || AM.loc != AM.inertia_last_loc || AM.Process_Spacemove(0))
			AM.inertia_dir = 0

		AM.inertia_ignore = null

		if (!AM.inertia_dir)
			AM.inertia_last_loc = null
			processing -= AM
			if (MC_TICK_CHECK)
				return
			continue

		var/old_dir = AM.dir
		var/old_loc = AM.loc
		AM.inertia_moving = TRUE
		step(AM, AM.inertia_dir)
		AM.inertia_moving = FALSE
		AM.inertia_next_move = world.time + AM.inertia_move_delay
		if (AM.loc == old_loc)
			AM.inertia_dir = 0

		AM.set_dir(old_dir)
		AM.inertia_last_loc = AM.loc
		if (MC_TICK_CHECK)
			return
