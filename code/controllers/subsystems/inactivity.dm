SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = 1 MINUTE
	priority = SS_PRIORITY_INACTIVITY
	flags = SS_BACKGROUND
	var/static/tmp/list/current = list()


/datum/controller/subsystem/inactivity/Destroy()
	current.Cut()
	..()


/datum/controller/subsystem/inactivity/Initialize(start_timeofday)
	if (!config.kick_inactive)
		suspend()


/datum/controller/subsystem/inactivity/Recover()
	current.Cut()


/datum/controller/subsystem/inactivity/fire(resumed, no_mc_tick)
	if (!resumed)
		current = GLOB.clients.Copy()
	var/client/client
	var/kick_time = config.kick_inactive MINUTES
	for (var/i = current.len to 1 step -1)
		client = current[i]
		if (QDELETED(client))
			continue
		if (client.inactivity > kick_time && !client.holder)
			log_access("AFK: [key_name(client)]")
			to_chat_immediate(SPAN_WARNING("You were inactive for [config.kick_inactive] minutes and have been disconnected."))
			qdel(client)
		if (MC_TICK_CHECK)
			current.Cut(i)
			return
