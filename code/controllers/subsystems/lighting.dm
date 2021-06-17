/var/lighting_overlays_initialised = FALSE

SUBSYSTEM_DEF(lighting)
	name = "Lighting"
	wait = 1
	init_order = SS_INIT_LIGHTING

	// Queues of update counts, waiting to be rolled into stats lists
	var/list/stats_queues = list(
		"Source" = list(),
		"Corner" = list(),
		"Overlay" = list()
	)
	// Stats lists
	var/list/stats_lists = list(
		"Source" = list(),
		"Corner" = list(),
		"Overlay" = list()
	)
	var/update_stats_every = 1 SECOND
	var/next_stats_update = 0
	var/stat_updates_to_keep = 5

	var/list/light_queue   = list() // lighting sources  queued for update.
	var/lq_idex = 1
	var/list/corner_queue  = list() // lighting corners  queued for update.
	var/cq_idex = 1
	var/list/overlay_queue = list() // lighting overlays queued for update.
	var/oq_idex = 1

	var/tmp/processed_lights = 0
	var/tmp/processed_corners = 0
	var/tmp/processed_overlays = 0

/datum/controller/subsystem/lighting/stat_entry()
	var/list/out = list("Queued:{L:[light_queue.len] C:[corner_queue.len] O:[overlay_queue.len]}")
	for (var/stype in stats_lists)
		out += "[stype] updates: [jointext(stats_lists[stype], " | ")]"

	..(out.Join("\n"))

/datum/controller/subsystem/lighting/Initialize()
	InitializeTurfs()
	lighting_overlays_initialised = TRUE
	fire(FALSE, TRUE)
	..()

// It's safe to pass a list of non-turfs to this list - it'll only check turfs.
/datum/controller/subsystem/lighting/proc/InitializeTurfs(list/targets)
	for (var/turf/T in (targets || world))
		if (T.dynamic_lighting && T.loc:dynamic_lighting)
			T.lighting_build_overlay()

		// If this isn't here, BYOND will set-background us.
		CHECK_TICK

/datum/controller/subsystem/lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	if (!resumed)
		stats_queues["Source"] += processed_lights
		stats_queues["Corner"] += processed_corners
		stats_queues["Overlay"] += processed_overlays

		processed_lights = 0
		processed_corners = 0
		processed_overlays = 0

		if(next_stats_update <= world.time)
			next_stats_update = world.time + update_stats_every
			for(var/stat_name in stats_queues)
				var/stat_sum = 0
				var/list/stats_queue = stats_queues[stat_name]
				for(var/count in stats_queue)
					stat_sum += count
				stats_queue.Cut()

				var/list/stats_list = stats_lists[stat_name]
				stats_list.Insert(1, stat_sum)
				if(stats_list.len > stat_updates_to_keep)
					stats_list.Cut(stats_list.len)

	MC_SPLIT_TICK_INIT(3)
	if (!no_mc_tick)
		MC_SPLIT_TICK

	// Sources.
	while (lq_idex <= light_queue.len)
		var/datum/light_source/L = light_queue[lq_idex]
		lq_idex += 1

		if(L.check() || L.destroyed || L.force_update)
			L.remove_lum()
			if(!L.destroyed)
				L.apply_lum()

		else if(L.vis_update)	//We smartly update only tiles that became (in) visible to use.
			L.smart_vis_update()

		L.vis_update   = FALSE
		L.force_update = FALSE
		L.needs_update = FALSE

		processed_lights += 1

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (lq_idex > 1)
		light_queue.Cut(1, lq_idex)
		lq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	// Corners.
	while (cq_idex <= corner_queue.len)
		var/datum/lighting_corner/C = corner_queue[cq_idex]
		cq_idex += 1

		C.update_overlays()

		C.needs_update = FALSE

		processed_corners += 1

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (cq_idex > 1)
		corner_queue.Cut(1, cq_idex)
		cq_idex = 1

	if (!no_mc_tick)
		MC_SPLIT_TICK

	// Objects.
	while (oq_idex <= overlay_queue.len)
		var/atom/movable/lighting_overlay/O = overlay_queue[oq_idex]
		oq_idex += 1

		O.update_overlay()
		O.needs_update = 0

		processed_overlays += 1

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			break

	if (oq_idex > 1)
		overlay_queue.Cut(1, oq_idex)
		oq_idex = 1
