
/datum/nano_module/program/experimental_analyzer/proc/merge_file(var/datum/computer_file/research_db/new_file)
	cur_screen = SCREEN_WORKING
	load_message = STR_MERGING

	spawn(-1)
		SelectTech(null)

	spawn(1)
		//make sure our tree has all the tech prints of the other one
		//loaded_research.build_tree(new_file.techprints_by_type)

		//iteratively recreate the finished tech list
		for(var/datum/techprint/finished_template in new_file.completed_techprints)
			//if this is a hidden tech, we might not have it in our database
			var/datum/techprint/our_child = loaded_research.techprints_by_type[finished_template.type]

			if(!our_child)
				//we dont, so add it and its descendants to our tree
				loaded_research.build_tree(list(finished_template.type))

			//now grab it
			our_child = loaded_research.techprints_by_type[finished_template.type]

			//finish it
			finalise_research(our_child)

		//now copy across wip progress for any unfinished techs
		for(var/datum/techprint/wip_template in new_file.ready_techprints)
			var/datum/techprint/our_child = loaded_research.techprints_by_type[wip_template.type]
			our_child.copy_other(wip_template)

		spawn(-1)
			ui_RebuildTechTree()

/datum/nano_module/program/experimental_analyzer/proc/finish_merging()
	var/obj/host = nano_host()
	host.visible_message("\icon[host] <span class='info'>Research database successfully merged in.</span>")
	playsound(get_turf(host), 'sound/machines/chime.ogg', 100, 1)
