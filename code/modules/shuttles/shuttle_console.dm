/obj/machinery/computer/shuttle_control
	name = "shuttle control console"
	icon = 'icons/obj/computer.dmi'
	icon_keyboard = "atmos_key"
	icon_screen = "shuttle"
	circuit = null

	var/shuttle_tag  // Used to coordinate data in shuttle controller.
	var/hacked = 0   // Has been emagged, no access restrictions.


/obj/machinery/computer/shuttle_control/attack_hand(user as mob)
	if(..(user))
		return
	//src.add_fingerprint(user)	//shouldn't need fingerprints just for looking at it.
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access Denied.</span>")
		return 1

	ui_interact(user)

/obj/machinery/computer/shuttle_control/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/shuttle/autodock/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		return

	var/shuttle_state
	switch(shuttle.moving_status)
		if(SHUTTLE_IDLE) shuttle_state = "idle"
		if(SHUTTLE_WARMUP) shuttle_state = "warmup"
		if(SHUTTLE_INTRANSIT) shuttle_state = "in_transit"

	var/shuttle_status
	switch (shuttle.process_state)
		if(IDLE_STATE)
			if (shuttle.in_use)
				shuttle_status = "Busy."
			else
				var/datum/shuttle_waypoint/cur_waypoint = shuttle.get_location_waypoint()
				shuttle_status = "Standing-by at [cur_waypoint.name]."

		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to [shuttle.next_waypoint.name]."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	data = list(
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = shuttle.active_docking_controller? 1 : 0,
		"docking_status" = shuttle.active_docking_controller? shuttle.active_docking_controller.get_docking_status() : null,
		"docking_override" = shuttle.active_docking_controller? shuttle.active_docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force(),
	)

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "shuttle_control_console.tmpl", "[shuttle_tag] Shuttle Control", 470, 310)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/Topic(href, href_list)
	if(..())
		return 1

	usr.set_machine(src)
	src.add_fingerprint(usr)

	var/datum/shuttle/autodock/ferry/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		return

	if(href_list["move"])
		shuttle.launch(src)
	if(href_list["force"])
		shuttle.force_launch(src)
	else if(href_list["cancel"])
		shuttle.cancel_launch(src)

/obj/machinery/computer/shuttle_control/emag_act(var/remaining_charges, var/mob/user)
	if (!hacked)
		req_access = list()
		req_one_access = list()
		hacked = 1
		to_chat(user, "You short out the console's ID checking system. It's now available to everyone!")
		return 1

/obj/machinery/computer/shuttle_control/bullet_act(var/obj/item/projectile/Proj)
	visible_message("\The [Proj] ricochets off \the [src]!")

/obj/machinery/computer/shuttle_control/ex_act()
	return

/obj/machinery/computer/shuttle_control/emp_act()
	return
