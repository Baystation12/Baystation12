/datum/extension/interactive/multitool/circuitboards/shuttle_console
	expected_type = /obj/item/stock_parts/circuitboard/shuttle_console

/datum/extension/interactive/multitool/circuitboards/shuttle_console/get_interact_window(var/obj/item/device/multitool/M, var/mob/user)
	var/obj/item/stock_parts/circuitboard/shuttle_console/board = holder
	var/dat = list()
	dat += "<b>Current Selected Shuttle:</b>  [board.shuttle_tag || "NONE"]<br>"
	dat += "<a href='?src=\ref[src];sync=1'>Synchronize to current shuttle.</a>"
	return JOINTEXT(dat)

/datum/extension/interactive/multitool/circuitboards/shuttle_console/on_topic(href, href_list, user)
	var/obj/item/stock_parts/circuitboard/shuttle_console/board = holder
	if(href_list["sync"])
		var/new_name
		for(var/shuttle_name in SSshuttle.shuttles)
			var/datum/shuttle/shuttle = SSshuttle.shuttles[shuttle_name]
			if(get_area(board) in shuttle.shuttle_area)
				new_name = shuttle_name
				break
		if(!new_name)
			to_chat(user, SPAN_WARNING("No eligible shuttle could be located. Make sure the board is inside a shuttle and try again."))
			return MT_NOACTION
		if(!board.is_valid_shuttle(SSshuttle.shuttles[new_name]))
			to_chat(user, SPAN_WARNING("The current shuttle does not support this console type. Try a different shuttle or circuit board."))
			return MT_NOACTION		
		board.shuttle_tag = new_name
		to_chat(user, SPAN_NOTICE("You set the shuttle name to '[new_name]'"))
		return MT_REFRESH
	return ..()