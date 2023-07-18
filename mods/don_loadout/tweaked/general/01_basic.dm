/datum/category_item/player_setup_item/physical/basic/content()
	. = list()
	. += "[TBTN("rename", pref.real_name, "Имя")] [BTN("random_name", "Случайное имя")]"
	. += "<br />[TBTN("spawnpoint", pref.spawnpoint, "Место появления")]"
	. += "<hr />"
	. = jointext(., null)
