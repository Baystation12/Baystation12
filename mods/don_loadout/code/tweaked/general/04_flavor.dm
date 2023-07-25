/datum/category_item/player_setup_item/physical/flavor/content(mob/user)
	. += "<hr><b>Описание:</b><br>"
	. += "<a href='?src=\ref[src];flavor_text=open'>Внешность персонажа</a><br/>"
	. += "<a href='?src=\ref[src];flavour_text_robot=open'>Внешность киборга</a><br/>"


/datum/category_item/player_setup_item/physical/flavor/SetFlavorText(mob/user)
	var/HTML = ""
	HTML += "<a href='?src=\ref[src];flavor_text=general'>Главное:</a> "
	HTML += TextPreview(pref.flavor_texts["general"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=head'>Голова:</a> "
	HTML += TextPreview(pref.flavor_texts["head"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=face'>Лицо:</a> "
	HTML += TextPreview(pref.flavor_texts["face"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=eyes'>Глаза:</a> "
	HTML += TextPreview(pref.flavor_texts["eyes"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=torso'>Тело:</a> "
	HTML += TextPreview(pref.flavor_texts["torso"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=arms'>Руки:</a> "
	HTML += TextPreview(pref.flavor_texts["arms"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=hands'>Кисти:</a> "
	HTML += TextPreview(pref.flavor_texts["hands"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=legs'>Ноги:</a> "
	HTML += TextPreview(pref.flavor_texts["legs"])
	HTML += "<br>"
	HTML += "<a href='?src=\ref[src];flavor_text=feet'>Ступни:</a> "
	HTML += TextPreview(pref.flavor_texts["feet"])

	var/datum/browser/popup = new(user, "flavor_text", "Текст описания", 430, 300)
	popup.set_content(HTML)
	popup.open()

	return

/datum/category_item/player_setup_item/physical/flavor/SetFlavourTextRobot(mob/user)
	var/HTML = "<body>"
	HTML += "<center>"
	HTML += "<br></center>"
	HTML += "<a href='?src=\ref[src];flavour_text_robot=Default'>По умолчанию:</a> "
	HTML += TextPreview(pref.flavour_texts_robot["Default"])
	HTML += "<hr />"
	for(var/module in SSrobots.all_module_names)
		HTML += "<a href='?src=\ref[src];flavour_text_robot=[module]'>[module]:</a> "
		HTML += TextPreview(pref.flavour_texts_robot[module])
		HTML += "<br>"

	var/datum/browser/popup = new(user, "flavor_text_robot", "Текст описания", 430, 300)
	popup.set_content(HTML)
	popup.open()
	return
