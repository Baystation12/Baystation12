#define BASE_HACKING_TIME 45 // 45 seconds
#define EMP "Electromagnetic Pulse" // Limited to machinery.
#define FRY_CIRCUIT "Electromagnetic Overload" // Limited to machinery.
#define SHATTER "Overload"// Limited to lights.
#define UI_INTERACT "RCON" // Limited to machines with ui_interact
#define UNLOCK "Bruteforce Encryption Hack"// Limited to machines with ui_interact
#define ION "Discharge Capacitors" // Limited to APC's
#define DISABLE "Disable Activity" // Limited to Sensors

/obj/machinery/space_battle/hacking
	name = "Hacking System"
	desc = "An advanced remote hacking system."
	icon = 'icons/obj/ship_battles.dmi'
	icon_state = "computer"
	density = 1
	anchored = 1
	var/list/target_teams = list()
	var/list/hacked = list()				  //[1]=name, [2] = selectable type list, [3] = selectable action list,[3][1] = action, [3][2] = action delay, [4] = added delay to hacking.
	var/list/available_categories = list(list("Sensors", list(/obj/machinery/space_battle/missile_sensor), list(EMP = 180, FRY_CIRCUIT = 180, DISABLE = 180), 60),\
										 list("Life Support", list(/obj/machinery/alarm), list(EMP = 30, FRY_CIRCUIT = 60, UI_INTERACT = 90, UNLOCK = 150), 30),\
										 list("Lighting", list(/obj/machinery/light), list(SHATTER = 20), 1), \
										 list("Power", list(/obj/machinery/power/apc), list(EMP = 180, FRY_CIRCUIT = 180, UI_INTERACT = 30, UNLOCK = 180, SURGE = 30), 90), \
										 list("Defensive Systems", list(/obj/machinery/space_battle/ecm, /obj/machinery/space_battle/shieldwallgen), list(EMP = 240, FRY_CIRCUIT = 180, UI_INTERACT = 30, UNLOCK = 270), 300), \
										 list("Engines", list(/obj/machinery/space_battle/engine), list(EMP = 90, FRY_CIRCUIT = 180, UI_INTERACT = 90), 120))

	var/team = 0
	var/obj/machinery/hacking
	var/speed = 1
	var/hacking_time = 0
	var/detection = 0
	var/menu = "hacking"
	var/obj/machinery/selected
	var/operation = "Hack.exe"
	var/can_cancel = 1

/obj/machinery/space_battle/hacking/attack_hand(var/mob/user)
	ui_interact(user)

/obj/machinery/space_battle/hacking/New()
	..()

/obj/machinery/space_battle/hacking/update_icon()
	return

/obj/machinery/space_battle/hacking/reconnect()
	target_teams.Cut()
	for(var/obj/missile_start/S in world)
		var/area/ship_battle/A = get_area(src)
		if(!(A && istype(A))) continue
		if(A.team != S.team)
			if(S.active)
				target_teams.Add("[S.team]")

	if(target_teams.len)
		team = target_teams[1]
	..()

/obj/machinery/space_battle/hacking/process()
	if(!hacking_time)
		if(!detection)
			return
		if(prob(1 * get_efficiency(0,1)))
			detection--
	else if(world.timeofday >= hacking_time)
		end_hacking()
	else
		if(hacking)
			if(hacking.circuit_board)
				if(prob(5 * (hacking.get_efficiency(1,1) * (1+detection*0.01) * speed * get_efficiency(2,1))))
					detection++
	return ..()

