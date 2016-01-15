/datum/category_item/player_setup_item/antagonism/candidacy
	name = "Candidacy"
	sort_order = 2
	var/list/private_valid_special_roles

/datum/category_item/player_setup_item/antagonism/candidacy/load_character(var/savefile/S)
	S["be_special"]	>> pref.be_special_role

/datum/category_item/player_setup_item/antagonism/candidacy/save_character(var/savefile/S)
	S["be_special"]	<< pref.be_special_role

/datum/category_item/player_setup_item/antagonism/candidacy/sanitize_character()
	if(!istype(pref.be_special_role))
		pref.be_special_role = list()

	for(var/role in pref.be_special_role)
		if(!(role in valid_special_roles()))
			pref.be_special_role -= role

/datum/category_item/player_setup_item/antagonism/candidacy/content(var/mob/user)
	. += "<b>Special Role Availability:</b><br>"
	for(var/datum/antagonist/antag in all_antag_types)
		. += "[antag.role_text]: "
		if(jobban_isbanned(preference_mob(), antag.bantype))
			. += "<span class='danger'>\[BANNED\]</span><br>"
		else if(antag.role_type in pref.be_special_role)
			. += "<b>Yes</b> / <a href='?src=\ref[src];del_special=[antag.role_type]'>No</a></br>"
		else
			. += "<a href='?src=\ref[src];add_special=[antag.role_type]'>Yes</a> / <b>No</b></br>"

	var/list/ghost_traps = get_ghost_traps()
	for(var/ghost_trap_key in ghost_traps)
		var/datum/ghosttrap/ghost_trap = ghost_traps[ghost_trap_key]
		if(!ghost_trap.list_as_special_role)
			continue

		. += "[(ghost_trap.ghost_trap_role)]: "
		for(var/ban_type in ghost_trap.ban_checks)
			if(jobban_isbanned(preference_mob(), ban_type))
				. += "<span class='danger'>\[BANNED\]</span><br>"
				continue
		if(ghost_trap.pref_check in pref.be_special_role)
			. += "<b>Yes</b> / <a href='?src=\ref[src];del_special=[ghost_trap.pref_check]'>No</a></br>"
		else
			. += "<a href='?src=\ref[src];add_special=[ghost_trap.pref_check]'>Yes</a> / <b>No</b></br>"

/datum/category_item/player_setup_item/antagonism/candidacy/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["add_special"])
		if(!(href_list["add_special"] in valid_special_roles()))
			return TOPIC_HANDLED
		pref.be_special_role |= href_list["add_special"]
		return TOPIC_REFRESH

	if(href_list["del_special"])
		pref.be_special_role -= href_list["del_special"]
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/antagonism/candidacy/proc/valid_special_roles()
	if(!private_valid_special_roles)
		private_valid_special_roles = list()
		for(var/datum/antagonist/antag in all_antag_types)
			private_valid_special_roles += antag.role_type

		for(var/ghost_trap_key in ghost_traps)
			var/datum/ghosttrap/ghost_trap = ghost_traps[ghost_trap_key]
			if(!ghost_trap.list_as_special_role)
				continue
			private_valid_special_roles += ghost_trap.pref_check

	return private_valid_special_roles
