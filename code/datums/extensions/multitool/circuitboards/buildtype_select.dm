/datum/extension/interactive/multitool/circuitboards/buildtype_select
	expected_type = /obj/item/weapon/stock_parts/circuitboard

/datum/extension/interactive/multitool/circuitboards/buildtype_select/get_interact_window(var/obj/item/device/multitool/M, var/mob/user)
	var/obj/item/weapon/stock_parts/circuitboard/board = holder
	var/dat = list()
	dat += "<b>Select Built Machine:</b><br>"
	dat += "<table>"
	for(var/path in board.get_buildable_types())
		var/obj/thing = path
		dat += "<tr>"
		if(path == board.build_path)
			dat += "<td><span class='good'>&#9724</span></td><td>[initial(thing.name)]</td>"
		else
			dat += "<td><span class='bad'>&#9724</span></td><td><a href='?src=\ref[src];choose=\ref[path]'>[initial(thing.name)]</a></td>"
		dat += "</tr>"
	dat += "</table>"
	return JOINTEXT(dat)

/datum/extension/interactive/multitool/circuitboards/buildtype_select/on_topic(href, href_list, user)
	var/obj/item/weapon/stock_parts/circuitboard/board = holder
	if(href_list["choose"])
		var/path = locate(href_list["choose"])
		if(path && (path in board.get_buildable_types()))
			board.build_path = path
			var/obj/thing = path
			board.SetName(T_BOARD(initial(thing.name)))
			return MT_REFRESH
	return ..()