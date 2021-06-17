LEGACY_RECORD_STRUCTURE(all_waypoints, waypoint)

/obj/machinery/computer/ship/helm
	name = "helm control console"
	icon_keyboard = "teleport_key"
	icon_screen = "helm"
	light_color = "#7faaff"
	core_skill = SKILL_PILOT
	silicon_restriction = STATUS_UPDATE
	machine_name = "helm control console"
	machine_desc = "A navigation system used to control spacecraft big and small, allowing for configuration of heading and autopilot as well as providing navigational data."
	var/autopilot = 0
	var/list/known_sectors = list()
	var/dx		//desitnation
	var/dy		//coordinates
	var/speedlimit = 1/(20 SECONDS) //top speed for autopilot, 5
	var/accellimit = 0.001 //manual limiter for acceleration
	/// The mob currently operating the helm - The last one to click one of the movement buttons and be on the overmap screen. Set to `null` for autopilot or when the mob isn't in range.
	var/mob/current_operator

/obj/machinery/computer/ship/helm/Initialize()
	. = ..()
	get_known_sectors()

/obj/machinery/computer/ship/helm/proc/get_known_sectors()
	var/area/overmap/map = locate() in world
	for(var/obj/effect/overmap/visitable/sector/S in map)
		if (S.known)
			add_known_sector(S)

/obj/machinery/computer/ship/helm/proc/add_known_sector(obj/effect/overmap/visitable/sector/S, notify = FALSE)
	var/datum/computer_file/data/waypoint/R = new()
	R.fields["name"] = S.name
	R.fields["x"] = S.x
	R.fields["y"] = S.y
	known_sectors[S.name] = R

	if (notify)
		audible_message(SPAN_NOTICE("\The [src] pings with a new known sector: [S] at coordinates [S.x] by [S.y]."))

/obj/machinery/computer/ship/helm/Process()
	..()

	if (current_operator)
		if (!linked)
			to_chat(current_operator, SPAN_DANGER("\The [src]'s controls lock up with an error flashing across the screen: Connection to vessel lost!"))
			set_operator(null, TRUE)
		else if (!Adjacent(current_operator) || CanUseTopic(current_operator) != STATUS_INTERACTIVE || !viewing_overmap(current_operator))
			set_operator(null)

	if (autopilot && dx && dy)
		var/turf/T = locate(dx,dy,GLOB.using_map.overmap_z)
		if(linked.loc == T)
			if(linked.is_still())
				autopilot = 0
			else
				linked.decelerate(accellimit)
		else
			var/brake_path = linked.get_brake_path() / HALF_UNIT_DIAGONAL //get_dist is steps, not hypotenuse
			var/direction = get_dir(linked.loc, T)
			var/acceleration = min(linked.get_acceleration(), accellimit)
			var/speed = linked.get_speed()
			var/heading = linked.get_heading()

			// Destination is current grid or speedlimit is exceeded
			if ((get_dist(linked.loc, T) <= brake_path) || speed > speedlimit)
				linked.decelerate(accellimit)
			// Heading does not match direction
			else if (heading & ~direction)
				linked.accelerate(turn(heading & ~direction, 180), accellimit)
			// All other cases, move toward direction
			else if (speed + acceleration <= speedlimit)
				linked.accelerate(direction, accellimit)

		if (current_operator)
			to_chat(current_operator, SPAN_DANGER("\The [src]'s autopilot is active and wrests control from you!"))
			set_operator(null, TRUE, TRUE)

		return

/obj/machinery/computer/ship/helm/relaymove(var/mob/user, direction)
	if(viewing_overmap(user) && linked)
		if(prob(user.skill_fail_chance(SKILL_PILOT, 50, linked.skill_needed, factor = 1)))
			direction = turn(direction,pick(90,-90))
		linked.relaymove(user, direction, accellimit)
		set_operator(user)
		return 1

