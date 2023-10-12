/obj/machinery/computer/ship/disperser
	name = "obstruction field disperser control"
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"

	core_skill = SKILL_PILOT
	/// After which skill level it starts to matter. -1, because we have to index from zero
	var/skill_offset = SKILL_TRAINED - 1

	icon_keyboard = "rd_key"
	icon_screen = "teleport"

	var/obj/machinery/disperser/front/front
	var/obj/machinery/disperser/middle/middle
	var/obj/machinery/disperser/back/back
	/// How far can the disperser's front/mid/back sections be apart from eachother before we start complaining
	var/const/link_range = 10

	var/overmapdir = 0
	/// Coordinates for target
	var/tx = 0
	var/ty = 0
	var/tz = 0

	var/accuracy = 0

	/// What it is
	var/list/calibration
	/// what is should be
	var/list/calexpected

	/// Range of the explosion
	var/range = 1
	/// Strength of the explosion
	var/strength = 1
	/// Round time where the next shot can start from
	var/next_shot = 0
	/// Time to wait between safe shots in deciseconds
	var/const/coolinterval = 2 MINUTES

	var/const/cal_count = 4

/obj/machinery/computer/ship/disperser/Initialize()
	. = ..()
	link_parts()
	reset_calibration()

/obj/machinery/computer/ship/disperser/Destroy()
	release_links()
	. = ..()

/**
 * Used to handle linking of OFD parts.
 * If the parts are too far apart from eachother, it won't work.
 */
/obj/machinery/computer/ship/disperser/proc/link_parts()
	if(is_valid_setup())
		return TRUE

	for(var/obj/machinery/disperser/front/F in SSmachines.machinery)
		if(get_dist(src, F) >= link_range)
			continue
		var/backwards = turn(F.dir, 180)
		var/obj/machinery/disperser/middle/M = locate() in get_step(F, backwards)
		if(!M || get_dist(src, M) >= link_range)
			continue
		var/obj/machinery/disperser/back/B = locate() in get_step(M, backwards)
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

/**
 * Checks order of parts.
 */
/obj/machinery/computer/ship/disperser/proc/is_valid_setup()
	if(front && middle && back)
		var/everything_in_range = (get_dist(src, front) < link_range) && (get_dist(src, middle) < link_range) && (get_dist(src, back) < link_range)
		var/everything_in_order = (middle.Adjacent(front) && middle.Adjacent(back)) && (front.dir == middle.dir && middle.dir == back.dir)
		return everything_in_order && everything_in_range
	return FALSE

/**
 * Used for destroying links when unlinked.
 */
/obj/machinery/computer/ship/disperser/proc/release_links()
	GLOB.destroyed_event.unregister(front, src, .proc/release_links)
	GLOB.destroyed_event.unregister(middle, src, .proc/release_links)
	GLOB.destroyed_event.unregister(back, src, .proc/release_links)
	front = null
	middle = null
	back = null

/**
 * Calculating calibration.
 */
/obj/machinery/computer/ship/disperser/proc/get_calibration()
	var/list/calresult = new(cal_count)
	for(var/i = 1 to cal_count)
		if(calibration[i] == calexpected[i])
			calresult[i] = 2
		else if(calibration[i] in calexpected)
			calresult[i] = 1
		else
			calresult[i] = 0
	return calresult

/**
 * Resetting calibration.
 */
/obj/machinery/computer/ship/disperser/proc/reset_calibration()
	calexpected = new(cal_count)
	calibration = new(cal_count)
	for(var/i = 1 to cal_count)
		calexpected[i] = rand(0, 9)
		calibration[i] = 0

/**
 * Calculating accuracy from calibration.
 */
/obj/machinery/computer/ship/disperser/proc/cal_accuracy()
	var/top = 0
	// Maximum possible value, aka 100% accuracy
	var/divisor = cal_count * 2
	for(var/i in get_calibration())
		top += i
	accuracy = round(top * 100 / divisor)
	return round(top * 100 / divisor)

/obj/machinery/computer/ship/disperser/proc/get_next_shot_seconds()
	return max(0, (next_shot - world.time) / 10)

/obj/machinery/computer/ship/disperser/proc/cool_failchance()
	return get_next_shot_seconds() * 1000 / coolinterval

