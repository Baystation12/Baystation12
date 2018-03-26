/*
 MODULAR ANTAGONIST SYSTEM

 Attempts to move all the bullshit snowflake antag tracking code into its own system, which
 has the added bonus of making the display procs consistent. Still needs work/adjustment/cleanup
 but should be fairly self-explanatory with a review of the procs. Will supply a few examples
 of common tasks that the system will be expected to perform below. ~Z

 To use:
	- Get the appropriate datum via get_antag_data("antagonist id")
	 using the id var of the desired /datum/antagonist ie. var/datum/antagonist/A = get_antag_data("traitor")
	- Call add_antagonist() on the desired target mind ie. A.add_antagonist(mob.mind)
	- To ignore protected roles, supply a positive second argument.
	- To skip equipping with appropriate gear, supply a positive third argument.
*/

// Global procs.
/proc/get_antag_data(var/antag_type)
	if(GLOB.all_antag_types_[antag_type])
		return GLOB.all_antag_types_[antag_type]
	else
		var/list/all_antag_types = GLOB.all_antag_types_
		for(var/cur_antag_type in all_antag_types)
			var/datum/antagonist/antag = all_antag_types[cur_antag_type]
			if(antag && antag.is_type(antag_type))
				return antag

/proc/clear_antag_roles(var/datum/mind/player, var/implanted)
	var/list/all_antag_types = GLOB.all_antag_types_
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(!implanted || !(antag.flags & ANTAG_IMPLANT_IMMUNE))
			antag.remove_antagonist(player, 1, implanted)

/proc/update_antag_icons(var/datum/mind/player)
	var/list/all_antag_types = GLOB.all_antag_types_
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(player)
			antag.update_icons_removed(player)
			if(antag.is_antagonist(player))
				antag.update_icons_added(player)
		else
			antag.update_all_icons()

/proc/get_antags(var/atype)
	var/datum/antagonist/antag = GLOB.all_antag_types_[atype]
	if(antag && islist(antag.current_antagonists))
		return antag.current_antagonists
	return list()

/proc/player_is_antag(var/datum/mind/player, var/only_offstation_roles = 0)
	var/list/all_antag_types = GLOB.all_antag_types_
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(only_offstation_roles && !(antag.flags & ANTAG_OVERRIDE_JOB))
			continue
		if(player in antag.current_antagonists)
			return 1
		if(player in antag.pending_antagonists)
			return 1
	return 0

GLOBAL_LIST_EMPTY(all_antag_types_)
GLOBAL_LIST_EMPTY(all_antag_spawnpoints_)
GLOBAL_LIST_EMPTY(antag_names_to_ids_)
