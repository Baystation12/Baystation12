SUBSYSTEM_DEF(icon_update)
	name = "Icon Updates"
	wait = 1	// ticks
	flags = SS_TICKER
	priority = SS_PRIORITY_ICON_UPDATE
	init_order = SS_INIT_ICON_UPDATE
	var/static/list/queue = list()


/datum/controller/subsystem/icon_update/Recover()
	LIST_RESIZE(queue, 0)


/datum/controller/subsystem/icon_update/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("queue: [length(queue)]")


/datum/controller/subsystem/icon_update/Initialize(start_uptime)
	fire(FALSE, TRUE)


/datum/controller/subsystem/icon_update/fire(resumed, no_mc_tick)
	if (!length(queue))
		suspend()
		return
	var/list/params
	var/cut_until = 1
	for (var/atom/atom as anything in queue)
		++cut_until
		if (!atom)
			continue
		params = queue[atom]
		if (islist(params))
			atom.update_icon(arglist(params))
		else
			atom.update_icon()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()
	suspend()


/**
 * Adds the atom to the icon_update subsystem to be queued for icon updates. Use this if you're going to be pushing a
 * lot of icon updates at once.
 */
/atom/proc/queue_icon_update(...)
	SSicon_update.queue[src] = length(args) ? args : TRUE
	if (SSicon_update.suspended)
		SSicon_update.wake()
