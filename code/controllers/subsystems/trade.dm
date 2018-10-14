SUBSYSTEM_DEF(trade)
	name = "Trade"
	wait = 1 MINUTE
	priority = SS_PRIORITY_TRADE
	//Initializes at default time

	var/list/traders = list()
	var/tmp/list/current_traders
	var/max_traders = 10

/datum/controller/subsystem/trade/Initialize()
	. = ..()
	for(var/i in 1 to rand(1,3))
		generate_trader(1)

/datum/controller/subsystem/trade/fire(resumed = FALSE)
	if (!resumed)
		current_traders = traders.Copy()

	while(current_traders.len)
		var/datum/trader/T = current_traders[current_traders.len]
		current_traders.len--

		if(!T.tick())
			traders -= T
			qdel(T)
		if (MC_TICK_CHECK)
			return

	if((traders.len <= max_traders) && prob(100 - 50 * traders.len / max_traders))
		generate_trader()

/datum/controller/subsystem/trade/stat_entry()
	..("Traders: [traders.len]")

/datum/controller/subsystem/trade/proc/generate_trader(var/stations = 0)
	var/list/possible = list()
	if(stations)
		possible += subtypesof(/datum/trader) - typesof(/datum/trader/ship)
	else
		if(prob(5))
			possible += subtypesof(/datum/trader/ship/unique)
		else
			possible += subtypesof(/datum/trader/ship) - typesof(/datum/trader/ship/unique)

	for(var/i in 1 to 10)
		var/type = pick(possible)
		var/bad = 0
		for(var/trader in traders)
			if(istype(trader,type))
				bad = 1
				break
		if(bad)
			continue
		traders += new type
		return