#define ENGINE_JUMP_DELAY 600
//Engine control and monitoring console

/obj/machinery/space_battle/engine_control
	name = "engine control console"
	icon_state = "computer"
	var/state = "status"
	var/list/engines = list()
	var/obj/effect/map/ship/linked
	var/engine_id = null
	var/cooldown = 0
	var/braked = 1
	anchored = 1
	density = 1

/obj/machinery/space_battle/engine_control/initialize()
	linked = map_sectors["[z]"]
	if (linked)
		if (!(src in linked.eng_controls))
			linked.eng_controls.Add(src)
		testing("Engines console at level [z] found a corresponding overmap object '[linked.name]'.")
	else
		testing("Engines console at level [z] was unable to find a corresponding overmap object.")

	for(var/datum/ship_engine/E in engines)
		if (E.zlevel == z && !(E in engines))
			if(engine_id && E.engine_id == src.engine_id)
				engines += E

/obj/machinery/space_battle/engine_control/attack_hand(var/mob/user as mob)
//	if(..())
//		user.unset_machine()
//		return

	if(!isAI(user))
		user.set_machine(src)

	ui_interact(user)

/obj/machinery/space_battle/engine_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		return

	var/data[0]
	data["state"] = state

	var/list/enginfo[0]
	for(var/datum/ship_engine/E in engines)
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

/obj/machinery/space_battle/engine_control/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["state"])
		state = href_list["state"]

	if(href_list["engine"])
		if(href_list["set_limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/newlim = input("Input new thrust limit (0..100)", "Thrust limit", E.get_thrust_limit()) as num
			var/limit = Clamp(newlim/100, 0, 1)
			if(E)
				E.set_thrust_limit(limit)

		if(href_list["limit"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			var/limit = Clamp(E.get_thrust_limit() + text2num(href_list["limit"]), 0, 1)
			if(E)
				E.set_thrust_limit(limit)

		if(href_list["toggle"])
			var/datum/ship_engine/E = locate(href_list["engine"])
			if(E)
				E.toggle()

	add_fingerprint(usr)
	updateUsrDialog()

/obj/machinery/space_battle/engine_control/proc/burn()
	if(braked)
		return 0
	if(engines.len == 0)
		return 0
	var/res = 0
	for(var/datum/ship_engine/E in engines)
		res |= E.burn()
	return res

/obj/machinery/space_battle/engine_control/proc/get_total_thrust()
	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()

/obj/machinery/space_battle/engine_control/proc/cooldown()
	if(cooldown > world.timeofday)
		return 0
	return 1

/obj/machinery/space_battle/engine_control/proc/stopped()
	if(!braked)
		cooldown = world.timeofday+(ENGINE_JUMP_DELAY*get_efficiency(-1,1)*10)
		braked = 1
		world << "<span class='warning'>Cooldown set to [time_remaining()] seconds!</span>"

/obj/machinery/space_battle/engine_control/process()
	if(!linked) return PROCESS_KILL
	if(cooldown())
		braked = 0
	return ..()

/obj/machinery/space_battle/engine_control/proc/time_remaining()
	var/time = (cooldown - world.timeofday)/10
	if(time < 0)
		time = 0
	return round(time)

/obj/machinery/space_battle/engine_control/examine(var/mob/user)
	..()
	if(time_remaining())
		user << "<span class='warning'>It is able to jump again in [time_remaining()] seconds!</span>"
	else
		user << "<span class='notice'>It is able to jump!</span>"
