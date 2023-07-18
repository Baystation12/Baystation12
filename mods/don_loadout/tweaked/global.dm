/datum/category_collection/player_setup_collection/header()
	var/dat = ""
	for(var/datum/category_group/player_setup_category/PS in categories)
		if(PS == selected_category)
			dat += "<a class='linkOn' href='#'>[PS.name]</a> "
		else
			dat += "<a href='?src=\ref[src];category=\ref[PS]'>[PS.name]</a> "
	return dat

/datum/category_group/player_setup_category/physical_preferences
	name = "Внешность"

/datum/category_group/player_setup_category/background_preferences
	name = "Предыстория"

/datum/category_item/player_setup_item/background/culture
	name = "Культура"

/datum/category_group/player_setup_category/occupation_preferences
	name = "Должность"

/datum/category_group/player_setup_category/appearance_preferences
	name = "Роли"

/datum/category_group/player_setup_category/loadout_preferences
	name = "Личные вещи"

/datum/category_group/player_setup_category/global_preferences
	name = "Настройки"

/datum/category_group/player_setup_category/law_pref
	name = "Законы"

/datum/category_group/player_setup_category/controls
	name = "Управление"
