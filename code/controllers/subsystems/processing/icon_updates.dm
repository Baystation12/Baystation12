PROCESSING_SUBSYSTEM_DEF(icon_update)
	name = "Icon Updates"
	wait = 1	// ticks
	flags = SS_TICKER
	priority = SS_PRIORITY_ICON_UPDATE
	init_order = SS_INIT_ICON_UPDATE

	var/list/queue = list()

/datum/controller/subsystem/processing/icon_update/stat_entry()
	..("QU:[queue.len]")

/datum/controller/subsystem/processing/icon_update/Initialize()
	fire(FALSE, TRUE)
	..()

/datum/controller/subsystem/processing/icon_update/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/curr = queue

	if (!curr.len)
		suspend()
		return

	while (curr.len)
		var/atom/A = curr[curr.len]
		var/list/argv = curr[A]
		curr.len--

		if (islist(argv))
			A.update_icon(arglist(argv))
		else
			A.update_icon()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/atom/proc/queue_icon_update(...)
	SSicon_update.queue[src] = args.len ? args : TRUE
	SSicon_update.wake()
