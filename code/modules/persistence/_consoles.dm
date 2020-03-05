/obj/machinery/computer/persistence
	icon_keyboard = "power_key"
	icon_screen = "rust_screen"
	light_color = COLOR_ORANGE
	idle_power_usage = 250
	active_power_usage = 500
	var/ui_template
	var/initial_id_tag

/obj/machinery/computer/persistence/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/persistence/proc/build_ui_data()
	var/list/data = list()
	// data["id"] = lan ? lan.id_tag : "unset"
	// data["name"] = name
	. = data

/obj/machinery/computer/persistence/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(ui_template)
		var/list/data = build_ui_data()
		ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, ui_template, name, 400, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)