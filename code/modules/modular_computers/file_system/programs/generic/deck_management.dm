#define DECK_HOME 1
#define DECK_ALL_MISSIONS 2
#define DECK_MISSION_DETAILS 3
#define DECK_REPORT_EDIT 4

/datum/computer_file/program/deck_management
	filename = "deckmngr"
	filedesc = "Deck Management"
	nanomodule_path = /datum/nano_module/deck_management
	program_icon_state = "request"
	program_key_state = "rd_key"
	program_menu_icon = "clock"
	extended_desc = "A tool for managing shuttles, filling out flight plans, and submitting flight-related paperwork."
	size = 18
	available_on_ntnet = TRUE
	requires_ntnet = TRUE
	category = PROG_SUPPLY

/datum/nano_module/deck_management
	name = "Deck Management Program"
	var/prog_state = DECK_HOME                       //Which menu we are in.
	var/can_view_only = 0                            //Whether we are in view-only mode for the report viewer.
	var/datum/shuttle/selected_shuttle               //Which shuttle is currently selected, if any.
	var/datum/shuttle_mission/selected_mission       //Which mission is selected.
	var/datum/computer_file/report/selected_report   //A report being viewed/edited.
	var/list/report_prototypes = list()              //Stores report prototypes to use for UI purposes.
	var/datum/shuttle/prototype_shuttle              //The shuttle for which the prototypes were built (to avoid excessive prototype rebuilding)
	//The default access needed to properly use. Should be set in map files.
	var/default_access = list(access_cargo, access_bridge)  //The format is (needs one of list(these access constants or lists of access constants))

/datum/nano_module/deck_management/New()
	..()
	for(var/shuttle in SSshuttle.shuttle_logs) //Registering to get shuttle updates.
		var/datum/shuttle_log/my_log = SSshuttle.shuttle_logs[shuttle]
		my_log.register(src)

/datum/nano_module/deck_management/Destroy()
	for(var/shuttle in SSshuttle.shuttle_logs) //Unregistering; important for garbage collection.
		var/datum/shuttle_log/my_log = SSshuttle.shuttle_logs[shuttle]
		my_log.unregister(src)
	. = ..()

/datum/nano_module/deck_management/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/logs = SSshuttle.shuttle_logs

	data["prog_state"] = prog_state
	data["default_access"] = get_default_access(user)

	switch(prog_state)
		if(DECK_HOME)
			var/shuttles = list()
			for(var/datum/shuttle/shuttle in logs)
				var/shuttle_data = list()
				shuttle_data["name"] = shuttle.name
				shuttle_data["access"] = get_shuttle_access(user, shuttle)
				var/datum/shuttle_log/log = logs[shuttle]
				if(log.current_mission)
					shuttle_data["mission"] = 1
					shuttle_data["mission_name"] = log.current_mission.name
					shuttle_data["mission_ID"] = log.current_mission.ID
					var/datum/computer_file/report/flight_plan/plan = log.current_mission.flight_plan
					shuttle_data["flight_plan"] = plan
					switch(log.current_mission.stage)
						if(SHUTTLE_MISSION_PLANNED)
							shuttle_data["status"] = "Mission Preparing."
							shuttle_data["departure"] = plan ? "[plan.planned_depart.get_value()] (PLANNED)" : "N/A"
						if(SHUTTLE_MISSION_STARTED)
							shuttle_data["status"] = "Mission Underway."
							shuttle_data["departure"] = log.current_mission.depart_time
				else
					shuttle_data["mission"] = 0
				shuttles += list(shuttle_data)//Make a list of lists, don't flatten.
			data["shuttles"] = shuttles

		if(DECK_ALL_MISSIONS)
			if(!ensure_valid_shuttle())
				return
			data["shuttle_access"] = get_shuttle_access(user, selected_shuttle)
			data["shuttle_name"] = selected_shuttle.name
			var/datum/shuttle_log/log = SSshuttle.shuttle_logs[selected_shuttle]
			var/missions = list()
			for(var/datum/shuttle_mission/M in log.missions)
				missions += list(generate_mission_data(M))
			data["mission_data"] = missions
			var/queued_missions = list()
			for(var/datum/shuttle_mission/M in log.queued_missions)
				queued_missions += list(generate_mission_data(M))
			data["queued_data"] = queued_missions

		if(DECK_MISSION_DETAILS)
			if(!ensure_valid_mission())
				return
			data["shuttle_access"] = get_shuttle_access(user, selected_shuttle)
			data["shuttle_name"] = selected_shuttle.name
			data["mission_data"] = generate_mission_data(selected_mission)
			if(selected_mission.flight_plan)
				data["flight_plan"] = selected_mission.flight_plan.generate_nano_data()
				data["crew"] = selected_mission.flight_plan.manifest.get_value()
			if(!(selected_mission.stage in list(SHUTTLE_MISSION_PLANNED, SHUTTLE_MISSION_QUEUED)))
				var/other_reports = list()
				for(var/i = 1, i <= length(report_prototypes), i++)
					var/datum/computer_file/report/recipient/shuttle/report = report_prototypes[i]
					var/L = list()
					L["name"] = report.display_name()
					L["index"] = i
					L["exists"] = locate(report) in selected_mission.other_reports
					L["access_edit"] = report.verify_access_edit(get_access(user))
					other_reports += list(L)
				data["other_reports"] = other_reports

		if(DECK_REPORT_EDIT)
			if(!ensure_valid_mission())
				return
			if(!istype(selected_report))
				prog_state = DECK_MISSION_DETAILS
				return
			data["report_data"] = selected_report.generate_nano_data(get_access(user))
			data["shuttle_name"] = selected_shuttle.name
			data["mission_data"] = generate_mission_data(selected_mission)
			data["view_only"] = can_view_only

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "deck_management.tmpl", name, 700, 800, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

