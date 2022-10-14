/obj/item/stack/cable_coil/Initialize(mapload, _amount, _color)
	. = ..()
	set_extension(src, /datum/extension/interactive/multitool/items/cable)

/datum/extension/interactive/multitool/items/cable/get_interact_window(obj/item/device/multitool/M, mob/user)
	var/obj/item/stack/cable_coil/cable_coil = holder
	. += "<b>Available Colors</b><br>"
	. += "<table>"
	for(var/cable_color in GLOB.possible_cable_colours)
		. += "<tr>"
		. += "<td>[cable_color]</td>"
		if(cable_coil.color == GLOB.possible_cable_colours[cable_color])
			. += "<td>Selected</td>"
		else
			. += "<td><a href='?src=\ref[src];select_color=[cable_color]'>Select</a></td>"
		. += "</tr>"
	. += "</table>"

/datum/extension/interactive/multitool/items/cable/on_topic(href, href_list, user)
	var/obj/item/stack/cable_coil/cable_coil = holder
	if(href_list["select_color"] && (href_list["select_color"] in GLOB.possible_cable_colours))
		cable_coil.SetCableColor(href_list["select_color"], user)
		return MT_REFRESH

	return ..()
