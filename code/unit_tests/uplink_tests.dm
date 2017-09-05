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
	if(!istype(ui))
		log_bad("[type]: [ui] was of an unexpected type: [ui ? ui.type : (optional_uplink_item_type ? optional_uplink_item_type : "NULL")]")
		return FALSE
	if(!ui.category)
		log_bad("[type]: [ui] has no category.")
		return FALSE
	var/cost = 	ui.cost(0)
	if(cost <= 0)
		log_bad("[type]: [ui] has an invalid cost of [cost].")
		return FALSE
	return TRUE
