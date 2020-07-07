
/datum/computer_file/program/experimental_analyzer/process_tick()
	. = ..()
	NM:process_tick()

/datum/nano_module/program/experimental_analyzer/proc/process_tick()

	if(techprint_queue.len)
		//grab the first techprint in the queue
		var/datum/techprint/T = techprint_queue[1]

		//give it a research tick
		var/result = T.research_tick()

		if(result)
			//all done!
			techprint_queue -= T
			finished_timer(T)
		else
			//only update UI if we're still ticking
			ui_ProgressTech(T)
			if(T == selected_techprint)
				ui_SelectedTech["percent"] = selected_techprint.GetPercent()
