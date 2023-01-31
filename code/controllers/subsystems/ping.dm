SUBSYSTEM_DEF(ping)
	name = "Ping"
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_ALL
	wait = 30 SECONDS
	var/static/list/datum/chatOutput/chats = list()
	var/static/list/datum/chatOutput/queue = list()


/datum/controller/subsystem/ping/fire(resumed, no_mc_tick)
	if (!resumed)
		if (!length(chats))
			return
		queue = chats.Copy()
	var/cut_until = 1
	for (var/datum/chatOutput/chat as anything in chats)
		++cut_until
		if (QDELETED(chat))
			continue
		if (chat.loaded && !chat.broken)
			chat.updatePing()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()
