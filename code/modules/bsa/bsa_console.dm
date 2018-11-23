//Amazing BSA from Bxil(tm). Some icons, sounds, and some code shamelessly stolen from ParadiseSS13.

/obj/machinery/computer/ship/bsa
	name = "bluespace artillery control"
	icon = 'icons/obj/computer.dmi'
	icon_state = "computer"
	circuit = /obj/item/weapon/circuitboard/bsa

	core_skill = SKILL_PILOT
	var/skill_offset = SKILL_ADEPT - 1 //After which skill level it starts to matter. -1, because we have to index from zero

	icon_keyboard = "rd_key"
	icon_screen = "teleport"

	var/obj/machinery/bsa/front/front
	var/obj/machinery/bsa/middle/middle
	var/obj/machinery/bsa/back/back
	var/const/link_range = 10 //How far can the above stuff be maximum before we start complaining

	var/overmapdir = 0

	var/caldigit = 4 //number of digits that needs calibration
	var/list/calibration //what it is
	var/list/calexpected //what is should be

	var/range = 1 //range of the explosion
	var/strength = 1 //strength of the explosion
	var/next_shot = 0 //round time where the next shot can start from
	var/const/coolinterval = 2 MINUTES //time to wait between safe shots in deciseconds

/obj/machinery/computer/ship/bsa/Initialize()
	. = ..()
	link_parts()
	reset_calibration()

/obj/machinery/computer/ship/bsa/Destroy()
	release_links()
	. = ..()

/obj/machinery/computer/ship/bsa/proc/link_parts()
	if(is_valid_setup())
		return TRUE

	for(var/obj/machinery/bsa/front/F in SSmachines.machinery)
		if(get_dist(src, F) >= link_range)
			continue
		var/backwards = turn(F.dir, 180)
		var/obj/machinery/bsa/middle/M = locate() in get_step(F, backwards)
		if(!M || get_dist(src, M) >= link_range)
			continue
		var/obj/machinery/bsa/back/B = locate() in get_step(M, backwards)
		if(!B || get_dist(src, B) >= link_range)
			continue
		front = F
		middle = M
		back = B
		if(is_valid_setup())
			GLOB.destroyed_event.register(F, src, .proc/release_links)
			GLOB.destroyed_event.register(M, src, .proc/release_links)
			GLOB.destroyed_event.register(B, src, .proc/release_links)
			return TRUE
	return FALSE

obj/machinery/computer/ship/bsa/proc/is_valid_setup()
	if(front && middle && back)
		var/everything_in_range = (get_dist(src, front) < link_range) && (get_dist(src, middle) < link_range) && (get_dist(src, back) < link_range)
		var/everything_in_order = (middle.Adjacent(front) && middle.Adjacent(back)) && (front.dir == middle.dir && middle.dir == back.dir)
		return everything_in_order && everything_in_range
	return FALSE

/obj/machinery/computer/ship/bsa/proc/release_links()
	GLOB.destroyed_event.unregister(front, src, .proc/release_links)
	GLOB.destroyed_event.unregister(middle, src, .proc/release_links)
	GLOB.destroyed_event.unregister(back, src, .proc/release_links)
	front = null
	middle = null
	back = null

/obj/machinery/computer/ship/bsa/proc/get_calbiration()
	var/list/calresult[caldigit]
	for(var/i = 1 to caldigit)
		if(calibration[i] == calexpected[i])
			calresult[i] = 2
		else if(calibration[i] in calexpected)
			calresult[i] = 1
		else
			calresult[i] = 0
	return calresult

/obj/machinery/computer/ship/bsa/proc/reset_calibration()
	calexpected = new /list(caldigit)
	calibration = new /list(caldigit)
	for(var/i = 1 to caldigit)
		calexpected[i] = rand(0,9)
		calibration[i] = 0

/obj/machinery/computer/ship/bsa/proc/cal_accuracy()
	var/top = 0
	var/divisor = caldigit * 2 //maximum possible value, aka 100% accuracy
	for(var/i in get_calbiration())
		top += i
	return round(top * 100 / divisor)

/obj/machinery/computer/ship/bsa/proc/get_next_shot_seconds()
	return max(0, (next_shot - world.time) / 10)

/obj/machinery/computer/ship/bsa/proc/cool_failchance()
	return get_next_shot_seconds() * 1000 / coolinterval

/obj/machinery/computer/ship/bsa/proc/get_charge_type()
	var/obj/structure/ship_munition/bsa_charge/B = locate() in get_turf(back)
	if(B)
		return B.chargetype

	var/obj/structure/closet/C = locate() in get_turf(back)
	if(C)
		return BSA_DROPPOD
	return BSA_NOCHARGE

/obj/machinery/computer/ship/bsa/proc/get_charge()
	var/obj/structure/ship_munition/bsa_charge/B = locate() in get_turf(back)
	if(B)
		return B

	var/obj/structure/closet/C = locate() in get_turf(back)
	return C

/obj/machinery/computer/ship/bsa/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	if(!linked)
		display_reconnect_dialog(user, "BSA mark VI. synchronization")
		return

	var/data[0]

	if (!link_parts())
		data["faillink"] = TRUE
	else
		data["calibration"] = calibration
		data["overmapdir"] = overmapdir
		data["cal_accuracy"] = cal_accuracy()
		data["strength"] = strength
		data["range"] = range
		data["next_shot"] = round(get_next_shot_seconds())
		data["nopower"] = !data["faillink"] && (!front.powered() || !middle.powered() || !back.powered())
		data["skill"] = user.get_skill_value(core_skill) > skill_offset

		var/charge = "<b>UNKNOWN ERROR</b>"
		switch(get_charge_type())
			if(BSA_NOCHARGE)
				charge = "<b>ERROR</b>: No valid charge detected."
			if(BSA_DROPPOD)
				charge = "HERMES"
			else
				var/obj/structure/ship_munition/bsa_charge/B = get_charge()
				charge = B.chargedesc
		data["chargeload"] = charge

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "bsa.tmpl", "[linked.name] BSA Control", 400, 550)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/bsa/OnTopic(mob/user, list/href_list, state)
	. = ..()
	if(.)
		return

	if(!linked)
		return TOPIC_HANDLED

	if (href_list["choose"])
		overmapdir = sanitize_integer(text2num(href_list["choose"]), 0, 9, 0)
		reset_calibration()

	if(href_list["calibration"])
		var/input = input("0-9", "BSA calibration", 0) as num|null
		if(!isnull(input)) //can be zero so we explicitly check for null
			var/calnum = sanitize_integer(text2num(href_list["calibration"]), 0, caldigit)//sanitiiiiize
			calibration[calnum + 1] = sanitize_integer(input, 0, 9, 0)//must add 1 because nanoui indexes from 0

	if(href_list["skill_calibration"])
		for(var/i = 1 to min(caldigit, user.get_skill_value(core_skill) - skill_offset))
			calibration[i] = calexpected[i]

	if(href_list["strength"])
		var/input = input("1-5", "BSA strength", 1) as num|null
		if(input && CanInteract(user, state))
			strength = sanitize_integer(input, 1, 5, 1)
			middle.idle_power_usage = strength * range * 100

	if(href_list["range"])
		var/input = input("1-5", "BSA radius", 1) as num|null
		if(input && CanInteract(user, state))
			range = sanitize_integer(input, 1, 5, 1)
			middle.idle_power_usage = strength * range * 100

	if(href_list["fire"])
		fire(user)

	return TOPIC_REFRESH