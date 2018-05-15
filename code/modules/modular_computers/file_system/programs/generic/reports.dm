/datum/computer_file/program/reports
	filename = "repview"
	filedesc = "Report Editor"
	nanomodule_path = /datum/nano_module/program/reports
	extended_desc = "A general paperwork viewing and editing utility."
	size = 6
	available_on_ntnet = 1
	requires_ntnet = 1

/datum/nano_module/program/reports
	name = "Report Editor"
	var/can_view_only = 0                              //Whether we are in view-only mode.
	var/datum/computer_file/report/selected_report     //A report being viewed/edited. This is a temporary copy.
	var/datum/computer_file/report/saved_report        //The computer file open.

/datum/nano_module/program/reports/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	if(selected_report)
		data["report_data"] = selected_report.generate_nano_data(get_access(user))
	data["view_only"] = can_view_only

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "reports.tmpl", name, 700, 800, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/reports/proc/close_report()
	qdel(selected_report)
	saved_report = null

/datum/nano_module/program/reports/proc/save_report(mob/user)
	if(!program.computer || !program.computer.hard_drive)
		to_chat(user, "Unable to find hard drive.")
		return
	program.computer.hard_drive.remove_file(saved_report)
	if(!program.computer.hard_drive.store_file(selected_report))
		to_chat(user, "Error storing file. Please check your hard drive.")		
		program.computer.hard_drive.store_file(saved_report)
		return
	qdel(saved_report)
	saved_report = selected_report
	selected_report = saved_report.clone()

/datum/nano_module/program/reports/proc/load_report(mob/user)
	if(!program.computer || !program.computer.hard_drive)
		to_chat(user, "Unable to find hard drive.")
		return
	var/choices = list()
	for(var/datum/computer_file/report/R in program.computer.hard_drive.stored_files)
		choices["[R.filename].[R.filetype]"] = R
	var/choice = input(user, "Which report would you like to load?", "Loading Report") as null|anything in choices
	if(choice in choices)
		var/datum/computer_file/report/chosen_report = choices[choice]
		var/editing = alert(user, "Would you like to view or edit the report", "Loading Report", "View", "Edit")
		if(editing == "View")
			if(!chosen_report.verify_access(get_access(user)))
				to_chat(user, "<span class='warning'>You lack access to view this report.</span>")
				return
			can_view_only = 1
		else
			if(!chosen_report.verify_access_edit(get_access(user)))
				to_chat(user, "<span class='warning'>You lack access to edit this report.</span>")
				return
			can_view_only = 0
		saved_report = chosen_report
		selected_report = chosen_report.clone()
		return 1

/datum/nano_module/program/reports/Topic(href, href_list)
	var/mob/user = usr
	if(..())
		return 1

	if(text2num(href_list["warning"])) //Gives the user a chance to avoid losing unsaved reports.
		if(alert(user, "Are you sure you want to leave this page? Unsubmitted data will be lost.",, "Yes.", "No.") == "No.")
			return 1 //If yes, proceed to the actual action instead.

	if(href_list["load"])
		if(selected_report || saved_report)
			close_report()
		load_report(user)
		return 1
	if(href_list["save"])
		if(!selected_report)
			return 1
		if(!selected_report.verify_access(get_access(user)))
			return 1
		save_report(user)
	if(href_list["submit"])
		if(!selected_report)
			return 1
		if(!selected_report.verify_access_edit(get_access(user)))
			return 1
		if(selected_report.submit(user))
			to_chat(user, "The [src] has been submitted.")
			if(alert(user, "Would you like to save a copy?","Save Report", "Yes.", "No.") == "Yes.")
				save_report(user)
		return 1
	if(href_list["discard"])
		if(!selected_report)
			return 1
		close_report()
		return 1
	if(href_list["edit"])
		if(!selected_report)
			return 1
		var/field_ID = text2num(href_list["ID"])
		var/datum/report_field/field = selected_report.field_from_ID(field_ID)
		if(!field || !field.verify_access_edit(get_access(user)))
			return 1
		field.ask_value(user) //Handles the remaining IO.
		return 1