/obj/machinery/computer/shuttle_control/multi
	ui_template = "shuttle_control_console_multi.tmpl"
	can_use_tools = FALSE

/obj/machinery/computer/shuttle_control/multi/get_ui_data(var/datum/shuttle/autodock/multi/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"destination_name" = shuttle.next_location? shuttle.next_location.name : "No destination set.",
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
		)

/obj/machinery/computer/shuttle_control/multi/handle_topic_href(var/datum/shuttle/autodock/multi/shuttle, var/list/href_list)
	if((. = ..()) != null)
		return

	if(href_list["pick"])
		var/dest_key = input("Choose shuttle destination", "Shuttle Destination") as null|anything in shuttle.get_destinations()
		if(dest_key && CanInteract(usr, GLOB.default_state))
			shuttle.set_destination(dest_key, usr)
		return TOPIC_REFRESH


/obj/machinery/computer/shuttle_control/multi/antag
	ui_template = "shuttle_control_console_antag.tmpl"

/obj/machinery/computer/shuttle_control/multi/antag/get_ui_data(var/datum/shuttle/autodock/multi/antag/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"cloaked" = shuttle.cloaked,
		)

/obj/machinery/computer/shuttle_control/multi/antag/handle_topic_href(var/datum/shuttle/autodock/multi/antag/shuttle, var/list/href_list)
	if((. = ..()) != null)
		return

	if(href_list["toggle_cloaked"])
		shuttle.cloaked = !shuttle.cloaked
		return TOPIC_REFRESH
