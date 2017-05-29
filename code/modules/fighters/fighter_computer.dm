/obj/fighter/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	var/list/data = list()

	data["name"] = name
	data["pilot"] = pilot
	data["screen"] = screen

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fighter.tmpl", "Starfighter UI", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/fighter/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	if(href_list["leave"])
		get_out()

	if(href_list["navigation"])
		. = 1
		screen = "nav"

	if(href_list["back"])
		. = 1
		screen = "main"

	if(href_list["bluespacejump"])
		. = 1
		src.Move(locate(200,125,7))