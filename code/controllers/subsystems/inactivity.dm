SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = 1 MINUTE
	priority = SS_PRIORITY_INACTIVITY
	flags = SS_BACKGROUND

	/// The current run of clients to check for inactivity.
	var/static/list/client/queue = list()


/datum/controller/subsystem/inactivity/Recover()
	queue.Cut()


/datum/controller/subsystem/inactivity/Initialize(start_uptime)
	if (!config.kick_inactive)
		suspend()


/datum/controller/subsystem/inactivity/fire(resumed, no_mc_tick)
	if (!resumed)
		if (!length(GLOB.clients))
			return
		queue = GLOB.clients.Copy()
	var/kick_time = config.kick_inactive MINUTES
	var/cut_until = 1
	for (var/client/client as anything in queue)
		++cut_until
		if (QDELETED(client))
			continue
		if (client.inactivity > kick_time && !client.holder)
			log_access("AFK: [key_name(client)]")
			to_chat_immediate(SPAN_WARNING("You were inactive for [config.kick_inactive] minutes and have been disconnected."))
			qdel(client)
		if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
			return
	queue.Cut()
