/datum/extension/interactive/multitool/circuitboards/stationalert/get_interact_window(obj/item/device/multitool/M, mob/user)
	var/obj/item/stock_parts/circuitboard/stationalert/SA = holder
	. += "<b>Alarm Sources</b><br>"
	. += "<table>"
	for(var/datum/alarm_handler/AH as anything in SSalarm.alarm_handlers)
		. += "<tr>"
		. += "<td>[AH.category]</td>"
		if (AH in SA.alarm_handlers)
			. += "<td>[SPAN_GOOD("&#9724")]Active</td><td><a href='?src=\ref[src];remove=\ref[AH]'>Inactivate</a></td>"
		else
			. += "<td>[SPAN_BAD("&#9724")]Inactive</td><td><a href='?src=\ref[src];add=\ref[AH]'>Activate</a></td>"
		. += "</tr>"
	. += "</table>"

/datum/extension/interactive/multitool/circuitboards/stationalert/on_topic(href, href_list, user)
	var/obj/item/stock_parts/circuitboard/stationalert/SA = holder
	if (href_list["add"])
		var/datum/alarm_handler/AH = locate(href_list["add"]) in SSalarm.alarm_handlers
		if (AH)
			SA.alarm_handlers |= AH
			return MT_REFRESH

	if (href_list["remove"])
		var/datum/alarm_handler/AH = locate(href_list["remove"]) in SSalarm.alarm_handlers
		if (AH)
			SA.alarm_handlers -= AH
			return MT_REFRESH

	return ..()
