var/global/list/all_antag_types = list()
var/global/list/all_antag_spawnpoints = list()
var/global/list/antag_names_to_ids = list()

/proc/get_antag_data(var/antag_type)
	if(all_antag_types[antag_type])
		return all_antag_types[antag_type]
	else
		for(var/cur_antag_type in all_antag_types)
			var/datum/antagonist/antag = all_antag_types[cur_antag_type]
			if(antag && antag.is_type(antag_type))
				return antag

/proc/clear_antag_roles(var/datum/mind/player, var/implanted)
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(!implanted || !(antag.flags & ANTAG_IMPLANT_IMMUNE))
			antag.remove_antagonist(player, 1, implanted)

/proc/update_antag_icons(var/datum/mind/player)
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		if(player)
			antag.update_icons_removed(player)
			if(antag.is_antagonist(player))
				antag.update_icons_added(player)
		else
			antag.update_all_icons()

/proc/populate_antag_type_list()
	for(var/antag_type in typesof(/datum/antagonist)-/datum/antagonist)
		var/datum/antagonist/A = new antag_type
		all_antag_types[A.id] = A
		all_antag_spawnpoints[A.landmark_id] = list()
		antag_names_to_ids[A.role_text] = A.id

/proc/get_antags(var/atype)
	var/datum/antagonist/antag = all_antag_types[atype]
	if(antag && islist(antag.current_antagonists))
		return antag.current_antagonists
	return list()