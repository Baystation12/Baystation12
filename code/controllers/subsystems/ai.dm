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
	var/static/tmp/list/active = list()
	var/static/tmp/list/queue = list()
	var/static/tmp/run_empty_levels


/datum/controller/subsystem/ai/stat_entry(text, force)
	IF_UPDATE_STAT
		force = TRUE
		text = {"\
			[text] | \
			Active AI: [active.len] \
			Run Empty Levels: [run_empty_levels ? "Y" : "N"]\
		"}
	..(text, force)


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
		if (!run_empty_levels && !SSpresence.population(get_z(ai.holder)))
			continue
		ai.handle_strategicals()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


SUBSYSTEM_DEF(aifast)
	name = "AI (Fast)"
	flags = SSAI_FLAGS
	init_order = SS_INIT_AIFAST
	priority = SS_PRIORITY_AI
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	wait = 0.25 SECONDS
	var/static/tmp/list/active = list()
	var/static/tmp/list/queue = list()
	var/static/tmp/run_empty_levels


/datum/controller/subsystem/aifast/stat_entry(text, force)
	IF_UPDATE_STAT
		force = TRUE
		text = {"\
			[text] | \
			Active AI: [active.len] \
			Run Empty Levels: [run_empty_levels ? "Y" : "N"]\
		"}
	..(text, force)


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
		if (!run_empty_levels && !SSpresence.population(get_z(ai.holder)))
			continue
		ai.handle_tactics()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


#undef SSAI_FLAGS