/obj/machinery/space_battle/hacking/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)
	if(!team)
		reconnect()
		if(!team)
			user << "<span class='warning'>No targets acquired!</span>"
			return 0
	var/list/data = list()
	var/list/hack = list()
	for(var/obj/machinery/M in hacked)
		hack.Add(M.name)
	data["hacked"] = hack
	var/list/categories = list()
	for(var/list/T in available_categories)
		var/list/category = T[1]
		categories.Add(category)
	data["categories"] = categories
	data["menu"] = menu
	data["team"] = team
	if(detection < 15)
		data["detection"] = 1
	else if(detection < 50)
		data["detection"] = 2
	else
		data["detection"] = 3
	if(hacking)
		data["hacking_name"] = hacking.name
	else if(selected)
		data["hacking_name"] = selected.name
	data["detection_lvl"] = detection
	data["speed"] = speed
	data["timeleft"] = time_remaining()
	data["can_cancel"] = can_cancel
	if(selected)
		data["selected_name"] = selected.name
		data["selected_actions"] = selected_action_types()

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "hacking.tmpl", "Hacking", 800, 500, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/space_battle/hacking/Topic(href, href_list)
	if(href_list["hacked"])
		if(menu != "progress")
			selected = null
			menu = "hacked"
	if(href_list["hacking"])
		if(menu != "progress")
			selected = null
			menu = "hacking"
	if(href_list["logs"])
		if(menu != "progress")
			selected = null
			menu = "logs"
	if(href_list["cancel"])
		hacking = null
		hacking_time = 0
		selected = null
		menu = "complete"
		operation = initial(operation)
		icon_state = initial(icon_state)
		can_cancel = initial(can_cancel)
	if(href_list["team"])
		var/index = target_teams.Find(team)
		index++
		if(index > target_teams.len)
			index = 1
		team = target_teams[index]
	if(href_list["speed"])
		if(speed == 3)
			speed = 1
		else
			speed++
	if(href_list["begin"])
		var/list/category_types = list()
		var/added_time = 0
		for(var/list/T in available_categories)
			if(T[1] == href_list["begin"])
				category_types = T[2]
				if(category_types)
					added_time = T[4]
				break
		if(!category_types)
			usr << "<span class='warning'>A problem has occured!</span>"
		else
//			usr << "DEBUG: Category Type \[[category_type]\]"
			var/list/targets = list()
			for(var/obj/machinery/M in world)
				if(is_type_in_list(M, category_types))
					if(!(M.stat & (NOPOWER|BROKEN|EMPED|MAINT)))
						var/area/ship_battle/S = get_area(M)
						var/mteam = (S && istype(S)) ? S.team : 0
//						usr << "DEBUG: Machine Team: \[[mteam]\] Set team: \[[team]\]"
						if(mteam == text2num(team))
