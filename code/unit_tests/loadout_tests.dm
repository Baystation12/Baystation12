datum/unit_test/loadout_test_shall_have_name_cost_path
	name = "LOADOUT: Entries shall have name, cost, and path definitions"

datum/unit_test/loadout_test_shall_have_name_cost_path/start_test()
	var/failed = 0
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]

		if(!G.display_name)
			log_unit_test("[G]: Missing display name.")
			failed = 1
		else if(G.cost <= 0)
			log_unit_test("[G]: Invalid cost.")
			failed = 1
		else if(!G.path)
			log_unit_test("[G]: Missing path definition.")
			failed = 1

	if(failed)
		fail("One or more /datum/gear definitions had invalid display names, costs, or path definitions")
	else
		pass("All /datum/gear definitions had correct settings.")
	return  1

datum/unit_test/loadout_test_shall_have_valid_icon_states
	name = "LOADOUT: Entries shall have valid icon states"

#define LOADOUT_BAD_STATE_HELPER(bad_gear) var/atom/A = bad_gear.path ; log_unit_test("[bad_gear] - [bad_gear.path]: Did not find the icon state '[initial(A.icon_state)]' in the icon '[initial(A.icon)]'.")

datum/unit_test/loadout_test_shall_have_valid_icon_states/start_test()
	var/failed = FALSE
	for(var/gear_name in gear_datums)
		var/datum/gear/G = gear_datums[gear_name]
		if(!type_has_valid_icon_state(G.path))
			LOADOUT_BAD_STATE_HELPER(G)
			failed = TRUE
		for(var/datum/gear_tweak/path/p in G.gear_tweaks)
			for(var/path_name in p.valid_paths)
				var/path_type = p.valid_paths[path_name]
				if(!type_has_valid_icon_state(path_type))
					LOADOUT_BAD_STATE_HELPER(G)
					failed = TRUE

	if(failed)
		fail("One or more /datum/gear definitions had paths with invalid icon states.")
	else
		pass("All /datum/gear definitions had correct icon states.")
	return  1

#undef LOADOUT_BAD_STATE_HELPER

/proc/type_has_valid_icon_state(var/atom/type)
	var/atom/A = type
	return (initial(A.icon_state) in icon_states(initial(A.icon)))