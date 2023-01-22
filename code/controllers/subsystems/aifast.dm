SUBSYSTEM_DEF(aifast)
	name = "AI (Fast)"
	init_order = SS_INIT_AIFAST
	priority = SS_PRIORITY_AI
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 0.25 SECONDS
	var/static/list/active = list()
	var/static/list/queue = list()


/datum/controller/subsystem/aifast/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Active AI: [active.len] \
		Run Empty Levels: [config.run_empty_levels ? "Y" : "N"]\
	"})


/datum/controller/subsystem/aifast/fire(resume, no_mc_tick)
	if (!resume)
		queue = active.Copy()
	var/datum/ai_holder/ai
	for (var/i = queue.len to 1 step -1)
		ai = queue[i]
		if (QDELETED(ai) || ai.busy)
			continue
		if (!ai.holder)
			continue
		if (!config.run_empty_levels && !SSpresence.population(get_z(ai.holder)))
			continue
		ai.handle_tactics()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


#ifdef UNIT_TEST
/datum/controller/subsystem/aifast/flags = SS_NO_INIT | SS_NO_FIRE
#else
/datum/controller/subsystem/aifast/flags = SS_NO_INIT
#endif