//Checks that the selected shuttle is valid, and resets to home screen if not.
/datum/nano_module/deck_management/proc/ensure_valid_shuttle()
	if(!(selected_shuttle in SSshuttle.shuttle_logs))
		selected_mission = null
		selected_shuttle = null
		prog_state = DECK_HOME
		return 0
	return 1

//Same for mission, checks that the shuttle is valid first.
/datum/nano_module/deck_management/proc/ensure_valid_mission()
	if(!ensure_valid_shuttle())
		return 0
	var/datum/shuttle_log/log = SSshuttle.shuttle_logs[selected_shuttle]
	if(!(selected_mission in (log.missions + log.queued_missions)) || (selected_mission.shuttle_name != selected_shuttle.name))
		selected_mission = null
		prog_state = DECK_ALL_MISSIONS
		return 0
	return 1

/datum/nano_module/deck_management/proc/generate_mission_data(datum/shuttle_mission/mission)
	var/mission_data = list()
	mission_data["name"] = mission.name
	mission_data["departure"] = mission.depart_time || "N/A"
	mission_data["return_time"] = mission.return_time || "N/A"
	switch(mission.stage)
		if(SHUTTLE_MISSION_QUEUED)
			mission_data["status"] = "Mission Scheduled."
		if(SHUTTLE_MISSION_PLANNED)
			mission_data["status"] = "Mission Preparing."
			mission_data["departure"] = mission.flight_plan ? "[mission.flight_plan.planned_depart.get_value()] (PLANNED)" : "N/A"
		if(SHUTTLE_MISSION_STARTED)
			mission_data["status"] = "Mission Underway."
		if(SHUTTLE_MISSION_FINISHED)
			mission_data["status"] = "Mission Complete."
	mission_data["ID"] = mission.ID
	if(selected_shuttle)
		var/datum/shuttle_log/my_log = SSshuttle.shuttle_logs[selected_shuttle]
		if(my_log.current_mission == mission)
			mission_data["is_current"] = 1
		if(mission in my_log.queued_missions)
			mission_data["queued"] = 1
	return mission_data

/datum/nano_module/deck_management/proc/get_default_access(mob/user)
	for(var/access_pattern in default_access)
		if(check_access(user, access_pattern))
			return 1

/datum/nano_module/deck_management/proc/get_shuttle_access(mob/user, datum/shuttle/shuttle)
	return shuttle.logging_access ? (check_access(user, shuttle.logging_access) || check_access(user, access_bridge)) : 0

