/client/proc/list_traders()
	set category = "Debug"
	set name = "Traders - List"
	for (var/trader_type in GLOB.trader_types)
		var/datum/trader/trader = GLOB.traders[trader_type]
		to_chat(src, "[trader.name] <a href='?_src_=vars;Vars=\ref[trader]'>\ref[trader]</a>")


/client/proc/add_trader()
	set category = "Debug"
	set name = "Traders - Add"
	var/list/possible = subtypesof(/datum/trader) - /datum/trader/ship - /datum/trader/ship/unique - GLOB.trader_types
	var/trader_type = input(src, "Choose a trader to add:") as null | anything in possible
	if (!trader_type)
		return
	GLOB.traders[trader_type] = new trader_type
	GLOB.trader_types += trader_type


/client/proc/remove_trader()
	set category = "Debug"
	set name = "Traders - Remove"
	var/trader_type = input(src, "Choose something to remove.") as null | anything in GLOB.trader_types
	if (!trader_type)
		return
	var/trader = GLOB.traders[trader_type]
	GLOB.trader_types -= trader_type
	GLOB.traders[trader_type] = null
	qdel(trader)
