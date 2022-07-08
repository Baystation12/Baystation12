#define TOPIC_UPDATE_PREVIEW 4
#define TOPIC_HARD_REFRESH   8 // use to force a browse() call, unblocking some rsc operations
#define TOPIC_REFRESH_UPDATE_PREVIEW (TOPIC_HARD_REFRESH|TOPIC_UPDATE_PREVIEW)

var/global/const/CHARACTER_PREFERENCE_INPUT_TITLE = "Character Preference"

/datum/category_group/player_setup_category/physical_preferences
	name = "Physical"
	sort_order = 1
	item_wrap_index = 2
	category_item_type = /datum/category_item/player_setup_item/physical

/datum/category_group/player_setup_category/background_preferences
	name = "Background"
	sort_order = 2
	category_item_type = /datum/category_item/player_setup_item/background

/datum/category_group/player_setup_category/background_preferences/content(var/mob/user)
	. = ""
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		. += "[player_setup_item.content(user)]<br>"

/datum/category_group/player_setup_category/occupation_preferences
	name = "Occupation"
	sort_order = 3
	category_item_type = /datum/category_item/player_setup_item/occupation

/datum/category_group/player_setup_category/appearance_preferences
	name = "Roles"
	sort_order = 4
	category_item_type = /datum/category_item/player_setup_item/antagonism

/datum/category_group/player_setup_category/loadout_preferences
	name = "Loadout"
	sort_order = 6
	category_item_type = /datum/category_item/player_setup_item/loadout

/datum/category_group/player_setup_category/global_preferences
	name = "Global"
	sort_order = 7
	category_item_type = /datum/category_item/player_setup_item/player_global

/datum/category_group/player_setup_category/law_pref
	name = "Laws"
	sort_order = 8
	category_item_type = /datum/category_item/player_setup_item/law_pref


/****************************
* Category Collection Setup *
****************************/
/datum/category_collection/player_setup_collection
	category_group_type = /datum/category_group/player_setup_category
	var/datum/preferences/preferences
	var/datum/category_group/player_setup_category/selected_category = null

/datum/category_collection/player_setup_collection/New(var/datum/preferences/preferences)
	src.preferences = preferences
	..()
	selected_category = categories[1]

/datum/category_collection/player_setup_collection/Destroy()
	preferences = null
	selected_category = null
	return ..()

/datum/category_collection/player_setup_collection/proc/sanitize_setup()
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.sanitize_setup()

/datum/category_collection/player_setup_collection/proc/load_character(datum/pref_record_reader/R)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_character(R)

/datum/category_collection/player_setup_collection/proc/save_character(datum/pref_record_writer/W)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_character(W)

/datum/category_collection/player_setup_collection/proc/load_preferences(datum/pref_record_reader/R)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.load_preferences(R)

/datum/category_collection/player_setup_collection/proc/save_preferences(datum/pref_record_writer/W)
	for(var/datum/category_group/player_setup_category/PS in categories)
		PS.save_preferences(W)

/datum/category_collection/player_setup_collection/proc/header()
	var/dat = ""
	for(var/datum/category_group/player_setup_category/PS in categories)
		if(PS == selected_category)
			dat += "[PS.name] "	// TODO: Check how to properly mark a href/button selected in a classic browser window
		else
			dat += "<a href='?src=\ref[src];category=\ref[PS]'>[PS.name]</a> "
	return dat

/datum/category_collection/player_setup_collection/proc/content(var/mob/user)
	if(selected_category)
		return selected_category.content(user)

/datum/category_collection/player_setup_collection/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/user = usr
	if(!user.client)
		return 1

	if(href_list["category"])
		var/category = locate(href_list["category"])
		if(category && (category in categories))
			selected_category = category
		. = 1

	if(.)
		user.client.prefs.update_setup_window(user)

/**************************
* Category Category Setup *
**************************/
/datum/category_group/player_setup_category
	var/sort_order = 0
	var/item_wrap_index

/datum/category_group/player_setup_category/dd_SortValue()
	return sort_order

/datum/category_group/player_setup_category/proc/sanitize_setup()
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		player_setup_item.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		player_setup_item.sanitize_character()

