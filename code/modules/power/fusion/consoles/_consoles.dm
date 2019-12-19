/obj/machinery/computer/fusion
	icon_keyboard = "power_key"
	icon_screen = "rust_screen"
	light_color = COLOR_ORANGE
	idle_power_usage = 250
	active_power_usage = 500
	var/ui_template
	var/initial_id_tag

/obj/machinery/computer/fusion/Initialize()
	set_extension(src, /datum/extension/local_network_member)
	if(initial_id_tag)
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.set_tag(null, initial_id_tag)
	. = ..()

/obj/machinery/computer/fusion/proc/get_local_network()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	return fusion.get_local_network()

/obj/machinery/computer/fusion/attackby(var/obj/item/thing, var/mob/user)
	if(isMultitool(thing))
		var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
		fusion.get_new_tag(user)
		return
	else
		return ..()

/obj/machinery/computer/fusion/interface_interact(var/mob/user)
	ui_interact(user)
	return TRUE

/obj/machinery/computer/fusion/proc/build_ui_data()
	var/datum/extension/local_network_member/fusion = get_extension(src, /datum/extension/local_network_member)
	var/datum/local_network/lan = fusion.get_local_network()
	var/list/data = list()
	data["id"] = lan ? lan.id_tag : "unset"
	data["name"] = name
	. = data

/obj/machinery/computer/fusion/ui_interact(var/mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(ui_template)
		var/list/data = build_ui_data()
		ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, ui_template, name, 400, 600)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)