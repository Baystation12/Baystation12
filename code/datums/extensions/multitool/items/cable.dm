/obj/item/stack/cable_coil/Initialize(mapload, _amount, _color)
	. = ..()
	set_extension(src, /datum/extension/interactive/multitool/items/cable)

/datum/extension/interactive/multitool/items/cable/get_interact_window(obj/item/device/multitool/M, mob/user)
	var/obj/item/stack/cable_coil/cable_coil = holder
	. += "<b>Available Colors</b><br>"
	. += "<table>"
	for(var/cable_color in GLOB.cable_default_colors)
		. += "<tr>"
		. += "<td>[cable_color]</td>"
		if(cable_coil.color == GLOB.cable_default_colors["[cable_color]"])
			. += "<td>Selected</td>"
		else
			. += "<td><a href='?src=\ref[src];select_color=[cable_color]'>Select</a></td>"
		. += "</tr>"
	. += "</table>"

/datum/extension/interactive/multitool/items/cable/on_topic(href, href_list, user)
	var/obj/item/stack/cable_coil/cable_coil = holder
	if(href_list["select_color"] && (href_list["select_color"] in GLOB.cable_default_colors))
		var/new_color_code = GLOB.cable_default_colors["[href_list["select_color"]]"]
		cable_coil.set_color(new_color_code)
		return MT_REFRESH

	return ..()
