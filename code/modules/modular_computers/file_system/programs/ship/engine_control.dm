/datum/computer_file/program/ship/engine_control
	filename = "engctrl"
	filedesc = "Engine Control"
	nanomodule_path = /datum/nano_module/program/ship/engine_control
	program_icon_state = "engines"
	program_key_state = "tech_key"
	program_menu_icon = "eject"
	extended_desc = "Allows remote control of a spacecraft's gas thrusters, and displays information about remaining fuel."
	required_access = access_engine
	requires_access_to_run = FALSE
	required_parts = list(/obj/item/stock_parts/computer/ship_interface)
	size = 5

/datum/nano_module/program/ship/engine_control
	name = "Engine control"
	var/display_state = "status"

/datum/nano_module/program/ship/engine_control/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	data["synced"] = !isnull(linked)
	data["state"] = display_state
	data["global_state"] = linked ? linked.engines_state : 0
	data["global_limit"] = linked ? round(linked.thrust_limit*100) : 0
	var/total_thrust = 0

	var/list/enginfo = list()
	for (var/datum/ship_engine/E in linked?.engines)
		var/list/rdata = list()
		rdata["eng_type"] = E.name
		rdata["eng_on"] = E.is_on()
		rdata["eng_thrust"] = E.get_thrust()
		rdata["eng_thrust_limiter"] = round(E.get_thrust_limit()*100)
		rdata["eng_status"] = E.get_status()
		rdata["eng_reference"] = "\ref[E]"
		total_thrust += E.get_thrust()
		enginfo.Add(list(rdata))

	data["engines_info"] = enginfo
	data["total_thrust"] = total_thrust

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "engines_control.tmpl", "[linked ? "[linked.name ]" : ""] Engines Control", 450, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/program/ship/engine_control/Topic(href, href_list)
	if (..())
		return TOPIC_HANDLED

	if (href_list["state"])
		display_state = href_list["state"]
		return TOPIC_REFRESH

	if (href_list["global_toggle"])
		linked.engines_state = !linked.engines_state
		for (var/datum/ship_engine/E in linked.engines)
			if (linked.engines_state == !E.is_on())
				E.toggle()
		return TOPIC_REFRESH

	if (href_list["set_global_limit"])
		var/newlim = input("Input new thrust limit (0..100%)", "Thrust limit", linked.thrust_limit*100) as num
		if (!can_still_topic())
			return TOPIC_NOACTION
		linked.thrust_limit = clamp(newlim/100, 0, 1)
		for (var/datum/ship_engine/E in linked.engines)
			E.set_thrust_limit(linked.thrust_limit)
		return TOPIC_REFRESH

	if (href_list["global_limit"])
		linked.thrust_limit = clamp(linked.thrust_limit + text2num(href_list["global_limit"]), 0, 1)
		for (var/datum/ship_engine/E in linked.engines)
			E.set_thrust_limit(linked.thrust_limit)
		return TOPIC_REFRESH

	if (href_list["engine"])
		if (href_list["set_limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/newlim = input("Input new thrust limit (0..100)", "Thrust limit", E.get_thrust_limit()) as num
			if (!can_still_topic())
				return TOPIC_NOACTION
			var/limit = clamp(newlim/100, 0, 1)
			if (istype(E))
				E.set_thrust_limit(limit)
			return TOPIC_REFRESH
		if (href_list["limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/limit = clamp(E.get_thrust_limit() + text2num(href_list["limit"]), 0, 1)
			if (istype(E))
				E.set_thrust_limit(limit)
			return TOPIC_REFRESH

		if (href_list["toggle"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			if (istype(E))
				E.toggle()
			return TOPIC_REFRESH
		return TOPIC_REFRESH
	return TOPIC_NOACTION
