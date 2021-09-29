SUBSYSTEM_DEF(ai)
	name = "AI"
	init_order = SS_INIT_AI
	priority = SS_PRIORITY_AI
	wait = 2 SECONDS
	//mobs can mess up unrelated tests, so we don't turn their AI on during them
	#ifdef UNIT_TEST
	flags = SS_NO_FIRE|SS_NO_INIT
	#else
	flags = SS_NO_INIT
	#endif
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/ai/stat_entry(msg_prefix)
	var/list/msg = list(msg_prefix)
	msg += "P:[processing.len]"
	..(msg.Join())

/datum/controller/subsystem/ai/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while(currentrun.len)
		var/datum/ai_holder/A = currentrun[currentrun.len]
		--currentrun.len
		if(!A || QDELETED(A) || A.busy) // Doesn't exist or won't exist soon or not doing it this tick
			continue
		A.handle_strategicals()

		if(MC_TICK_CHECK)
			return