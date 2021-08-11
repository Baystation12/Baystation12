#define REPORTS_VIEW      1
#define REPORTS_DOWNLOAD  2

/datum/computer_file/program/reports
	filename = "repview"
	filedesc = "Report Editor"
	nanomodule_path = /datum/nano_module/program/reports
	extended_desc = "A general paperwork viewing and editing utility."
	size = 2
	available_on_ntnet = TRUE
	requires_ntnet = FALSE
	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

/datum/nano_module/program/reports
	name = "Report Editor"

	/// Whether we are in view-only mode.
	var/can_view_only = FALSE
	/// A report being viewed/edited. This is a temporary copy.
	var/datum/computer_file/report/selected_report
	/// The computer file currently open.
	var/datum/computer_file/report/saved_report
	var/prog_state = REPORTS_VIEW

/datum/nano_module/program/reports/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()
	data["prog_state"] = prog_state
	switch(prog_state)
		if(REPORTS_VIEW)
			if(selected_report)
				data["report_data"] = selected_report.generate_nano_data(get_access(user))
			data["view_only"] = can_view_only
			data["printer"] = program.computer.has_component(PART_PRINTER)
		if(REPORTS_DOWNLOAD)
			var/list/L = list()
			for(var/datum/computer_file/report/report in ntnet_global.fetch_reports(get_access(user)))
				var/M = list()
				M["name"] = report.display_name()
				M["uid"] = report.uid
				L += list(M)
			data["reports"] = L

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "reports.tmpl", name, 700, 800, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/program/reports/proc/switch_state(new_state)
	if(prog_state == new_state)
		return
	switch(new_state)
		if(REPORTS_VIEW)
			program.requires_ntnet_feature = null
			program.requires_ntnet = FALSE
			prog_state = REPORTS_VIEW
		if(REPORTS_DOWNLOAD)
			close_report()
			program.requires_ntnet_feature = NTNET_SOFTWAREDOWNLOAD
			program.requires_ntnet = TRUE
			prog_state = REPORTS_DOWNLOAD

/datum/nano_module/program/reports/proc/close_report()
	QDEL_NULL(selected_report)
	saved_report = null

/datum/nano_module/program/reports/proc/save_report(mob/user, save_as)
	if(!program.computer || !program.computer.has_component(PART_HDD))
		to_chat(user, "Unable to find hard drive.")
		return
	selected_report.rename_file()
	if(!program.computer.create_file(selected_report))
		to_chat(user, "Error storing file. Please check your hard drive.")
		return
	saved_report = selected_report
	selected_report = saved_report.clone()
	to_chat(user, "The report has been saved as [saved_report.filename].[saved_report.filetype]")

/datum/nano_module/program/reports/proc/load_report(mob/user)
	if(!program.computer || !program.computer.has_component(PART_HDD))
		to_chat(user, "Unable to find hard drive.")
		return
	var/choices = list()
	for(var/datum/computer_file/report/R in program.computer.get_all_files())
		choices["[R.filename].[R.filetype]"] = R
	var/choice = input(user, "Which report would you like to load?", "Loading Report") as null|anything in choices
	if(choice in choices)
		var/datum/computer_file/report/chosen_report = choices[choice]
		var/editing = alert(user, "Would you like to view or edit the report", "Loading Report", "View", "Edit")
		if(editing == "View")
			if(!chosen_report.verify_access(get_access(user)))
				to_chat(user, "<span class='warning'>You lack access to view this report.</span>")
				return
			can_view_only = TRUE
		else
			if(!chosen_report.verify_access_edit(get_access(user)))
				to_chat(user, "<span class='warning'>You lack access to edit this report.</span>")
				return
			can_view_only = FALSE
		saved_report = chosen_report
		selected_report = chosen_report.clone()
		return

/datum/nano_module/program/reports/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	var/mob/user = usr

	if(text2num(href_list["warning"])) //Gives the user a chance to avoid losing unsaved reports.
		if(alert(user, "Are you sure you want to leave this page? Unsubmitted data will be lost.",, "Yes.", "No.") == "No.")
			return TOPIC_HANDLED //If yes, proceed to the actual action instead.

	if(href_list["load"])
		if(selected_report || saved_report)
			close_report()
		load_report(user)
		return TOPIC_HANDLED
	if(href_list["save"])
		. = TOPIC_HANDLED
		if(!selected_report)
			return
		if(!selected_report.verify_access(get_access(user)))
			return
		var/save_as = text2num(href_list["save_as"])
		save_report(user, save_as)
		return
	if(href_list["submit"])
		. = TOPIC_HANDLED
		if(!selected_report)
			return
		if(!selected_report.verify_access_edit(get_access(user)))
			return
		if(selected_report.submit(user))
			to_chat(user, "The [src] has been submitted.")
			if(alert(user, "Would you like to save a copy?","Save Report", "Yes.", "No.") == "Yes.")
				save_report(user)
		return
	if(href_list["discard"])
		. = TOPIC_HANDLED
		if(!selected_report)
			return
		close_report()
		return
	if(href_list["edit"])
		. = TOPIC_HANDLED
		if(!selected_report)
			return
		var/field_ID = text2num(href_list["ID"])
		var/datum/report_field/field = selected_report.field_from_ID(field_ID)
		if(!field || !field.verify_access_edit(get_access(user)))
			return
		field.ask_value(user) //Handles the remaining IO.
		return
	if(href_list["print"])
		. = TOPIC_HANDLED
		if(!selected_report || !selected_report.verify_access(get_access(user)))
			return
		var/with_fields = text2num(href_list["print_mode"])
		var/text = selected_report.generate_pencode(get_access(user), with_fields)
		if(!program.computer.print_paper(text, selected_report.display_name()))
			to_chat(user, "Hardware error: Printer was unable to print the file. It may be out of paper.")
		return
	if(href_list["export"])
		. = TOPIC_HANDLED
		if(!selected_report || !selected_report.verify_access(get_access(user)))
			return
		selected_report.rename_file()
		var/datum/computer_file/data/text/file = new
		file.filename = selected_report.filename
		file.stored_data = selected_report.generate_pencode(get_access(user), no_html = TRUE) //TXT files can't have html; they use pencode only.
		if(!program.computer.create_file(file))
			to_chat(user, "Error storing file. Please check your hard drive.")
		else
			to_chat(user, "The report has been exported as [file.filename].[file.filetype]")
		return

	if(href_list["download"])
		switch_state(REPORTS_DOWNLOAD)
		return TOPIC_HANDLED
	if(href_list["get_report"])
		. = TOPIC_HANDLED
		var/uid = text2num(href_list["report"])
		for(var/datum/computer_file/report/report in ntnet_global.fetch_reports(get_access(user)))
			if(report.uid == uid)
				selected_report = report.clone()
				can_view_only = FALSE
				switch_state(REPORTS_VIEW)
				return
		to_chat(user, "Network error: Selected report could not be downloaded. Check network functionality and credentials.")
		return
	if(href_list["home"])
		switch_state(REPORTS_VIEW)
		return TOPIC_HANDLED

#undef REPORTS_VIEW
#undef REPORTS_DOWNLOAD