/obj/machinery/computer/ship/helm/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	if(!linked)
		display_reconnect_dialog(user, "helm")
	else
		var/turf/T = get_turf(linked)
		var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

		var/mob/living/silicon/silicon = user
		data["viewing_silicon"] = ismachinerestricted(silicon)

		data["sector"] = current_sector ? current_sector.name : "Deep Space"
		data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
		data["landed"] = linked.get_landed_info()
		data["s_x"] = linked.x
		data["s_y"] = linked.y
		data["dest"] = dy && dx
		data["d_x"] = dx
		data["d_y"] = dy
		data["speedlimit"] = speedlimit ? speedlimit*1000 : "Halted"
		data["accel"] = min(round(linked.get_acceleration()*1000, 0.01),accellimit*1000)
		data["heading"] = linked.get_heading_angle() ? linked.get_heading_angle() : 0
		data["autopilot"] = autopilot
		data["manual_control"] = viewing_overmap(user)
		data["canburn"] = linked.can_burn()
		data["accellimit"] = accellimit*1000

		var/speed = round(linked.get_speed()*1000, 0.01)
		if(linked.get_speed() < SHIP_SPEED_SLOW)
			speed = "<span class='good'>[speed]</span>"
		if(linked.get_speed() > SHIP_SPEED_FAST)
			speed = "<span class='average'>[speed]</span>"
		data["speed"] = speed

		if(linked.get_speed())
			data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
		else
			data["ETAnext"] = "N/A"

		var/list/locations[0]
		for (var/key in known_sectors)
			var/datum/computer_file/data/waypoint/R = known_sectors[key]
			var/list/rdata[0]
			rdata["name"] = R.fields["name"]
			rdata["x"] = R.fields["x"]
			rdata["y"] = R.fields["y"]
			rdata["reference"] = "\ref[R]"
			locations.Add(list(rdata))

		data["locations"] = locations

		ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
		if (!ui)
			ui = new(user, src, ui_key, "helm.tmpl", "[linked.name] Helm Control", 565, 545)
			ui.set_initial_data(data)
			ui.open()
			ui.set_auto_update(1)

/obj/machinery/computer/ship/helm/OnTopic(var/mob/user, var/list/href_list, state)
	if(..())
		return TOPIC_HANDLED

	if(!linked)
		return TOPIC_HANDLED

	if (href_list["add"])
		var/datum/computer_file/data/waypoint/R = new()
		var/sec_name = input("Input naviation entry name", "New navigation entry", "Sector #[known_sectors.len]") as text
		if(!CanInteract(user,state))
			return TOPIC_NOACTION
		if(!sec_name)
			sec_name = "Sector #[known_sectors.len]"
		R.fields["name"] = sec_name
		if(sec_name in known_sectors)
			to_chat(user, "<span class='warning'>Sector with that name already exists, please input a different name.</span>")
			return TOPIC_REFRESH
		switch(href_list["add"])
			if("current")
				R.fields["x"] = linked.x
				R.fields["y"] = linked.y
			if("new")
				var/newx = input("Input new entry x coordinate", "Coordinate input", linked.x) as num
				if(!CanInteract(user,state))
					return TOPIC_REFRESH
				var/newy = input("Input new entry y coordinate", "Coordinate input", linked.y) as num
				if(!CanInteract(user,state))
					return TOPIC_NOACTION
				R.fields["x"] = Clamp(newx, 1, world.maxx)
				R.fields["y"] = Clamp(newy, 1, world.maxy)
		known_sectors[sec_name] = R

	if (href_list["remove"])
		var/datum/computer_file/data/waypoint/R = locate(href_list["remove"])
		if(R)
			known_sectors.Remove(R.fields["name"])
			qdel(R)

	if (href_list["setx"])
		var/newx = input("Input new destiniation x coordinate", "Coordinate input", dx) as num|null
		if(!CanInteract(user,state))
			return
		if (newx)
			dx = Clamp(newx, 1, world.maxx)

	if (href_list["sety"])
		var/newy = input("Input new destiniation y coordinate", "Coordinate input", dy) as num|null
		if(!CanInteract(user,state))
			return
		if (newy)
			dy = Clamp(newy, 1, world.maxy)

	if (href_list["x"] && href_list["y"])
		dx = text2num(href_list["x"])
		dy = text2num(href_list["y"])

	if (href_list["reset"])
		dx = 0
		dy = 0

	if (href_list["speedlimit"])
		var/newlimit = input("Autopilot Speed Limit (0 ~ [round(linked.max_autopilot * 1000, 0.1)])", "Autopilot speed limit", speedlimit * 1000) as num|null
		if (!isnull(newlimit))
			speedlimit = round(Clamp(newlimit, 0, linked.max_autopilot * 1000), 0.1) * 0.001

	if (href_list["accellimit"])
		var/newlimit = input("Input new acceleration limit (0 ~ 10)", "Acceleration limit", accellimit * 1000) as num|null
		if (!isnull(newlimit))
			accellimit = round(Clamp(newlimit, 0, 10)) * 0.001

	if (href_list["move"])
		var/ndir = text2num(href_list["move"])
		if(prob(user.skill_fail_chance(SKILL_PILOT, 50, linked.skill_needed, factor = 1)))
			ndir = turn(ndir,pick(90,-90))
		linked.relaymove(user, ndir, accellimit)

	if (href_list["brake"])
		linked.decelerate(accellimit)

	if (href_list["apilot"])
		autopilot = !autopilot
		if (autopilot)
			set_operator(null, autopilot = TRUE)
		else if (viewing_overmap(user))
			set_operator(user)

	if (href_list["manual"])
		viewing_overmap(user) ? unlook(user) : look(user)

	add_fingerprint(user)
	updateUsrDialog()


