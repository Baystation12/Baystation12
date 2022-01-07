SUBSYSTEM_DEF(spiders)
	name = "Spiders"
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	flags = SS_NO_INIT | SS_BACKGROUND
	priority = SS_PRIORITY_SPIDERS
	wait = 2 SECONDS

	/// The handling stage for /obj/item/spider
	var/static/const/STAGE_SPIDERS = 1
	var/static/list/spiders = list()
	var/static/spiders_cost = 0

	/// The handling stage for /obj/item/spider_cocoon
	var/static/const/STAGE_SMALL_COCOONS = 2
	var/static/list/small_cocoons = list()
	var/static/small_cocoons_cost = 0

	/// The handling stage for /obj/structure/spider_cocoon
	var/static/const/STAGE_LARGE_COCOONS = 3
	var/static/list/large_cocoons = list()
	var/static/large_cocoons_cost = 0

	var/static/stage = STAGE_SPIDERS
	var/static/list/queue


/datum/controller/subsystem/spiders/VV_static()
	var/static/list/result = ..() + list(
		"STAGE_SPIDERS",
		"STAGE_SMALL_COCOONS",
		"STAGE_LARGE_COCOONS"
	)
	return result.Copy()


/datum/controller/subsystem/spiders/Recover()
	var/list/rebuild = list()
	for (var/datum/entry as anything in spiders)
		if (!QDELETED(entry))
			rebuild += entry
	spiders.Cut()
	spiders = rebuild
	spiders_cost = 0
	for (var/datum/entry as anything in small_cocoons)
		if (!QDELETED(entry))
			rebuild += entry
	small_cocoons.Cut()
	small_cocoons = rebuild
	small_cocoons_cost = 0
	for (var/datum/entry as anything in large_cocoons)
		if (!QDELETED(entry))
			rebuild += entry
	large_cocoons.Cut()
	large_cocoons = rebuild
	large_cocoons_cost = 0
	stage = STAGE_SPIDERS
	queue?.Cut()


/datum/controller/subsystem/spiders/fire(resumed, no_mc_tick)
	if (!resumed || stage == STAGE_SPIDERS)
		var/start_usage = world.tick_usage
		ProcessSpiders(resumed, no_mc_tick)
		spiders_cost = MC_AVERAGE(spiders_cost, (world.tick_usage - start_usage) * world.tick_lag)
		if (state != SS_RUNNING)
			return
		stage = STAGE_SMALL_COCOONS
		resumed = FALSE
	if (stage == STAGE_SMALL_COCOONS)
		var/start_usage = world.tick_usage
		ProcessSmallCocoons(resumed, no_mc_tick)
		small_cocoons_cost = MC_AVERAGE(small_cocoons_cost, (world.tick_usage - start_usage) * world.tick_lag)
		if (state != SS_RUNNING)
			return
		stage = STAGE_LARGE_COCOONS
		resumed = FALSE
	if (stage == STAGE_LARGE_COCOONS)
		var/start_usage = world.tick_usage
		ProcessLargeCocoons(resumed, no_mc_tick)
		large_cocoons_cost = MC_AVERAGE(large_cocoons_cost, (world.tick_usage - start_usage) * world.tick_lag)
		if (state != SS_RUNNING)
			return
		stage = STAGE_SPIDERS


/datum/controller/subsystem/spiders/proc/ProcessSpiders(resumed, no_mc_tick)
	if (!resumed)
		queue = spiders.Copy()
	var/at_uptime = Uptime()
	var/cut_until = 1
	for (var/obj/item/spider/spider as anything in queue)
		++cut_until
		if (!QDELETED(spider))
			spider.Process(at_uptime)
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
	queue.Cut()


/datum/controller/subsystem/spiders/proc/ProcessSmallCocoons(resumed, no_mc_tick)
	if (!resumed)
		queue = small_cocoons.Copy()
	var/at_uptime = Uptime()
	var/cut_until = 1
	for (var/obj/item/spider_cocoon/cocoon as anything in queue)
		++cut_until
		if (!QDELETED(cocoon))
			cocoon.Process(at_uptime)
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
	queue.Cut()


/datum/controller/subsystem/spiders/proc/ProcessLargeCocoons(resumed, no_mc_tick)
	if (!resumed)
		queue = large_cocoons.Copy()
	var/at_uptime = Uptime()
	var/cut_until = 1
	for (var/obj/structure/spider_cocoon/cocoon as anything in queue)
		++cut_until
		if (!QDELETED(cocoon))
			cocoon.Process(at_uptime)
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(1, cut_until)
	queue.Cut()