/datum/category_group/player_setup_category/proc/load_character(var/savefile/S)
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		player_setup_item.load_character(S)

/datum/category_group/player_setup_category/proc/save_character(var/savefile/S)
	// Sanitize all data, then save it
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		player_setup_item.sanitize_character()
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		player_setup_item.save_character(S)

/datum/category_group/player_setup_category/proc/load_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		player_setup_item.load_preferences(S)

/datum/category_group/player_setup_category/proc/save_preferences(var/savefile/S)
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		player_setup_item.sanitize_preferences()
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		player_setup_item.save_preferences(S)

/datum/category_group/player_setup_category/proc/content(var/mob/user)
	. = "<table style='width:100%'><tr style='vertical-align:top'><td style='width:50%'>"
	var/current = 0
	var/wrap_index = item_wrap_index || items.len / 2
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		if(wrap_index && current++ >= wrap_index)
			wrap_index = 0
			. += "</td><td></td><td style='width:50%'>"
		. += "[player_setup_item.content(user)]<br>"
	. += "</td></tr></table>"

/datum/category_group/player_setup_category/occupation_preferences/content(var/mob/user)
	for(var/datum/category_item/player_setup_item/player_setup_item in items)
		. += "[player_setup_item.content(user)]<br>"

/**********************
* Category Item Setup *
**********************/
/datum/category_item/player_setup_item
	var/sort_order = 0
	var/datum/preferences/pref

/datum/category_item/player_setup_item/New()
	..()
	var/datum/category_collection/player_setup_collection/psc = category.collection
	pref = psc.preferences

/datum/category_item/player_setup_item/Destroy()
	pref = null
	return ..()

/datum/category_item/player_setup_item/dd_SortValue()
	return sort_order

/*
* Called when the item is asked to load per character settings
*/
/datum/category_item/player_setup_item/proc/load_character(datum/pref_record_reader/R)
	return

/*
* Called when the item is asked to save per character settings
*/
/datum/category_item/player_setup_item/proc/save_character(datum/pref_record_writer/W)
	return

/*
* Called when the item is asked to load user/global settings
*/
/datum/category_item/player_setup_item/proc/load_preferences(datum/pref_record_reader/R)
	return

/*
* Called when the item is asked to save user/global settings
*/
/datum/category_item/player_setup_item/proc/save_preferences(datum/pref_record_writer/W)
	return

/datum/category_item/player_setup_item/proc/content()
	return

/datum/category_item/player_setup_item/proc/sanitize_character()
	return

/datum/category_item/player_setup_item/proc/sanitize_preferences()
	return

/datum/category_item/player_setup_item/Topic(var/href,var/list/href_list)
	if(..())
		return 1
	var/mob/pref_mob = preference_mob()
	if(!pref_mob || !pref_mob.client)
		return 1
	// If the usr isn't trying to alter their own mob then they must instead be an admin
	if(usr != pref_mob && !check_rights(R_ADMIN, 0, usr))
		return 1

	. = OnTopic(href, href_list, usr)

	// The user might have joined the game or otherwise had a change of mob while tweaking their preferences.
	pref_mob = preference_mob()
	if(!pref_mob || !pref_mob.client)
		return 1

	if (. & TOPIC_UPDATE_PREVIEW)
		pref_mob.client.prefs.preview_icon = null
	if (. & TOPIC_HARD_REFRESH)
		pref_mob.client.prefs.open_setup_window(usr)
	else if (. & TOPIC_REFRESH)
		pref_mob.client.prefs.update_setup_window(usr)

/datum/category_item/player_setup_item/CanUseTopic(var/mob/user)
	return 1

/datum/category_item/player_setup_item/proc/OnTopic(var/href,var/list/href_list, var/mob/user)
	return TOPIC_NOACTION

/datum/category_item/player_setup_item/proc/preference_mob()
	if(!pref.client)
		for(var/client/C)
			if(C.ckey == pref.client_ckey)
				pref.client = C
				break

	if(pref.client)
		return pref.client.mob

/datum/category_item/player_setup_item/proc/preference_species()
	return all_species[pref.species] || all_species[SPECIES_HUMAN]
