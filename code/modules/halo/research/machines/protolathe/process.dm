
/obj/machinery/research/protolathe/process()
	. = ..()

	if(do_reagents_update)
		do_reagents_update = FALSE
		UpdateReagentsString()

	//loop over our queue
	process_queue()

/obj/machinery/research/protolathe
	var/check_index = 1

/obj/machinery/research/protolathe/proc/process_queue()
	. = FALSE

	if(design_queue.len)
		. = TRUE

		//what sprite should we use?
		//0 = idle (lowest priority)
		//1 = fail craft
		//2 = success craft (highest priority)
		var/craft_status = 0

		//upgrades let us make multiple in parallel
		var/crafts_left = min(craft_parallel, design_queue.len)

		//loop over the queue and update all their statuses
		for(var/check_index = 1, check_index <= design_queue.len, check_index++)
			var/datum/craft_entry/E = design_queue[check_index]

			//are we parallel crafting?
			if(crafts_left > 0)
				if(!E.started)
					//can we start this one?
					if(check_resources(E.my_design))
						E.started = TRUE
						use_resources(E.my_design)

						//set the ui entry to green
						ui_SetStatus(check_index, 2)
					else
						//set the ui entry to red
						ui_SetStatus(check_index, 0)

						if(!craft_status)
							//only update the sprite if we would otherwise be idle
							craft_status = 1


				if(E.started)
					//add a bit of progress
					E.progress += speed

					//update the ui
					if(E.my_design.complexity)
						ui_SetProgress(check_index, round(100 * E.progress / E.my_design.complexity))
					else
						ui_SetProgress(check_index, 100)

					//one less parallel crafting
					crafts_left -= 1

					//are we finished?
					if(E.progress >= E.my_design.complexity)
						//produce the thing
						finish_crafting(E.my_design)

						//remove the ui entry
						var/cancel_index = design_queue.Find(E)
						design_queue.Cut(cancel_index, cancel_index + 1)
						ui_UnQueue(cancel_index)

					//update the sprite
					if(design_queue.len)
						craft_status = 2
					else
						craft_status = 0

			else
				//set the ui entry to clear
				ui_SetStatus(check_index, 1)

		//update our sprite
		switch(craft_status)
			if(1)
				icon_state = "protolathe_f"
			if(2)
				icon_state = "protolathe_n"
			else
				icon_state = "protolathe"

	else
		instant_ready = TRUE
