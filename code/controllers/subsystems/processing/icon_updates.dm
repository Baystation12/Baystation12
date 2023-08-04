SUBSYSTEM_DEF(icon_update)
	name = "Icon Updates"
	wait = 1	// ticks
	flags = SS_TICKER
	priority = SS_PRIORITY_ICON_UPDATE
	init_order = SS_INIT_ICON_UPDATE
	var/static/list/queue = list()


/datum/controller/subsystem/icon_update/Recover()
	LIST_RESIZE(queue, 0)
	queue = list()


/datum/controller/subsystem/icon_update/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("queue: [length(queue)]")


/datum/controller/subsystem/icon_update/Initialize(start_uptime)
	fire(FALSE, TRUE)


/datum/controller/subsystem/icon_update/fire(resumed, no_mc_tick)
	var/atom/atom
	var/list/params
	var/queue_length = length(queue)
	for (var/i = 1 to queue_length)
		atom = queue[i]
		if (QDELETED(atom))
			continue
		params = queue[atom]
		if (islist(params))
			atom.update_icon(arglist(params))
		else
			atom.update_icon()
		if (no_mc_tick)
			if (i % 100)
				continue
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, i + 1)
			return
	if (queue_length)
		queue.Cut(1, queue_length + 1)
	suspend()


/**
 * Adds the atom to the icon_update subsystem to be queued for icon updates. Use this if you're going to be pushing a
 * lot of icon updates at once.
 */
/atom/proc/queue_icon_update(...)
	SSicon_update.queue[src] = length(args) ? args : TRUE
	if (SSicon_update.suspended)
		SSicon_update.wake()


/hook/game_ready/proc/FlushIconUpdateQueue()
	SSicon_update.fire(FALSE, TRUE)
	return TRUE