//							usr << "DEBUG: Machine found: [M]"
							targets.Add(M)
			if(!targets.len)
				usr << "<span class='warning'>No targets are currently broadcasting!</span>"
			else
				var/obj/machinery/target = pick(targets)
				var/time = begin_hacking(target, added_time)
				usr << "<span class='notice'>Hacking begun on [target]! It will end in: [time] seconds!</span>"
	if(href_list["hacked_object"])
		selected = null
		for(var/obj/machinery/M in hacked)
			if("[M.name]" == href_list["hacked_object"])
				selected = M
		if(!selected)
			usr << "<span class='warning'>Something has gone wrong! You tried to select something we don't know about!</span>"
	if(href_list["action"])
		if(selected.stat & (BROKEN|NOPOWER|MAINT))
			usr << "<span class='warning'>\The [selected] is not responding!</span>"
			src.visible_message("<span class='warning'>\The [src] beeps, \"Remote connection to \the [selected] unavailable. Disconnecting...</span>")
			hacked.Cut(hacked.Find(selected),  (hacked.Find(selected)+1))
			selected = null
		else
			var/action_type
			var/time = 0
			var/list/category_actions
			for(var/list/T in available_categories)
				var/list/category_types = T[2]
				if(is_type_in_list(selected, category_types))
					category_actions = T[3]
			for(var/I in category_actions)
				if(I == href_list["action"])
					action_type = I
					time = category_actions[I]
			menu = "progress"
			switch(action_type)
				if(EMP)
					selected.emp_act(1)
				if(FRY_CIRCUIT)
					if(selected.circuit_board)
						for(var/i in selected.circuit_board.internal_wiring)
							if(prob(90))
								selected.circuit_board.internal_wiring[i] = pick(100;3, 50;4)
				if(SHATTER)
					if(istype(selected, /obj/machinery/light))
						var/obj/machinery/light/L = selected
						L.broken()
				if(UI_INTERACT)
					if(istype(selected, /obj/machinery/power/apc))
						var/obj/machinery/power/apc/A = selected
						A.hacked_by = usr
					selected.ui_interact(usr, state = interactive_state)
				if(UNLOCK)
					if(istype(selected, /obj/machinery/power/apc))
						var/obj/machinery/power/apc/apc = selected
						apc.locked = 0
						apc.visible_message("<span class='warning'>\The [apc] buzzes noisily!</span>")
					else if(istype(selected, /obj/machinery/alarm))
						var/obj/machinery/alarm/alarm = selected
						alarm.locked = 0
						alarm.visible_message("<span class='warning'>\The [alarm] buzzes noisily!</span>")
				if(ION)
					if(istype(selected, /obj/machinery/power/apc))
						var/obj/machinery/power/apc/A = selected
						A.ion_act()
			operation = action_type
			src.visible_message("<span class='notice'>\The [src] beeps, \"Running [action_type].exe on \the [selected]. Estimated time: [begin_hacking(null, time, 0)] seconds.\"</span>")
			if(prob(5 * (1+detection*0.1) * get_efficiency(0,1) * speed) || action_type == SHATTER)
				var/index = hacked.Find(selected)
				hacked.Cut(index, index+1)
				var/N = selected.name
				if(action_type != SHATTER)
					spawn(rand(25,80))
						src.visible_message("<span class='warning'>\The [src] beeps, \"Hack attempt detected by counter measures. Remote connection to \the [N] has been lost.\"</span>")
			selected = null
	src.add_fingerprint(usr)
	nanomanager.update_uis(src)

/obj/machinery/space_battle/hacking/proc/selected_action_types()
	if(!selected)
		return null
	var/list/to_return = list()
	var/list/category_actions
	for(var/list/T in available_categories)
		var/list/category_types = T[2]
		if(is_type_in_list(selected, category_types))
			category_actions = T[3]
	for(var/I in category_actions)
		to_return.Add(I)
	return to_return

/obj/machinery/space_battle/hacking/proc/time_remaining()
	var/time = (hacking_time - world.timeofday)/10
	if(time < 0)
		time = 0
	return round(time)

/obj/machinery/space_battle/hacking/proc/selected_data()
	if(!selected)
		return null
	var/list/data = list()
	data["buttons"] = selected_action_types()
	data["name"] = selected.name
	return data

/obj/machinery/space_battle/hacking/proc/begin_hacking(var/obj/machinery/target, var/added_time = 0, var/cancelable = 1)
	var/time = added_time
	can_cancel = cancelable
	if(target)
		operation = pick("regedit.exe", "BIOS.exe", "syswow.exe")
		hacking = target
		var/mod = 1
		if(target.circuit_board)
			mod = target.get_efficiency(2, 1) ** 3
		else
			mod = 0.2 // 20% time to hack.
		time = min(1200, max(0, (added_time ? added_time + BASE_HACKING_TIME : BASE_HACKING_TIME - added_time) * mod * (1+detection*0.1)))
	time /= speed
	hacking_time = world.timeofday + time*10
	menu = "progress"
	icon_state = "recalibrated"
	return time


/obj/machinery/space_battle/hacking/proc/end_hacking()
	hacking_time = 0
	if(hacking)
		hacked.Add(hacking)
		hacking = null
	menu = "complete"
	src.visible_message("<span class='notice'>\The [src] beeps, \"Hacking attempt successful.\"</span>")
	icon_state = initial(icon_state)
	operation = initial(operation)
	can_cancel = initial(can_cancel)
	return

