SUBSYSTEM_DEF(aifast)
	name = "AI (Fast)"
	init_order = SS_INIT_AIFAST
	priority = SS_PRIORITY_AI
	wait = 0.5 SECONDS
	var/static/list/datum/ai_holder/ai_holders = list()
	var/static/list/datum/ai_holder/queue = list()


/datum/controller/subsystem/aifast/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		Active AI: [length(ai_holders)] \
		Run Empty Levels: [config.run_empty_levels ? "Y" : "N"]\
	"})


/datum/controller/subsystem/aifast/fire(resume, no_mc_tick)
	if (!resume)
		queue = ai_holders.Copy()
		if (!length(queue))
			return
	var/cut_until = 1
	for (var/datum/ai_holder/ai as anything in queue)
		++cut_until
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
			queue.Cut(1, cut_until)
			return
	queue.Cut()


#ifdef UNIT_TEST
/datum/controller/subsystem/aifast/flags = SS_NO_INIT | SS_NO_FIRE
#else
/datum/controller/subsystem/aifast/flags = SS_NO_INIT
#endif
