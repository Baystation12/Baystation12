//mobs can mess up unrelated tests, so we don't turn their AI on during them
#ifdef UNIT_TEST
	#define SSAI_FLAGS SS_NO_INIT | SS_NO_FIRE
#else
	#define SSAI_FLAGS SS_NO_INIT
#endif


SUBSYSTEM_DEF(ai)
	name = "AI"
	flags = SSAI_FLAGS
	init_order = SS_INIT_AI
	priority = SS_PRIORITY_AI
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 2 SECONDS
	var/static/list/active = list()
	var/static/list/queue = list()


/datum/controller/subsystem/ai/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Active AI: [active.len] \
		Run Empty Levels: [config.run_empty_levels ? "Y" : "N"]\
	"})


/datum/controller/subsystem/ai/fire(resume, no_mc_tick)
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
		ai.handle_strategicals()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


#ifdef UNIT_TEST
/datum/controller/subsystem/ai/flags = SS_NO_INIT | SS_NO_FIRE
#else
/datum/controller/subsystem/ai/flags = SS_NO_INIT
#endif
