/datum/category_item/player_setup_item/general/equipment
	name = "Clothing"
	sort_order = 4

/datum/category_item/player_setup_item/general/equipment/load_character(var/savefile/S)
	S["underwear"]	>> pref.underwear
	S["undershirt"]	>> pref.undershirt
	S["backbag"]	>> pref.backbag

/datum/category_item/player_setup_item/general/equipment/save_character(var/savefile/S)
	S["underwear"]	<< pref.underwear
	S["undershirt"]	<< pref.undershirt
	S["backbag"]	<< pref.backbag

/datum/category_item/player_setup_item/general/equipment/sanitize_character()
	pref.backbag	= sanitize_integer(pref.backbag, 1, backbaglist.len, initial(pref.backbag))

	if(!islist(pref.gear)) pref.gear = list()

	var/undies = get_undies()
	if(!get_key_by_value(undies, pref.underwear))
		pref.underwear = undies[1]
	if(!get_key_by_value(undershirt_t, pref.undershirt))
		pref.undershirt = undershirt_t[1]

/datum/category_item/player_setup_item/general/equipment/content()
	. += "<b>Equipment:</b><br>"
	. += "Underwear: <a href='?src=\ref[src];change_underwear=1'><b>[get_key_by_value(get_undies(),pref.underwear)]</b></a><br>"
	. += "Undershirt: <a href='?src=\ref[src];change_undershirt=1'><b>[get_key_by_value(undershirt_t,pref.undershirt)]</b></a><br>"
	. += "Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[backbaglist[pref.backbag]]</b></a><br>"

/datum/category_item/player_setup_item/general/equipment/proc/get_undies()
	return pref.gender == MALE ? underwear_m : underwear_f

/datum/category_item/player_setup_item/general/equipment/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["change_underwear"])
		var/underwear_options = get_undies()
		var/new_underwear = input(user, "Choose your character's underwear:", "Character Preference", get_key_by_value(get_undies(),pref.underwear)) as null|anything in underwear_options
		if(!isnull(new_underwear) && CanUseTopic(user))
			pref.underwear = underwear_options[new_underwear]
			return TOPIC_REFRESH

	else if(href_list["change_undershirt"])
		var/new_undershirt = input(user, "Choose your character's undershirt:", "Character Preference", get_key_by_value(undershirt_t,pref.undershirt)) as null|anything in undershirt_t
		if(!isnull(new_undershirt) && CanUseTopic(user))
			pref.undershirt = undershirt_t[new_undershirt]
			return TOPIC_REFRESH

	else if(href_list["change_backpack"])
		var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference", backbaglist[pref.backbag]) as null|anything in backbaglist
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag = backbaglist.Find(new_backbag)
			return TOPIC_REFRESH


	return ..()
