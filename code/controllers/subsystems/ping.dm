SUBSYSTEM_DEF(ping)
	name = "Ping"
	flags = SS_NO_INIT | SS_BACKGROUND
	wait = 15 SECONDS
	var/static/list/datum/chatOutput/chats = list()
	var/static/saved_index = 1


/datum/controller/subsystem/ping/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..("Chats: [length(chats)]")


/datum/controller/subsystem/ping/fire(resumed, no_mc_tick)
	var/datum/chatOutput/chat
	for (var/index = saved_index to length(chats))
		chat = chats[index]
		if (QDELETED(chat))
			continue
		if (chat.loaded && !chat.broken)
			chat.updatePing()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			saved_index = index
			return
	saved_index = 1