/obj/machinery/computer/ship/helm/unlook(mob/user)
	. = ..()
	if (current_operator == user)
		set_operator(null)


/obj/machinery/computer/ship/helm/look(mob/user)
	. = ..()
	if (!autopilot)
		set_operator(user)


/**
 * Updates `current_operator` to the new user, or `null` and ejects the old operator from the overmap view - Only one person on a helm at a time!
 * Will call `display_operator_change_message()` if `silent` is `FALSE`.
 * `autopilot` will prevent ejection from the overmap (You want to monitor your autopilot right?) and by passed on to `display_operator_change_message()`.
 * Skips ghosts and observers to prevent accidental external influencing of flight.
 */
/obj/machinery/computer/ship/helm/proc/set_operator(mob/user, silent, autopilot)
	if (isobserver(user) || user == current_operator)
		return

	var/mob/old_operator = current_operator
	current_operator = user
	linked.update_operator_skill(current_operator)
	if (!autopilot && old_operator && viewing_overmap(old_operator))
		unlook(old_operator)

	if (!silent)
		display_operator_change_message(old_operator, current_operator, autopilot)


/**
 * Displays visible messages indicating a change in operator.
 * `autopilot` will affect the displayed message.
 */
/obj/machinery/computer/ship/helm/proc/display_operator_change_message(mob/old_operator, mob/new_operator, autopilot)
	if (!old_operator)
		new_operator.visible_message(
			SPAN_NOTICE("\The [new_operator] takes \the [src]'s controls."),
			SPAN_NOTICE("You take \the [src]'s controls.")
		)
	else if (!new_operator)
		if (autopilot)
			old_operator.visible_message(
				SPAN_NOTICE("\The [old_operator] engages \the [src]'s autopilot and releases the controls."),
				SPAN_NOTICE("You engage \the [src]'s autopilot and release the controls.")
			)
		else
			old_operator.visible_message(
				SPAN_WARNING("\The [old_operator] releases \the [src]'s controls."),
				SPAN_WARNING("You release \the [src]'s controls.")
			)
	else
		old_operator.visible_message(
			SPAN_WARNING("\The [new_operator] takes \the [src]'s controls from \the [old_operator]."),
			SPAN_DANGER("\The [new_operator] takes \the [src]'s controls from you!")
		)


/obj/machinery/computer/ship/navigation
	name = "navigation console"
	icon_keyboard = "generic_key"
	icon_screen = "helm"
	silicon_restriction = STATUS_UPDATE
	machine_name = "navigation console"
	machine_desc = "Used to view a sensor-assisted readout of the current sector and its surrounding areas."

/obj/machinery/computer/ship/navigation/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!linked)
		display_reconnect_dialog(user, "Navigation")
		return

	var/data[0]


	var/turf/T = get_turf(linked)
	var/obj/effect/overmap/visitable/sector/current_sector = locate() in T

	var/mob/living/silicon/silicon = user
	data["viewing_silicon"] = ismachinerestricted(silicon)

	data["sector"] = current_sector ? current_sector.name : "Deep Space"
	data["sector_info"] = current_sector ? current_sector.desc : "Not Available"
	data["s_x"] = linked.x
	data["s_y"] = linked.y
	data["speed"] = round(linked.get_speed()*1000, 0.01)
	data["accel"] = round(linked.get_acceleration()*1000, 0.01)
	data["heading"] = linked.get_heading_angle() ? linked.get_heading_angle() : 0
	data["viewing"] = viewing_overmap(user)

	if(linked.get_speed())
		data["ETAnext"] = "[round(linked.ETA()/10)] seconds"
	else
		data["ETAnext"] = "N/A"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "nav.tmpl", "[linked.name] Navigation Screen", 380, 530)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/ship/navigation/OnTopic(var/mob/user, var/list/href_list)
	if(..())
		return TOPIC_HANDLED

	if (!linked)
		return TOPIC_NOACTION

	if (href_list["viewing"])
		viewing_overmap(user) ? unlook(user) : look(user)
		return TOPIC_REFRESH

/obj/machinery/computer/ship/navigation/telescreen	//little hacky but it's only used on one ship so it should be okay
	icon_state = "tele_nav"
	density = FALSE
	machine_name = "navigation telescreen"
	machine_desc = "A compact, slimmed-down version of the navigation console."

/obj/machinery/computer/ship/navigation/telescreen/on_update_icon()
	if(reason_broken & MACHINE_BROKEN_NO_PARTS || stat & NOPOWER || stat & BROKEN)
		icon_state = "tele_off"
		set_light(0)
	else
		icon_state = "tele_nav"
		set_light(light_max_bright_on, light_inner_range_on, light_outer_range_on, 2, light_color)
