/datum/extension/interactive/multitool/circuitboards/buildtype_select
	expected_type = /obj/item/stock_parts/circuitboard

/datum/extension/interactive/multitool/circuitboards/buildtype_select/get_interact_window(obj/item/device/multitool/M, mob/user)
	var/obj/item/stock_parts/circuitboard/board = holder
	var/dat = list()
	dat += "<b>Select Built Machine:</b><br>"
	dat += "<table>"
	for (var/path in board.get_buildable_types())
		var/obj/thing = path
		dat += "<tr>"
		if (path == board.build_path)
			dat += "<td>[SPAN_GOOD("&#9724")]</td><td>[initial(thing.name)]</td>"
		else
			dat += "<td>[SPAN_BAD("&#9724")]</td><td><a href='?src=\ref[src];choose=\ref[path]'>[initial(thing.name)]</a></td>"
		dat += "</tr>"
	dat += "</table>"
	return JOINTEXT(dat)

/datum/extension/interactive/multitool/circuitboards/buildtype_select/on_topic(href, href_list, user)
	var/obj/item/stock_parts/circuitboard/board = holder
	if (href_list["choose"])
		var/path = locate(href_list["choose"])
		if (path && (path in board.get_buildable_types()))
			board.build_path = path
			var/obj/thing = path
			board.SetName("circuit board ([initial(thing.name)])")
			return MT_REFRESH
	return ..()
