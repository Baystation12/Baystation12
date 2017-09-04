//Shuttle controller computer for shuttles going between sectors
/obj/machinery/computer/shuttle_control/explore
	name = "general shuttle control console"

/obj/machinery/computer/shuttle_control/explore/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]
	var/datum/shuttle/autodock/overmap/shuttle = shuttle_controller.shuttles[shuttle_tag]
	if (!istype(shuttle))
		to_chat(usr,"<span class='warning'>Unable to establish link with the shuttle.</span>")
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
				shuttle_status = "Standing-by at [shuttle.get_location_name()]."
		if(WAIT_LAUNCH, FORCE_LAUNCH)
			shuttle_status = "Shuttle has recieved command and will depart shortly."
		if(WAIT_ARRIVE)
			shuttle_status = "Proceeding to [shuttle.get_destination_name()]."
		if(WAIT_FINISH)
			shuttle_status = "Arriving at destination now."

	var/datum/computer/file/embedded_program/docking/docking_controller = shuttle.active_docking_controller

	data = list(
		"destination_name" = shuttle.get_destination_name(),
		"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
		"shuttle_status" = shuttle_status,
		"shuttle_state" = shuttle_state,
		"has_docking" = docking_controller? 1 : 0,
		"docking_status" = docking_controller? docking_controller.get_docking_status() : null,
		"docking_override" = docking_controller? docking_controller.override_enabled : null,
		"can_launch" = shuttle.can_launch(),
		"can_cancel" = shuttle.can_cancel(),
		"can_force" = shuttle.can_force(),
	)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)

	if (!ui)
		ui = new(user, src, ui_key, "shuttle_control_console_exploration.tmpl", "[shuttle_tag] Shuttle Control", 470, 310)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/computer/shuttle_control/explore/get_ui_data(var/datum/shuttle/autodock/overmap/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"destination_name" = shuttle.get_destination_name(),
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
		)

/obj/machinery/computer/shuttle_control/explore/handle_topic_href(var/datum/shuttle/autodock/overmap/shuttle, var/list/href_list)
	if(..())
		return 1

	if(href_list["pick"])
		var/list/possible_d = shuttle.get_possible_destinations()
		var/D
		if(possible_d.len)
			D = input("Choose shuttle destination", "Shuttle Destination") as null|anything in possible_d
		else
			to_chat(usr,"<span class='warning'>No valid landing sites in range.</span>")
		possible_d = shuttle.get_possible_destinations()
		if(CanInteract(usr, GLOB.default_state) && (D in possible_d))
			shuttle.set_destination(possible_d[D])
