SUBSYSTEM_DEF(aifast)
	name = "AI (Fast)"
	init_order = SS_INIT_AIFAST
	priority = SS_PRIORITY_AI
	wait = 0.25 SECONDS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
#ifdef UNIT_TEST
	flags = SS_NO_INIT | SS_NO_FIRE
#else
	flags = SS_NO_INIT
#endif

	var/static/list/processing = list()
	var/static/list/current = list()


/datum/controller/subsystem/aifast/stat_entry(msg)
	..("[msg] P: [processing.len]")


/datum/controller/subsystem/aifast/Recover()
	current.Cut()


/datum/controller/subsystem/aifast/fire(resumed, no_mc_tick)
	if (!resumed)
		current = processing.Copy()
	var/datum/ai_holder/A
	for (var/i = current.len to 1 step -1)
		A = current[i]
		if (QDELETED(A) || A.busy || !A.holder)
			continue
		A.handle_tactics()
		if (MC_TICK_CHECK)
			current.Cut(i)
			return
	current.Cut()
