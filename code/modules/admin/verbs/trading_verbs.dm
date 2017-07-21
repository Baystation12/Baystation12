/client/proc/list_traders()
	set category = "Debug"
	set name = "List Traders"
	set desc = "Lists all the current traders"

	for(var/a in GLOB.traders)
		var/datum/trader/T = a
		to_chat(src, "[T.name] <a href='?_src_=vars;Vars=\ref[T]'>\ref[T]</a>")

/client/proc/add_trader()
	set category = "Debug"
	set name = "Add Trader"
	set desc = "Adds a trader to the list."

	var/list/possible = subtypesof(/datum/trader) - /datum/trader/ship - /datum/trader/ship/unique
	var/type = input(src,"Choose a type to add.") as null|anything in possible
	if(!type)
		return

	GLOB.traders += new type

/client/proc/remove_trader()
	set category = "Debug"
	set name = "Remove Trader"
	set desc = "Removes a trader from the trader list."

	var/choice = input(src, "Choose something to remove.") as null|anything in GLOB.traders
	if(!choice)
		return

	GLOB.traders -= choice
