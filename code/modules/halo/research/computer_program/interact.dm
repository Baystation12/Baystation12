
/datum/nano_module/program/experimental_analyzer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	//var/is_admin = check_access(user, access_innie_boss)

	//data["is_admin"] = is_admin
	data["screen"] = cur_screen
	data["db_loaded"] = loaded_research ? 1 : 0
	data["db_name"] = loaded_research ? "[loaded_research.filename].RDB" : null
	switch(cur_screen)
		if(SCREEN_FILE)

		if(SCREEN_WORKING)
			data["load_progress"] = load_progress
			data["load_message"] = load_message
			data["full_filename"] = ""

			if(load_progress >= 100)
				load_progress = 0
				cur_screen = SCREEN_FILE

				//this isnt the best way to do it but it saves me some time
				if(load_message == STR_LOADING)
					finish_loading()
				else if(load_message == STR_WIPING)
					finish_wiping()
				else if(load_message == STR_MERGING)
					finish_merging()

			//simulated loading time
			load_progress += 100//rand(34,99)
			load_progress = min(load_progress, 100)

		if(SCREEN_TECH)
			data += uiData_SelectedTech()
			data += uiData_TechTreeAvailable()
			data += uiData_TechTreeLocked()
			data += uiData_DestructiveAnalyzer()

		if(SCREEN_TECH_FINISHED)
			data += uiData_TechTreeFinished()

		else
			//cur_screen is set to an invalid number so go to the file menu
			//this is probably an error in the nanoui template
			to_debug_listeners("TECH ERROR: invalid research screen id ([cur_screen])")
			cur_screen = SCREEN_FILE
			data["screen"] = SCREEN_FILE

	data["user"] = "\ref[user]"

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "experimental_analyzer.tmpl", "Experimental Analyzer", 800, 605)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
