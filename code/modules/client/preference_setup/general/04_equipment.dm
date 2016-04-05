/datum/preferences
	var/list/all_underwear

/datum/category_item/player_setup_item/general/equipment
	name = "Clothing"
	sort_order = 4

/datum/category_item/player_setup_item/general/equipment/load_character(var/savefile/S)
	S["all_underwear"] >> pref.all_underwear
	S["backbag"]       >> pref.backbag

/datum/category_item/player_setup_item/general/equipment/save_character(var/savefile/S)
	S["all_underwear"] << pref.all_underwear
	S["backbag"]       << pref.backbag

/datum/category_item/player_setup_item/general/equipment/sanitize_character()
	if(!istype(pref.all_underwear))
		pref.all_underwear = list()

		for(var/datum/category_group/underwear/WRC in global_underwear.categories)
			for(var/datum/category_item/underwear/WRI in WRC.items)
				if(WRI.is_default(pref.gender ? pref.gender : MALE))
					pref.all_underwear[WRC.name] = WRI.name
					break

	for(var/underwear_category in pref.all_underwear)
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[underwear_category]
		if(!UWC)
			pref.all_underwear -= underwear_category
		else
			var/datum/category_item/underwear/UWI = UWC.items_by_name[pref.all_underwear[underwear_category]]
			if(!UWI)
				pref.all_underwear -= underwear_category

	pref.backbag	= sanitize_integer(pref.backbag, 1, backbaglist.len, initial(pref.backbag))

/datum/category_item/player_setup_item/general/equipment/content()
	. = list()
	. += "<b>Equipment:</b><br>"
	for(var/datum/category_group/underwear/UWC in global_underwear.categories)
		var/item_name = pref.all_underwear[UWC.name] ? pref.all_underwear[UWC.name] : "None"
		. += "[UWC.name]: <a href='?src=\ref[src];change_underwear=[UWC.name]'><b>[item_name]</b></a><br>"

	. += "Backpack Type: <a href='?src=\ref[src];change_backpack=1'><b>[backbaglist[pref.backbag]]</b></a><br>"

	return jointext(.)

/datum/category_item/player_setup_item/general/equipment/OnTopic(var/href,var/list/href_list, var/mob/user)
	if(href_list["change_backpack"])
		var/new_backbag = input(user, "Choose your character's style of bag:", "Character Preference", backbaglist[pref.backbag]) as null|anything in backbaglist
		if(!isnull(new_backbag) && CanUseTopic(user))
			pref.backbag = backbaglist.Find(new_backbag)
			return TOPIC_REFRESH
	else if(href_list["change_underwear"])
		var/datum/category_group/underwear/UWC = global_underwear.categories_by_name[href_list["change_underwear"]]
		if(!UWC)
			return
		var/datum/category_item/underwear/selected_underwear = input(user, "Choose underwear:", "Character Preference", pref.all_underwear[UWC.name]) as null|anything in UWC.items
		if(selected_underwear && CanUseTopic(user))
			pref.all_underwear[UWC.name] = selected_underwear.name
		return TOPIC_REFRESH

	return ..()
