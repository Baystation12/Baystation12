/obj/machinery/computer/shuttle_control/multi_shuttle
	ui_template = "shuttle_control_console_multi.tmpl"

/obj/machinery/computer/shuttle_control/multi_shuttle/get_ui_data(var/datum/shuttle/autodock/multi/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"destination_name" = shuttle.next_location? shuttle.next_location.name : "No destination set.",
			"can_pick" = shuttle.moving_status == SHUTTLE_IDLE,
		)

/obj/machinery/computer/shuttle_control/multi_shuttle/handle_topic_href(var/datum/shuttle/autodock/multi/shuttle, var/list/href_list)
	..()

	if(!istype(shuttle))
		return

	if(href_list["pick"])
		var/dest_key = input("Choose shuttle destination", "Shuttle Destination") as null|anything in shuttle.destinations
		if(CanInteract(usr, default_state))
			shuttle.set_destination(dest_key, usr)


/obj/machinery/computer/shuttle_control/multi_shuttle/antag
	ui_template = "shuttle_control_console_antag.tmpl"

/obj/machinery/computer/shuttle_control/multi_shuttle/antag/get_ui_data(var/datum/shuttle/autodock/multi/antag/shuttle)
	. = ..()
	if(istype(shuttle))
		. += list(
			"cloaked" = shuttle.cloaked,
		)

/obj/machinery/computer/shuttle_control/multi_shuttle/antag/handle_topic_href(var/datum/shuttle/autodock/multi/antag/shuttle, var/list/href_list)
	..()

	if(!istype(shuttle))
		return

	if(href_list["toggle_cloaked"])
		shuttle.cloaked = !shuttle.cloaked
