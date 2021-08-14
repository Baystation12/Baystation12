/datum/computer_file/program/scanner
	filename = "scndvr"
	filedesc = "Scanner"
	extended_desc = "This program allows setting up and using an attached scanner module."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 6
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/scanner
	category = PROG_UTIL

	/// Whether or not the program is synched with the scanner module.
	var/using_scanner = FALSE
	/// Buffers scan output for saving/viewing.
	var/data_buffer = ""
	/// The type of file the data will be saved to.
	var/scan_file_type = /datum/computer_file/data/text
	var/list/metadata_buffer = list()
	var/paper_type

/datum/computer_file/program/scanner/proc/connect_scanner()
	if(!computer)
		return FALSE
	var/obj/item/stock_parts/computer/scanner/scanner = computer.get_component(PART_SCANNER)
	if(scanner && istype(src, scanner.driver_type))
		using_scanner = TRUE
		scanner.driver = src
		return TRUE
	return FALSE

/datum/computer_file/program/scanner/proc/disconnect_scanner()
	using_scanner = FALSE
	if(computer)
		var/obj/item/stock_parts/computer/scanner/scanner = computer.get_component(PART_SCANNER)
		if(scanner && (src == scanner.driver))
			scanner.driver = null
	data_buffer = null
	metadata_buffer.Cut()
	return TRUE

/datum/computer_file/program/scanner/proc/save_scan(name)
	if(!data_buffer)
		return FALSE
	if(!computer.create_data_file(name, data_buffer, scan_file_type, metadata_buffer.Copy()))
		return FALSE
	return TRUE

/datum/computer_file/program/scanner/proc/check_scanning()
	if(!computer)
		return FALSE
	var/obj/item/stock_parts/computer/scanner/scanner = computer.get_component(PART_SCANNER)
	if(!scanner)
		return FALSE
	if(!scanner.can_run_scan)
		return FALSE
	if(!scanner.check_functionality())
		return FALSE
	if(!using_scanner)
		return FALSE
	if(src != scanner.driver)
		return FALSE
	return TRUE

/datum/computer_file/program/scanner/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["connect_scanner"])
		if(text2num(href_list["connect_scanner"]))
			if(!connect_scanner())
				to_chat(usr, "Scanner installation failed.")
		else
			disconnect_scanner()
		return TOPIC_HANDLED

	if(href_list["scan"])
		if(check_scanning())
			metadata_buffer.Cut()
			var/obj/item/stock_parts/computer/scanner/scanner = computer.get_component(PART_SCANNER)
			scanner.run_scan(usr, src)
		return TOPIC_HANDLED

	if(href_list["save"])
		var/name = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
		if(!save_scan(name))
			to_chat(usr, "Scan save failed.")
		return TOPIC_HANDLED

	if(.)
		SSnano.update_uis(NM)

/datum/nano_module/program/scanner
	name = "Scanner"

/datum/nano_module/program/scanner/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/scanner/prog = program
	if(!prog.computer)
		return
	var/obj/item/stock_parts/computer/scanner/scanner = prog.computer.get_component(PART_SCANNER)
	if(scanner)
		data["scanner_name"] = scanner.name
		data["scanner_enabled"] = scanner.enabled
		data["can_view_scan"] = scanner.can_view_scan
		data["can_save_scan"] = (scanner.can_save_scan && prog.data_buffer)
	data["using_scanner"] = prog.using_scanner
	data["check_scanning"] = prog.check_scanning()
	if(prog.metadata_buffer.len > 0 && prog.paper_type == /obj/item/paper/bodyscan)
		data["data_buffer"] = display_medical_data(prog.metadata_buffer.Copy(), user.get_skill_value(SKILL_MEDICAL, TRUE))
	else
		data["data_buffer"] = digitalPencode2html(prog.data_buffer)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "scanner.tmpl", name, 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()