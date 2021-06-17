/datum/unit_test/uplink_setup_test
	name = "UPLINK: All uplink items shall be valid."

/datum/unit_test/uplink_setup_test/start_test()
	var/success = TRUE

	for(var/item in uplink.items)
		var/datum/uplink_item/ui = item
		success = is_valid_uplink_item(ui, "Uplink items") && success

	for(var/item in uplink.items_assoc)
		var/datum/uplink_item/ui = uplink.items_assoc[item]
		success = is_valid_uplink_item(ui, "Uplink assoc items") && success

	var/datum/uplink_random_selection/uplink_selection = get_uplink_random_selection_by_type(/datum/uplink_random_selection/blacklist)
	for(var/item in uplink_selection.items)
		var/datum/uplink_random_item/uri = item // Basically ensuring random uplink items is a subset of the full range of items
		success = is_valid_uplink_item(uplink.items_assoc[uri.uplink_item], "Random uplink items", uri.uplink_item) && success

	if(success)
		pass("All uplink items were valid.")
	else
		fail("One or more uplink items were invalid.")

	return TRUE

/datum/unit_test/uplink_setup_test/proc/is_valid_uplink_item(var/datum/uplink_item/ui, var/type, var/optional_uplink_item_type)
	. = TRUE
	if(!istype(ui))
		log_bad("[type]: [ui] was of an unexpected type: [log_info_line(ui)]")
		return FALSE
	if(!ui.category)
		log_bad("[type]: [ui] has no category.")
		. = FALSE
	var/cost = 	ui.cost(0)
	if(cost <= 0 || round(cost) != cost)
		log_bad("[type]: [ui] has an invalid modified cost of [cost].")
		. = FALSE
	if(ui.item_cost < 0 || round(ui.item_cost) != ui.item_cost)
		log_bad("[type]: [ui] has an invalid base cost of [ui.item_cost].")
		. = FALSE
	for(var/antag_type in ui.antag_costs)
		var/antag_cost = ui.antag_costs[antag_type]
		if(antag_cost <= 0 || round(antag_cost) != antag_cost)
			log_bad("[type]: [ui] has an invalid antag cost of [antag_cost] ([antag_type]).")
			. = FALSE
