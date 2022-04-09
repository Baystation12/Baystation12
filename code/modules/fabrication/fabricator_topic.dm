/obj/machinery/fabricator/OnTopic(user, href_list, state)
	if(href_list["change_category"])
		var/choice = input("Which category do you wish to display?") as null|anything in SSfabrication.get_categories(fabricator_class)|"All"
		if(!choice || !CanUseTopic(user, state))
			return TOPIC_HANDLED
		show_category = choice
		. = TOPIC_REFRESH
	else if(href_list["make"])
		try_queue_build(locate(href_list["make"]), text2num(href_list["multiplier"]))
		. = TOPIC_REFRESH
	else if(href_list["cancel"])
		try_cancel_build(locate(href_list["cancel"]))
		. = TOPIC_REFRESH
	else if(href_list["eject_mat"])
		try_dump_material(href_list["eject_mat"])
		. = TOPIC_REFRESH

/obj/machinery/fabricator/proc/try_cancel_build(var/datum/fabricator_build_order/order)
	if(istype(order) && currently_building != order && is_functioning())
		if(order in queued_orders)
			// Refund some mats.
			for(var/mat in order.earmarked_materials)
				stored_material[mat] = min(stored_material[mat] + (order.earmarked_materials[mat] * 0.9), storage_capacity[mat])
			queued_orders -= order
		qdel(order)

/obj/machinery/fabricator/proc/try_dump_material(var/mat_name)
	for(var/mat_path in stored_substances_to_names)
		if(stored_substances_to_names[mat_path] == mat_name)
			if(ispath(mat_path, /material))
				var/material/mat = SSmaterials.get_material_by_name(mat_name)
				if(mat && stored_material[mat_path] > mat.units_per_sheet && mat.stack_type)
					var/sheet_count = Floor(stored_material[mat_path]/mat.units_per_sheet)
					stored_material[mat_path] -= sheet_count * mat.units_per_sheet
					mat.place_sheet(get_turf(src), sheet_count)
			else if(!isnull(stored_material[mat_path]))
				stored_material[mat_path] = 0
