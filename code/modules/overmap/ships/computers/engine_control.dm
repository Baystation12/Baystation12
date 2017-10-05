//Engine control and monitoring console

/obj/machinery/computer/engines
	name = "engine control console"
	icon_state = "thick"
	icon_keyboard = "tech_key"
	icon_screen = "engines"
	var/state = "status"
	var/obj/effect/overmap/ship/linked

/obj/machinery/computer/engines/Initialize()
	. = ..()
	linked = map_sectors["[z]"]

/obj/machinery/computer/engines/attack_hand(var/mob/user as mob)
	if(..())
		user.unset_machine()
		return

	if(!isAI(user))
		user.set_machine(src)

	ui_interact(user)

/obj/machinery/computer/engines/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		to_chat(user, "<span class='warning'>Unable to connect to ship control systems.</span>")
		return

	var/data[0]
	data["state"] = state
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

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "engines_control.tmpl", "[linked.name] Engines Control", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/engines/Topic(href, href_list, ui_state)
	if(..())
		return 1

	if(href_list["state"])
		state = href_list["state"]

	if(href_list["global_toggle"])
		linked.engines_state = !linked.engines_state
		for(var/datum/ship_engine/E in linked.engines)
			if(linked.engines_state != E.is_on())
				E.toggle()

	if(href_list["set_global_limit"])
		var/newlim = input("Input new thrust limit (0..100%)", "Thrust limit", linked.thrust_limit*100) as num
		if(!CanInteract(usr,ui_state))
			return
		linked.thrust_limit = Clamp(newlim/100, 0, 1)
		for(var/datum/ship_engine/E in linked.engines)
			E.set_thrust_limit(linked.thrust_limit)

	if(href_list["global_limit"])
		linked.thrust_limit = Clamp(linked.thrust_limit + text2num(href_list["global_limit"]), 0, 1)
		for(var/datum/ship_engine/E in linked.engines)
			E.set_thrust_limit(linked.thrust_limit)

	if(href_list["engine"])
		if(href_list["set_limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/newlim = input("Input new thrust limit (0..100)", "Thrust limit", E.get_thrust_limit()) as num
			if(!CanInteract(usr,ui_state))
				return
			var/limit = Clamp(newlim/100, 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)

		if(href_list["limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/limit = Clamp(E.get_thrust_limit() + text2num(href_list["limit"]), 0, 1)
			if(istype(E))
				E.set_thrust_limit(limit)

		if(href_list["toggle"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			if(istype(E))
				E.toggle()

	updateUsrDialog()