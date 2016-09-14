#define ENGINE_JUMP_DELAY 600
//Engine control and monitoring console

/obj/machinery/space_battle/engine_control
	name = "engine control console"
	icon_state = "computer"
	var/state = "status"
	var/list/engines = list()
	var/list/zlevels = list()
	var/obj/effect/overmap/ship/linked
	var/engine_id = null
	var/cooldown = 0
	anchored = 1
	density = 1

/obj/machinery/space_battle/engine_control/initialize()
	..()
	refresh_engines()

/obj/machinery/space_battle/engine_control/proc/refresh_engines()
	engines.Cut()
	for(var/datum/ship_engine/E in ship_engines)
		if ((E.zlevel in zlevels || E.zlevel == src.z) && E.engine_id == src.engine_id && !(src in engines))
			engines += E
			E.controller = src
	return engines.len


/obj/machinery/space_battle/engine_control/Destroy()
	for(var/datum/ship_engine/S in engines)
		S.controller = null
	engines.Cut()
	if(linked)
		linked.eng_controls.Cut(linked.eng_controls.Find(src), (linked.eng_controls.Find(src))+1)
		linked = null
	return ..()

/obj/machinery/space_battle/engine_control/attack_hand(var/mob/user as mob)
//	if(..())
//		user.unset_machine()
//		return

	if(!isAI(user))
		user.set_machine(src)

	if(!engines.len)
		refresh_engines()

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
	if(!cooldown())
		return 0
	if(engines.len == 0)
		return 0
	var/res = 0
	for(var/datum/ship_engine/E in engines)
		res |= E.burn()
	linked.braked = 0
	return res

/obj/machinery/space_battle/engine_control/proc/get_total_thrust()
	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()

/obj/machinery/space_battle/engine_control/proc/cooldown()
	if(cooldown > world.timeofday)
		return 0
	return 1

/obj/machinery/space_battle/engine_control/proc/stopped(var/forced = 0)
	if(!(linked.braked && cooldown()) || forced)
		cooldown = world.timeofday+(ENGINE_JUMP_DELAY*get_efficiency(-1,1)*10)
		linked.braked = 1
		var/obj/machinery/space_battle/helm/H = linked.nav_control
		if(H && istype(H))
			H.visible_message("<span class='warning'>\The [H] beeps, \"Cooldown set to [time_remaining()] seconds!\"</span>")
		src.visible_message("<span class='warning'>\icon[src] \The [src] beeps, \"Cooldown set to [time_remaining()] seconds!\"</span>")
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
