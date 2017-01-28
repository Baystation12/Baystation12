//Engine control and monitoring console

/obj/machinery/computer/engines
	name = "engine control console"
	icon_keyboard = "tech_key"
	icon_screen = "id"
	var/state = "status"
	var/obj/effect/overmap/ship/linked

/obj/machinery/computer/engines/initialize()
	..()
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

	var/list/enginfo[0]
	for(var/datum/ship_engine/E in linked.engines)
		var/list/rdata[0]
		rdata["eng_type"] = E.name
		rdata["eng_on"] = E.is_on()
		rdata["eng_thrust"] = E.get_thrust()
		rdata["eng_thrust_limiter"] = round(E.get_thrust_limit()*100)
		rdata["eng_status"] = E.get_status()
		rdata["eng_reference"] = "\ref[E]"
		enginfo.Add(list(rdata))

	data["engines_info"] = enginfo

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "engines_control.tmpl", "[linked.name] Engines Control", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/engines/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["state"])
		state = href_list["state"]

	if(href_list["engine"])
		if(href_list["set_limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/newlim = input("Input new thrust limit (0..100)", "Thrust limit", E.get_thrust_limit()) as num
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

	add_fingerprint(usr)
	updateUsrDialog()