
/obj/machinery/item_manufacturer/attack_hand(var/mob/living/user)
	if(anchored)
		add_fingerprint(user)
		user.set_machine(src)
		ui_interact(user)
	else
		to_chat(user,"<span class='notice'>[src] must be wrenched down first.</span>")

/obj/machinery/item_manufacturer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)

	/*
	if(!can_use(user))
		if(ui)
			ui.close()
			interacting_mob = null
		return
		*/

	var/data[0]

	data["designs_ui"] = designs_ui
	data["build_queue"] = building_queue_interact
	data["detected_materials"] = detected_materials
	data["detected_components"] = detected_components
	data["user"] = "\ref[user]"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "manufactory.tmpl", "Jiralhanae Manufactory", 600, 400)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/item_manufacturer/Topic(href, href_list)

	if(href_list["construct"])
		var/mob/user = locate(href_list["user"])
		attempt_build_design(href_list["construct"], user)

	if(href_list["update_materials"])
		scan_for_materials()
