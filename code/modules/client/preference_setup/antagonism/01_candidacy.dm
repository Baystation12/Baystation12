/datum/preferences
	var/list/never_be_special_role
	var/list/be_special_role

/datum/category_item/player_setup_item/antagonism/candidacy
	name = "Candidacy"
	sort_order = 1

/datum/category_item/player_setup_item/antagonism/candidacy/load_character(var/savefile/S)
	from_file(S["be_special"],           pref.be_special_role)
	from_file(S["never_be_special"],     pref.never_be_special_role)

/datum/category_item/player_setup_item/antagonism/candidacy/save_character(var/savefile/S)
	to_file(S["be_special"],             pref.be_special_role)
	to_file(S["never_be_special"],       pref.never_be_special_role)

/datum/category_item/player_setup_item/antagonism/candidacy/sanitize_character()
	if(!istype(pref.be_special_role))
		pref.be_special_role = list()
	if(!istype(pref.never_be_special_role))
		pref.never_be_special_role = list()

	var/special_roles = valid_special_roles()
	for(var/role in pref.be_special_role)
		if(!(role in special_roles))
			pref.be_special_role -= role
	for(var/role in pref.never_be_special_role)
		if(!(role in special_roles))
			pref.never_be_special_role -= role

/datum/category_item/player_setup_item/antagonism/candidacy/content(var/mob/user)
	. = list()
	. += "<b>Special Role Availability:</b><br>"
	. += "<table>"
	var/list/all_antag_types = all_antag_types()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		. += "<tr><td>[antag.role_text]: </td><td>"
		if(jobban_isbanned(preference_mob(), antag.id) || (antag.id == MODE_MALFUNCTION && jobban_isbanned(preference_mob(), "AI")))
			. += "<span class='danger'>\[BANNED\]</span><br>"
		else if(antag.role_type in pref.be_special_role)
			. += "<span class='linkOn'>High</span> <a href='?src=\ref[src];del_special=[antag.role_type]'>Low</a> <a href='?src=\ref[src];add_never=[antag.role_type]'>Never</a></br>"
		else if(antag.role_type in pref.never_be_special_role)
			. += "<a href='?src=\ref[src];add_special=[antag.role_type]'>High</a> <a href='?src=\ref[src];del_special=[antag.role_type]'>Low</a> <span class='linkOn'>Never</span></br>"
		else
			. += "<a href='?src=\ref[src];add_special=[antag.role_type]'>High</a> <span class='linkOn'>Low</span> <a href='?src=\ref[src];add_never=[antag.role_type]'>Never</a></br>"
		. += "</td></tr>"

	var/list/ghost_traps = decls_repository.get_decls_of_subtype(/decl/ghost_trap)
	for(var/ghost_trap_type in ghost_traps)
		var/decl/ghost_trap/ghost_trap = ghost_traps[ghost_trap_type]
		if(!(ghost_trap.trap_flags & GHOST_TRAP_FLAG_HAS_CANDIDACY))
			continue
		. += "<tr><td>[(ghost_trap.name)]: </td><td>"
		if(ghost_trap.IsBanned(preference_mob()))
			. += "<span class='danger'>\[BANNED\]</span><br>"
		else if(ghost_trap.name in pref.be_special_role)
			. += "<span class='linkOn'>High</span> <a href='?src=\ref[src];del_special=[ghost_trap.name]'>Low</a> <a href='?src=\ref[src];add_never=[ghost_trap.name]'>Never</a></br>"
		else if(ghost_trap.name in pref.never_be_special_role)
			. += "<a href='?src=\ref[src];add_special=[ghost_trap.name]'>High</a> <a href='?src=\ref[src];del_special=[ghost_trap.name]'>Low</a> <span class='linkOn'>Never</span></br>"
		else
			. += "<a href='?src=\ref[src];add_special=[ghost_trap.name]'>High</a> <span class='linkOn'>Low</span> <a href='?src=\ref[src];add_never=[ghost_trap.name]'>Never</a></br>"
		. += "</td></tr>"
	. += "</table>"
	. = jointext(.,null)

/datum/category_item/player_setup_item/antagonism/candidacy/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["add_special"])
		if(!(href_list["add_special"] in valid_special_roles()))
			return TOPIC_HANDLED
		pref.be_special_role |= href_list["add_special"]
		pref.never_be_special_role -= href_list["add_special"]
		return TOPIC_REFRESH

	if(href_list["del_special"])
		if(!(href_list["del_special"] in valid_special_roles()))
			return TOPIC_HANDLED
		pref.be_special_role -= href_list["del_special"]
		pref.never_be_special_role -= href_list["del_special"]
		return TOPIC_REFRESH

	if(href_list["add_never"])
		pref.be_special_role -= href_list["add_never"]
		pref.never_be_special_role |= href_list["add_never"]
		return TOPIC_REFRESH

	return ..()

/datum/category_item/player_setup_item/antagonism/candidacy/proc/valid_special_roles()
	var/list/private_valid_special_roles = list()

	var/list/all_antag_types = all_antag_types()
	for(var/antag_type in all_antag_types)
		var/datum/antagonist/antag = all_antag_types[antag_type]
		private_valid_special_roles += antag.role_type

	var/list/ghost_traps = decls_repository.get_decls_of_subtype(/decl/ghost_trap)
	for(var/ghost_trap_type in ghost_traps)
		var/decl/ghost_trap/ghost_trap = ghost_traps[ghost_trap_type]
		if(!(ghost_trap.trap_flags & GHOST_TRAP_FLAG_HAS_CANDIDACY))
			continue
		private_valid_special_roles += ghost_trap.name

	return private_valid_special_roles

var/const/ROLE_DESIRE_NEVER     = 0
var/const/ROLE_DESIRE_SOMETIMES = 1
var/const/ROLE_DESIRE_ALWAYS    = 2
/client/proc/wishes_to_be_role(var/role)
	if(!prefs)
		return ROLE_DESIRE_NEVER
	if(role in prefs.be_special_role)
		return ROLE_DESIRE_ALWAYS
	if(role in prefs.never_be_special_role)
		return ROLE_DESIRE_NEVER
	return ROLE_DESIRE_SOMETIMES	//Default to "sometimes" if they don't opt-out.

