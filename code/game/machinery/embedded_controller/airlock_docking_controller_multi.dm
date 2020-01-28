//a controller for a docking port with multiple independent airlocks
//this is the master controller, that things will try to dock with.
/obj/machinery/embedded_controller/radio/docking_port_multi
	name = "docking port controller"
	program = /datum/computer/file/embedded_program/docking/multi
	var/child_tags_txt
	var/child_names_txt
	var/list/child_names = list()

/obj/machinery/embedded_controller/radio/docking_port_multi/Initialize()
	. = ..()
	var/list/names = splittext(child_names_txt, ";")
	var/list/tags = splittext(child_tags_txt, ";")
	if (names.len == tags.len)
		for (var/i = 1; i <= tags.len; i++)
			child_names[tags[i]] = names[i]

/obj/machinery/embedded_controller/radio/docking_port_multi/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nanoui/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	var/data[0]
	var/datum/computer/file/embedded_program/docking/multi/docking_program = program

	var/list/airlocks[child_names.len]
	var/i = 1
	for (var/child_tag in child_names)
		airlocks[i++] = list("name"=child_names[child_tag], "override_enabled"=(docking_program.children_override[child_tag] == "enabled"))

	data = list(
		"docking_status" = docking_program.get_docking_status(),
		"airlocks" = airlocks,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "multi_docking_console.tmpl", name, 470, 290, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/embedded_controller/radio/docking_port_multi/Topic(href, href_list)
	return 1 // Apparently we swallow all input (this is corrected legacy code)



//a docking port based on an airlock
/obj/machinery/embedded_controller/radio/airlock/docking_port_multi
	name = "docking port controller"
	program = /datum/computer/file/embedded_program/airlock/multi_docking
	var/master_tag	//for mapping
	tag_secure = 1

/obj/machinery/embedded_controller/radio/airlock/docking_port_multi/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/nanoui/master_ui = null, var/datum/topic_state/state = GLOB.default_state)
	var/data[0]
	var/datum/computer/file/embedded_program/airlock/multi_docking/airlock_program

	data = list(
		"chamber_pressure" = round(airlock_program.memory["chamber_sensor_pressure"]),
		"exterior_status" = airlock_program.memory["exterior_status"],
		"interior_status" = airlock_program.memory["interior_status"],
		"processing" = airlock_program.memory["processing"],
		"docking_status" = airlock_program.master_status,
		"airlock_disabled" = (airlock_program.docking_enabled && !airlock_program.override_enabled),
		"override_enabled" = airlock_program.override_enabled,
	)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "docking_airlock_console.tmpl", name, 470, 290, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)