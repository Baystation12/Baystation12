
/datum/nano_module/program/faction_supply/proc/get_shuttle_status()
	if(my_shuttle.has_arrive_time())
		return "In transit ([my_shuttle.eta_seconds()] s)"

	if (my_shuttle.can_launch())
		return "Docked"
	return "Docking/Undocking"

/datum/nano_module/program/faction_supply/proc/get_category_contents(var/category_name)
	if(my_faction)
		return my_faction.supply_category_contents[category_name]
	return list()
