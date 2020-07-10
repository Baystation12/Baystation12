
/datum/nano_module/program/experimental_analyzer
	var/obj/machinery/research/destructive_analyzer/linked_destroy

/datum/nano_module/program/experimental_analyzer/proc/autolink_destruct()
	//this proc will connect to the closest destructive analyzer with appropriate safety checks

	//safely disconnect any previous links
	if(linked_destroy)
		//this should call back to us
		if(linked_destroy.controller)
			linked_destroy.controller.unlink_machine(linked_destroy)

		//but in case it doesnt...
		if(linked_destroy)
			to_debug_listeners("WARNING: [src.type] is unlinking a [linked_destroy.type] \
				which was connected to a different controller")
			unlink_machine(linked_destroy)

	//find new one
	var/obj/host = nano_host()
	var/cur_dist = 0
	for(var/obj/machinery/research/destructive_analyzer/check_destroy in view(3, host))
		var/check_dist = get_dist(host, check_destroy)

		//grab the first one we find
		if(!linked_destroy)
			linked_destroy = check_destroy
			cur_dist = check_dist

		else if(check_dist < cur_dist)
			//is this one closer? we want to find the closest
			linked_destroy = check_destroy
			cur_dist = check_dist

	//tell the destructer we have chosen it
	if(linked_destroy)
		//tell it to unlink if it is already linked
		if(linked_destroy.controller)
			linked_destroy.controller.unlink_machine(linked_destroy)

		//you are mine now
		linked_destroy.controller = src

/datum/nano_module/program/experimental_analyzer/proc/unlink_machine(var/obj/machinery/research/R)
	if(linked_destroy && R == linked_destroy)
		linked_destroy.controller = null
		linked_destroy = null

/datum/nano_module/program/experimental_analyzer/proc/can_destruct_object(var/obj/I)

	if(selected_techprint)
		//do we need this for our currently researching technology?
		return selected_techprint.can_destruct_obj(I, loaded_research)

	return FALSE

/datum/nano_module/program/experimental_analyzer/proc/can_destruct_current()

	if(linked_destroy && linked_destroy.loaded_item && \
		selected_techprint && selected_techprint.prereqs_satisfied(loaded_research))
		return can_destruct_object(linked_destroy.loaded_item)

	return FALSE

/datum/nano_module/program/experimental_analyzer/proc/activate_destruct()
	linked_destroy.activate_destruct()

/datum/nano_module/program/experimental_analyzer/proc/eject_destruct()
	linked_destroy.eject_item()

/datum/nano_module/program/experimental_analyzer/proc/obj_destruct(var/obj/I)
	if(analyzing_techprint)
		//what happens when we destruct something?
		var/result = analyzing_techprint.obj_destructed(I)

		//special handling for exploratory analysis
		if(analyzing_techprint.type == /datum/techprint/unknown)
			var/obj/host = nano_host()
			//any newly discovered techprints
			var/success = FALSE
			var/list/results = result
			for(var/datum/techprint/template in results)
				//check if we have already discovered it
				if(loaded_research.techprints_by_type.Find(template.type))
					continue

				//tell the user
				success = TRUE
				host.visible_message("\icon[host] <span class='info'>New techprint discovered: [template.name]</span>")
				//playsound(get_turf(host), 'sound/machines/chime.ogg', 100, 1)

				//add it to our database
				loaded_research.build_tree(list(template.type))

				//recursive call to process the object destruction and initialize or update the new tech
				var/datum/techprint/new_print = loaded_research.techprints_by_type[template.type]
				analyzing_techprint = new_print
				obj_destruct(I)

			if(!success)
				//rip
				host.visible_message("\icon[host] <span class='notice'>No new techprints have been discovered.</span>")
				playsound(get_turf(host), 'sound/machines/buzz-sigh.ogg', 100, 1)

		else if(result)
			//ordinary techprint

			//is this tech completed?
			//note: this proc will also do what is needed if the tech actually IS ready to finish
			var/finished = check_finished_consumables(analyzing_techprint)

			//we only need to do UI updates if it hasnt finished, otherwise check_finished_consumables() will have handled it
			if(!finished)
				//update the tech list
				ui_ProgressTech(analyzing_techprint)

				//update the tech preview
				if(selected_techprint == analyzing_techprint)
					//ui updates
					ui_SelectedTech["percent"] = selected_techprint.GetPercent()
					ui_SelectedTech["consumables"] = selected_techprint.GetConsumablesString()
					ui_SelectedTech["can_research"] = selected_techprint.consumables_satisfied()

			analyzing_techprint = null

	else
		to_debug_listeners("TECH ERROR: [I.type] was destructed when no techprint was selected")
