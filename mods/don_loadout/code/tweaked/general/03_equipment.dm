/datum/category_item/player_setup_item/physical/equipment/content()
	. = list()
	. += "<b>Нижнее бельё:</b><br>"
	for(var/datum/category_group/underwear/UWC in GLOB.underwear.categories)
		var/item_name = (pref.all_underwear && pref.all_underwear[UWC.name]) ? pref.all_underwear[UWC.name] : "None"
		. += "[UWC.name]: <a href='?src=\ref[src];change_underwear=[UWC.name]'><b>[item_name]</b></a>"

		var/datum/category_item/underwear/UWI = UWC.items_by_name[item_name]
		if(UWI)
			for(var/datum/gear_tweak/gt in UWI.tweaks)
				. += " <a href='?src=\ref[src];underwear=[UWC.name];tweak=\ref[gt]'>[gt.get_contents(get_underwear_metadata(UWC.name, gt))]</a>"

		. += "<br>"
	. += "Тип рюкзака: <a href='?src=\ref[src];change_backpack=1'><b>[pref.backpack.name]</b></a>"
	for(var/datum/backpack_tweak/bt in pref.backpack.tweaks)
		. += " <a href='?src=\ref[src];backpack=[pref.backpack.name];tweak=\ref[bt]'>[bt.get_ui_content(get_backpack_metadata(pref.backpack, bt))]</a>"
	. += "<br>"
	. += "Стандартная настройка сенсоров униформы: <a href='?src=\ref[src];change_sensor_setting=1'>[pref.sensor_setting]</a><br />"
	. += "Блокировка сенсоров униформы: <a href='?src=\ref[src];toggle_sensors_locked=1'>[pref.sensors_locked ? "Locked" : "Unlocked"]</a><br />"
	return jointext(.,null)
