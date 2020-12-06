//Engine control and monitoring console

/obj/machinery/computer/ship/engines
	name = "engine control console"
	icon_keyboard = "tech_key"
	icon_screen = "engines"
	var/display_state = "status"

/obj/machinery/computer/ship/engines/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "ship control systems")
		return

	var/data[0]
	data["state"] = display_state	
	data["global_state"] = linked.engines_state
	data["global_limit"] = round(linked.thrust_limit*100)
	var/total_thrust = 0

	var/list/enginfo[0]
	for(var/datum/ship_engine/E in linked.engines)
		var/list/rdata[0]
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
		ui = new(user, src, ui_key, "engines_control.tmpl", "[linked.name] Engines Control", 390, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/engines/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return ..()

	if(href_list["state"])
		display_state = href_list["state"]
		return TOPIC_REFRESH

	if(href_list["global_toggle"])
		linked.engines_state = !linked.engines_state
		for(var/datum/ship_engine/E in linked.engines)
			if(linked.engines_state == !E.is_on())
				E.toggle()
		return TOPIC_REFRESH

	if(href_list["set_global_limit"])
		var/newlim = input("Input new thrust limit (0..100%)", "Thrust limit", linked.thrust_limit*100) as num
		if(!CanInteract(user, state))
			return TOPIC_NOACTION
		linked.thrust_limit = Clamp(newlim/100, 0, 1)
		for(var/datum/ship_engine/E in linked.engines)
			E.set_thrust_limit(linked.thrust_limit)
		return TOPIC_REFRESH

	if(href_list["global_limit"])
		linked.thrust_limit = Clamp(linked.thrust_limit + text2num(href_list["global_limit"]), 0, 1)
		for(var/datum/ship_engine/E in linked.engines)
			E.set_thrust_limit(linked.thrust_limit)
		return TOPIC_REFRESH

	if(href_list["engine"])
		if(href_list["set_limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/newlim = input("Input new thrust limit (0..100)", "Thrust limit", E.get_thrust_limit()) as num
			if(!CanInteract(user, state))
				return
			var/limit = Clamp(newlim/100, 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)
			return TOPIC_REFRESH			
		if(href_list["limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/limit = Clamp(E.get_thrust_limit() + text2num(href_list["limit"]), 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)
			return TOPIC_REFRESH

		if(href_list["toggle"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			if(istype(E))
				E.toggle()
			return TOPIC_REFRESH
		return TOPIC_REFRESH
	return TOPIC_NOACTION