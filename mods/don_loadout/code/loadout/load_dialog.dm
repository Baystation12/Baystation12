// SIERRA TODO: Get rid of it asap
// Probably need to port it to the Bay12

// Many character slots addition

/datum/preferences
	var/character_slots_count = 0

/datum/preferences/open_load_dialog(mob/user, details)
	var/dat  = list()
	dat += "<body>"
	dat += "<center>"

	dat += "<b>Выберите слот для загрузки</b><hr>"
	for(var/i = 1, i <= 10, i++)
		var/name = (slot_names && slot_names[get_slot_key(i + character_slots_count)]) || "Персонаж [i + character_slots_count]"
		if((i + character_slots_count) == default_slot)
			name = "<b>[name]</b>"
		if(i + character_slots_count <= config.character_slots)
			dat += "<a href='?src=\ref[src];changeslot=[i + character_slots_count];[details?"details=1":""]'>[name]</a><br>"
	if(config.character_slots>10)
		dat += "<br><a href='?src=\ref[src];changeslot_prev=1'> <b>&lt;</b> </a>"
		dat += " <b>[character_slots_count + 1]</b> - <b>[character_slots_count + 10]</b> "
		dat += "<a href='?src=\ref[src];changeslot_next=1'> <b>&gt;</b> </a><br>"
	dat += "<hr>"
	dat += "</center>"
	panel = new(user, "character_slots", "Слоты персонажей", 300, 390, src)
	panel.set_content(jointext(dat,null))
	panel.open()

/datum/preferences/Topic(href, list/href_list)
	if(..())
		return TRUE

	if(href_list["changeslot_next"])
		character_slots_count += 10
		if(character_slots_count >= config.character_slots)
			character_slots_count = 0
		open_load_dialog(usr, href_list["details"])
		return TRUE

	else if(href_list["changeslot_prev"])
		character_slots_count -= 10
		if(character_slots_count < 0)
			character_slots_count = config.character_slots - config.character_slots % 10
		open_load_dialog(usr, href_list["details"])
		return TRUE
