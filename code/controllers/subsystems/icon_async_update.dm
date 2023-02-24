SUBSYSTEM_DEF(icon_update)
	name = "Icon Async Update"
	flags = SS_TICKER
	wait = 1	// ticks
	priority = SS_PRIORITY_ICON_UPDATE
	init_order = SS_INIT_ICON_UPDATE

	var/static/list/queue = list()


/datum/controller/subsystem/icon_update/Initialize(start_uptime)
	fire(FALSE, TRUE)


/datum/controller/subsystem/icon_update/fire(resumed, no_mc_tick)
	if (!length(queue))
		suspend()
		return
	var/cut_until = 1
	for (var/atom/atom as anything in queue)
		++cut_until
		if (QDELETED(atom))
			continue
		atom.update_icon()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()
	suspend()


/// Adds the atom to SSicon_update to be updated on some future tick. Use for large batch updates.
/atom/proc/queue_icon_update()
	SSicon_update.queue[src] = null
	SSicon_update.wake()
