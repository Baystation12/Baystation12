PROCESSING_SUBSYSTEM_DEF(icon_update)
	name = "Icon Updates"
	wait = 1	// ticks
	flags = SS_TICKER
	priority = SS_PRIORITY_ICON_UPDATE
	init_order = SS_INIT_ICON_UPDATE
	var/list/queue = list()


/datum/controller/subsystem/processing/icon_update/Initialize(start_uptime)
	fire(FALSE, TRUE)


/datum/controller/subsystem/processing/icon_update/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/curr = queue

	if (!length(curr))
		suspend()
		return

	while (length(curr))
		var/atom/A = curr[length(curr)]
		var/list/argv = curr[A]
		LIST_DEC(curr)

		if (islist(argv))
			A.update_icon(arglist(argv))
		else
			A.update_icon()

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return

/**
 * Adds the atom to the icon_update subsystem to be queued for icon updates. Use this if you're going to be pushing a
 * lot of icon updates at once.
 */
/atom/proc/queue_icon_update(...)
	SSicon_update.queue[src] = length(args) ? args : TRUE
	SSicon_update.wake()
