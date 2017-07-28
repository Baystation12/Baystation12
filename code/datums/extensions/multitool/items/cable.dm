/obj/item/stack/cable_coil/Initialize()
	set_extension(src, /datum/extension/interactive/multitool, /datum/extension/interactive/multitool/items/cable)
	. = ..()

/datum/extension/interactive/multitool/items/cable/get_interact_window(var/obj/item/device/multitool/M, var/mob/user)
	var/obj/item/stack/cable_coil/cable_coil = holder
	. += "<b>Available Colors</b><br>"
	. += "<table>"
	for(var/cable_color in possible_cable_coil_colours)
		. += "<tr>"
		. += "<td>[cable_color]</td>"
		if(cable_coil.color == possible_cable_coil_colours[cable_color])
			. += "<td>Selected</td>"
		else
			. += "<td><a href='?src=\ref[src];select_color=[cable_color]'>Select</a></td>"
		. += "</tr>"
	. += "</table>"

/datum/extension/interactive/multitool/items/cable/on_topic(href, href_list, user)
	var/obj/item/stack/cable_coil/cable_coil = holder
	if(href_list["select_color"] && href_list["select_color"] in possible_cable_coil_colours)
		cable_coil.set_cable_color(href_list["select_color"], user)
		return MT_REFRESH

	return ..()
