
/obj/machinery/research/protolathe/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["view"])
		var/datum/research_design/D = designs_by_name[href_list["view"]]
		ui_SelectDesign(D)
		return 1

	if(href_list["craft"])
		var/datum/research_design/D = designs_by_name[href_list["craft"]]
		attempt_craft(D, usr)
		return 1

	if(href_list["cancel"])
		cancel_crafting(text2num(href_list["cancel"]), usr)
		return 1

	if(href_list["eject_mat"])
		eject_materials(href_list["eject_mat"], usr)
		return 1

	if(href_list["toggle_reagent"])
		toggle_reagent_mode(usr)
		return 1

	if(href_list["eject_comp"])
		consume_obj(href_list["eject_comp"], 1, TRUE)
		return 1
