/datum/computer_file/program/scanner
	filename = "scndvr"
	filedesc = "Scanner"
	extended_desc = "This program allows setting up and using an attached scanner module."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	size = 6
	requires_ntnet = 0
	available_on_ntnet = 1
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/scanner

	var/using_scanner = 0	//Whether or not the program is synched with the scanner module.
	var/data_buffer = ""	//Buffers scan output for saving/viewing.
	var/scan_file_type = /datum/computer_file/data/text		//The type of file the data will be saved to.

/datum/computer_file/program/scanner/proc/connect_scanner()	//If already connected, will reconnect.
	if(!computer || !computer.scanner)
		return 0
	if(istype(src, computer.scanner.driver_type))
		using_scanner = 1
		computer.scanner.driver = src
		return 1
	return 0

/datum/computer_file/program/scanner/proc/disconnect_scanner()
	using_scanner = 0
	if(computer && computer.scanner && (src == computer.scanner.driver) )
		computer.scanner.driver = null
	data_buffer = null
	return 1

/datum/computer_file/program/scanner/proc/save_scan(name)
	if(!data_buffer)
		return 0
	if(!create_file(name, data_buffer, scan_file_type))
		return 0
	return 1

/datum/computer_file/program/scanner/proc/check_scanning()
	if(!computer || !computer.scanner)
		return 0
	if(!computer.scanner.can_run_scan)
		return 0
	if(!computer.scanner.check_functionality())
		return 0
	if(!using_scanner)
		return 0
	if(src != computer.scanner.driver)
		return 0
	return 1

/datum/computer_file/program/scanner/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["connect_scanner"])
		if(text2num(href_list["connect_scanner"]))
			if(!connect_scanner())
				to_chat(usr, "Scanner installation failed.")
		else
			disconnect_scanner()
		return 1

	if(href_list["scan"])
		if(check_scanning())
			computer.scanner.run_scan(usr, src)
		return 1

	if(href_list["save"])
		var/name = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
		if(!save_scan(name))
			to_chat(usr, "Scan save failed.")

	if(.)
		GLOB.nanomanager.update_uis(NM)

/datum/nano_module/program/scanner
	name = "Scanner"

/datum/nano_module/program/scanner/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/scanner/prog = program
	if(!prog.computer)
		return
	if(prog.computer.scanner)
		data["scanner_name"] = prog.computer.scanner.name
		data["scanner_enabled"] = prog.computer.scanner.enabled
		data["can_view_scan"] = prog.computer.scanner.can_view_scan
		data["can_save_scan"] = (prog.computer.scanner.can_save_scan && prog.data_buffer)
	data["using_scanner"] = prog.using_scanner
	data["check_scanning"] = prog.check_scanning()
	data["data_buffer"] = pencode2html(prog.data_buffer)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "scanner.tmpl", name, 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()