/datum/nano_module/deck_management/proc/set_shuttle(mob/user, shuttle_name, need_access = 1)
	var/datum/shuttle/shuttle
	if(!(shuttle = SSshuttle.shuttles[shuttle_name]))
		return 0
	if(need_access && !get_shuttle_access(user, shuttle))
		return 0
	selected_shuttle = shuttle
	if(!ensure_valid_shuttle())
		return 0
	if(selected_shuttle != prototype_shuttle)
		prototype_shuttle = selected_shuttle
		report_prototypes = list()
		for(var/report_type in subtypesof(/datum/computer_file/report/recipient/shuttle))
			var/datum/computer_file/report/recipient/shuttle/new_report = new report_type
			if(new_report.access_shuttle)
				new_report.set_access(null, selected_shuttle.logging_access, override = 0)
			report_prototypes += new_report
	return 1

/datum/nano_module/deck_management/proc/set_mission(mission_ID)
	var/datum/shuttle_log/my_log = SSshuttle.shuttle_logs[selected_shuttle]
	var/datum/shuttle_mission/mission = my_log.mission_from_ID(mission_ID)
	if(!mission)
		return 0
	selected_mission = mission
	return ensure_valid_mission()

/datum/nano_module/deck_management/Topic(href, href_list)
	var/mob/user = usr
	if(..())
		return 1

	if(!get_default_access(user))
		return 1 //No program access if you don't have the right access.
	if(text2num(href_list["warning"])) //Gives the user a chance to avoid losing unsaved reports.
		if(alert(user, "Are you sure you want to do this? Data may be lost.",, "Yes.", "No.") == "No.")
			return 1 //If yes, proceed to the actual action instead.

	if(href_list["details"])
		var/shuttle_name = href_list["shuttle"]
		var/mission_ID = text2num(href_list["mission"])
		if(set_shuttle(user, shuttle_name, 0) && set_mission(mission_ID))
			prog_state = DECK_MISSION_DETAILS
		return 1
	if(href_list["history"])
		var/shuttle_name = href_list["history"]
		if(set_shuttle(user, shuttle_name, 0))
			selected_mission = null
			prog_state = DECK_ALL_MISSIONS
		return 1
	if(href_list["new_mission"])
		var/shuttle_name = href_list["new_mission"]
		if(!set_shuttle(user, shuttle_name, 1))
			return 1
		var/datum/shuttle_log/my_log = SSshuttle.shuttle_logs[selected_shuttle]
		var/input = input(user, "Mission Name:", "Mission Creation") as null|text
		selected_mission = my_log.create_mission(sanitize(input, 50))
		prog_state = DECK_MISSION_DETAILS
		return 1
	if(href_list["modify"])
		var/shuttle_name = href_list["shuttle"]
		var/mission_ID = text2num(href_list["mission"])
		var/function = href_list["modify"]
		if(set_shuttle(user, shuttle_name, 1) && set_mission(mission_ID))
			var/datum/shuttle_log/my_log = SSshuttle.shuttle_logs[selected_shuttle]
			switch(function)
				if("rename")
					var/input = input(user, "Mission Name:", "Rename Mission") as null|text
					my_log.rename_mission(selected_mission, sanitize(input, 50))
				if("delete")
					my_log.delete_mission(selected_mission)
				if("move_up")
					my_log.move_in_queue(selected_mission, 1)
				if("move_down")
					my_log.move_in_queue(selected_mission, -1)
		return 1
	if(href_list["report"])
		var/shuttle_name = href_list["shuttle"]
		var/mission_ID = text2num(href_list["mission"])
		if(set_shuttle(user, shuttle_name, 0) && set_mission(mission_ID))
			can_view_only = (href_list["view"] ? 1 : 0)
			if(href_list["flight_plan"])
				prog_state = DECK_REPORT_EDIT
				if(selected_mission.flight_plan)
					selected_report = selected_mission.flight_plan.clone()//We always make a new one to buffer changes until submitted.
				else
					selected_report = new /datum/computer_file/report/flight_plan
					selected_report.set_access(null, selected_shuttle.logging_access, override = 0)
			else
				if(selected_mission.stage in list(SHUTTLE_MISSION_PLANNED, SHUTTLE_MISSION_QUEUED))
					return 1 //Hold your horses until the mission is started on these reports.
				var/index = text2num(href_list["index"])
				if(!index)
					return 1
				var/datum/computer_file/report/prototype = LAZYACCESS(report_prototypes, index)
				if (!prototype)
					return 1
				prog_state = DECK_REPORT_EDIT
				var/datum/computer_file/report/old_report = locate(prototype.type) in selected_mission.other_reports
				if(old_report)
					selected_report = old_report.clone()
				else
					var/datum/computer_file/report/recipient/shuttle/new_report = prototype.clone()
					new_report.shuttle.set_value(selected_shuttle.name)
					new_report.mission.set_value(selected_mission.name)
					selected_report = new_report
		return 1
	if(href_list["home"])
		selected_shuttle = null
		selected_mission = null
		selected_report = null
		prog_state = DECK_HOME
		return 1

	if(href_list["edit"])
		if(!ensure_valid_mission() || !selected_report)
			return 1
		var/field_ID = text2num(href_list["ID"])
		var/datum/report_field/field = selected_report.field_from_ID(field_ID)
		if(!field || !field.verify_access_edit(get_access(user)))
			return 1
		field.ask_value(user) //Handles the remaining IO.
		return 1
	if(href_list["submit"])
		if(!ensure_valid_mission() || !selected_report)
			return 1
		if(!selected_report.verify_access_edit(get_access(user)))
			return 1
		var/datum/shuttle_log/my_log = SSshuttle.shuttle_logs[selected_shuttle]
		if(my_log.submit_report(selected_mission, selected_report, user))
			selected_report = null
			prog_state = DECK_MISSION_DETAILS
		return 1
	if(href_list["discard"])
		if(!ensure_valid_mission() || !selected_report)
			return 1
		qdel(selected_report)
		prog_state = DECK_MISSION_DETAILS
		return 1

	if(href_list["summon_crew"])
		var/shuttle_name = href_list["shuttle"]
		var/mission_ID = text2num(href_list["mission"])
		if(!set_shuttle(user, shuttle_name, 1) || !set_mission(mission_ID))
			return 1
		if(!selected_mission.flight_plan)
			return 1
		var/crew = selected_mission.flight_plan.manifest.get_value(in_line = 1)
		var/time = selected_mission.flight_plan.planned_depart.get_value()
		if(!crew || !time)
			to_chat(user, "<span class='warning'>Please fill in the crew manifest and departure time first.</span>")
			return 1
		var/place = selected_shuttle.name
		if(alert(user, "Would you like to choose a custom gathering point, or just use [place]?", "Announcement Creation", "Default", "Custom") == "Custom")
			var/list/areas = area_repository.get_areas_by_name()
			var/area/A = input(user, "Pick a custom location from the list.", "Announcement Creation") as null|anything in areas
			if(A)
				place = A
		if(alert(user, "This will make a radio announcement summoning all mission crew to the [place]. Are you sure you want to do this?",, "Yes.", "No.") == "No.")
			return 1
		var/datum/shuttle_log/my_log = SSshuttle.shuttle_logs[selected_shuttle]
		if(world.time - my_log.last_spam >= 1 MINUTE) //Slow down with that spam button
			GLOB.global_announcer.autosay("The [selected_shuttle.name] is planning to depart on a mission promptly at [time]. The following crew members are to make their way to \the [place] immediately: [crew].", "Hangar Announcement System")
			my_log.last_spam = world.time
		else
			to_chat(user, "<span class='warning'>It's too soon after the previous announcement!</span>")
		return 1
	if(href_list["email_crew"])
		var/shuttle_name = href_list["shuttle"]
		var/mission_ID = text2num(href_list["mission"])
		if(!set_shuttle(user, shuttle_name, 1) || !set_mission(mission_ID))
			return 1
		if(!selected_mission.flight_plan)
			return 1
		var/datum/report_field/people/manifest = selected_mission.flight_plan.manifest
		if(!manifest.get_value())
			return 1
		manifest.send_email(user)
		return 1

#undef DECK_HOME
#undef DECK_ALL_MISSIONS
#undef DECK_MISSION_DETAILS
#undef DECK_REPORT_EDIT