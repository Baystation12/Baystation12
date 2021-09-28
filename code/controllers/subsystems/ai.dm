SUBSYSTEM_DEF(ai)
	name = "AI"
	init_order = SS_INIT_AI
	priority = SS_PRIORITY_AI
	wait = 2 SECONDS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
#ifdef UNIT_TEST
	flags = SS_NO_INIT | SS_NO_FIRE
#else
	flags = SS_NO_INIT
#endif

	var/static/list/processing = list()
	var/static/list/current = list()


/datum/controller/subsystem/ai/stat_entry(msg)
	..("[msg] P: [processing.len]")


/datum/controller/subsystem/ai/Recover()
	current.Cut()


/datum/controller/subsystem/ai/fire(resumed, no_mc_tick)
	if (!resumed)
		current = processing.Copy()
	var/datum/ai_holder/A
	for (var/i = current.len to 1 step -1)
		A = current[i]
		if (QDELETED(A) || A.busy)
			continue
		A.handle_strategicals()
		if (MC_TICK_CHECK)
			current.Cut(i)
			return
	current.Cut()
