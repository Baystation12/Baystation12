
/obj/machinery/research/protolathe/proc/add_designs(var/list/new_design_types)
	var/new_designs_added = FALSE
	for(var/design_type in new_design_types)
		//grab the global template
		var/datum/research_design/D = GLOB.designs_by_type[design_type]

		if(D.build_type != src.design_build_flag)
			continue

		if(!all_designs.Find(D))
			new_designs_added = TRUE

			//add it to our list
			all_designs.Add(D)
			designs_by_name[D.name] = D

			//update the design
			ui_AddDesign(D)

	if(new_designs_added)
		playsound(src, 'sound/machines/chime.ogg', 100, 1)
		src.visible_message("\icon[src] <span class='info'>[src] beeps, \"New designs added.\"</span>")

	return new_designs_added
