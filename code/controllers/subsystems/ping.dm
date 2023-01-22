SUBSYSTEM_DEF(ping)
	name = "Ping"
	flags = SS_NO_INIT
	runlevels = RUNLEVELS_ALL
	wait = 30 SECONDS
	var/static/list/chats = list()


/datum/controller/subsystem/ping/UpdateStat(time)
	return


/datum/controller/subsystem/ping/fire(resumed)
	for (var/chatOutput/O as anything in chats)
		if (O.loaded && !O.broken)
			O.updatePing()
		if (MC_TICK_CHECK)
			return
