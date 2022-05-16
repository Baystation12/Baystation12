SUBSYSTEM_DEF(misc)
	name = "Misc Updates"
	wait = 30 SECONDS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME
	var/static/list/queue = list()
	var/static/stage = STAGE_TRADERS
	var/static/cost_traders = 0
	var/static/cost_solars = 0

	var/static/const/STAGE_TRADERS = FLAG(0)
	var/static/const/STAGE_SOLARS = FLAG(1)


/datum/controller/subsystem/misc/VV_static()
	return ..() + list(
		"STAGE_TRADERS",
		"STAGE_SOLARS"
	)


/datum/controller/subsystem/misc/UpdateStat(time)
	if (PreventUpdateStat(time))
		return ..()
	..({"\
		TR: [GLOB.traders.len],[Roundm(cost_traders, 0.1)] \
		SO: [Roundm(GLOB.sun_angle, 0.1)],[Roundm(GLOB.sun_rate, 0.1)],[Roundm(cost_solars, 0.1)]
	"})


/datum/controller/subsystem/misc/Recover()
	stage = STAGE_TRADERS
	queue.Cut()


/datum/controller/subsystem/misc/Initialize(start_uptime)
	UpdateTraders(FALSE, TRUE, GLOB.trader_station_count)


/datum/controller/subsystem/misc/fire(resumed, no_mc_tick)
	var/timer
	if (!resumed || stage == STAGE_TRADERS)
		timer = world.tick_usage
		UpdateTraders(resumed, no_mc_tick)
		cost_traders = MC_AVERAGE(cost_traders, (world.tick_usage - timer) * world.tick_lag)
		if (state != SS_RUNNING)
			return
		stage = STAGE_SOLARS
		resumed = FALSE
	if (stage == STAGE_SOLARS)
		timer = world.tick_usage
		UpdateSolars(resumed, no_mc_tick)
		cost_solars = MC_AVERAGE(cost_solars, (world.tick_usage - timer) * world.tick_lag)
		if (state != SS_RUNNING)
			return
		stage = STAGE_TRADERS


GLOBAL_LIST_EMPTY(traders)
GLOBAL_LIST_EMPTY(trader_types)
GLOBAL_VAR_INIT(trader_max, 10)
GLOBAL_VAR_INIT(trader_station_count, 3)
GLOBAL_VAR_INIT(trader_unique_chance, 5)
GLOBAL_LIST_INIT(trader_stations, subtypesof(/datum/trader) - typesof(/datum/trader/ship))
GLOBAL_LIST_INIT(trader_ships, subtypesof(/datum/trader/ship) - typesof(/datum/trader/ship/unique))
GLOBAL_LIST_INIT(trader_uniques, subtypesof(/datum/trader/ship/unique))


/datum/controller/subsystem/misc/proc/UpdateTraders(resumed, no_mc_tick, generate_stations = 0)
	if (!resumed)
		queue = GLOB.trader_types.Copy()
	var/count = queue.len
	var/max = GLOB.trader_max
	var/trader_type
	var/datum/trader/trader
	if (count < max && prob(100 - 50 * count / max))
		var/list/candidates
		if (generate_stations)
			candidates = GLOB.trader_stations.Copy() - GLOB.trader_types
		else if (prob(GLOB.trader_unique_chance))
			candidates = GLOB.trader_uniques.Copy() - GLOB.trader_types
		else
			candidates = GLOB.trader_ships.Copy() - GLOB.trader_types
		if (length(candidates))
			for (var/i = (generate_stations || 1) to 1 step -1)
				trader_type = pick(candidates)
				candidates -= trader_type
				GLOB.trader_types += trader_type
				GLOB.traders[trader_type] = new trader_type
				if (generate_stations)
					CHECK_TICK
				else if (MC_TICK_CHECK)
					return
	for (var/i = count to 1 step -1)
		trader_type = queue[i]
		trader = GLOB.traders[trader_type]
		if (QDELETED(trader))
			GLOB.trader_types -= trader_type
			GLOB.traders[trader_type] = null
			continue
		if (!trader.tick())
			GLOB.trader_types -= trader_type
			GLOB.traders[trader_type] = null
			qdel(trader)
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return


GLOBAL_VAR_INIT(sun_dx, 0)
GLOBAL_VAR_INIT(sun_dy, 0)
GLOBAL_VAR_INIT(sun_angle, rand(0, 359))
GLOBAL_VAR_INIT(sun_rate, (rand(0, 1) || -1) * rand(50, 200) * 0.01 * 18)
GLOBAL_LIST_EMPTY(solar_controllers)


/datum/controller/subsystem/misc/proc/UpdateSolars(resumed, no_mc_tick)
	if (!resumed)
		var/angle = GLOB.sun_angle + GLOB.sun_rate
		if (angle > 360)
			angle -= 360
		else if (angle < 0)
			angle += 360
		var/s = sin(angle)
		var/c = cos(angle)
		var/sa = abs(s)
		var/ca = abs(c)
		if (sa < ca)
			GLOB.sun_dx = s / ca
			GLOB.sun_dy = c / ca
		else
			GLOB.sun_dx = s / sa
			GLOB.sun_dy = c / sa
		GLOB.sun_angle = angle
		queue = GLOB.solar_controllers.Copy()
	var/obj/machinery/power/solar_control/controller
	for (var/i = queue.len to 1 step -1)
		controller = queue[i]
		if (QDELETED(controller) || !controller.powernet)
			GLOB.solar_controllers -= controller
			continue
		controller.update()
		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			queue.Cut(i)
			return