/obj/machinery/computer/ship/disperser/proc/get_charge_type()
	var/obj/structure/ship_munition/disperser_charge/B = locate() in get_turf(back)
	if(B)
		return B.chargetype
	var/obj/structure/closet/C = locate() in get_turf(back)
	if(C)
		return OVERMAP_WEAKNESS_DROPPOD
	return OVERMAP_WEAKNESS_NONE

/obj/machinery/computer/ship/disperser/proc/get_charge()
	var/obj/structure/ship_munition/disperser_charge/B = locate() in get_turf(back)
	if(B)
		return B

	var/obj/structure/closet/C = locate() in get_turf(back)
	return C

/obj/machinery/computer/ship/disperser/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = TRUE)
	if(!linked)
		display_reconnect_dialog(user, "disperser synchronization")
		return

	var/data[0]

	if (!link_parts())
		data["faillink"] = TRUE
	else
		data["calibration"] = calibration
		data["overmapdir"] = overmapdir
		data["t_x"] = tx
		data["t_y"] = ty
		data["t_z"] = tz
		data["coordinates"] = tx || ty || tz
		data["cal_accuracy"] = cal_accuracy()
		data["strength"] = strength
		data["range"] = range
		data["next_shot"] = round(get_next_shot_seconds())
		data["nopower"] = !data["faillink"] && (!front.powered() || !middle.powered() || !back.powered())
		data["skill"] = user.get_skill_value(core_skill) > skill_offset

		var/charge = SPAN_BOLD("UNKNOWN ERROR")
		switch(get_charge_type())
			if(OVERMAP_WEAKNESS_NONE)
				charge = "[SPAN_BOLD("ERROR")]: No valid charge detected."
			if(OVERMAP_WEAKNESS_DROPPOD)
				charge = "HERMES"
			else
				var/obj/structure/ship_munition/disperser_charge/B = get_charge()
				charge = B.chargedesc
		data["chargeload"] = charge

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "disperser.tmpl", "[linked.name] obstruction field disperser control", 400, 550)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/disperser/OnTopic(mob/user, list/href_list, state)
	. = ..()
	if(.)
		return

	if(!linked)
		return TOPIC_HANDLED

	if (href_list["choose"])
		overmapdir = sanitize_integer(text2num(href_list["choose"]), 0, 9, 0)
		reset_calibration()

	if (href_list["setx"])
		var/newx = input("Input new target x coordinate", "Coordinate input", tx) as num|null
		if(!CanInteract(user,state))
			return
		if (newx)
			tx = clamp(newx, 1, world.maxx - TRANSITIONEDGE)

	if (href_list["sety"])
		var/newy = input("Input new target y coordinate", "Coordinate input", ty) as num|null
		if(!CanInteract(user,state))
			return
		if (newy)
			ty = clamp(newy, 1, world.maxy - TRANSITIONEDGE)

	if (href_list["setz"])
		var/newz = input("Input new target z coordinate", "Coordinate input", tz) as num|null
		if(!CanInteract(user,state))
			return
		if (newz)
			tz = clamp(newz, 1, world.maxz)

	if (href_list["reset"])
		tx = 0
		ty = 0
		tz = 0

	if(href_list["calibration"])
		var/input = input("0-9", "disperser calibration", 0) as num|null
		if(!isnull(input))
			var/calnum = sanitize_integer(text2num(href_list["calibration"]), 0, cal_count - 1)
			calibration[calnum + 1] = sanitize_integer(input, 0, 9, 0)

	if(href_list["skill_calibration"])
		for(var/i = 1 to clamp(user.get_skill_value(core_skill) - skill_offset, 1, cal_count))
			calibration[i] = calexpected[i]

	if(href_list["strength"])
		var/input = input("1-5", "disperser strength", 1) as num|null
		if(input && CanInteract(user, state))
			strength = sanitize_integer(input, 1, 5, 1)
			middle.idle_power_usage = strength * range * 100

	if(href_list["range"])
		var/input = input("1-5", "disperser radius", 1) as num|null
		if(input && CanInteract(user, state))
			range = sanitize_integer(input, 1, 5, 1)
			middle.idle_power_usage = strength * range * 100

	if(href_list["fire"])
		fire(user)

	return TOPIC_REFRESH
