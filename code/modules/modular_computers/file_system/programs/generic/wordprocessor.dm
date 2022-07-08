/datum/computer_file/program/wordprocessor
	filename = "wordprocessor"
	filedesc = "NanoWord"
	extended_desc = "This program allows the editing and preview of text documents."
	program_icon_state = "word"
	program_key_state = "atmos_key"
	size = 4
	requires_ntnet = FALSE
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_wordprocessor
	var/browsing = FALSE
	var/open_file
	var/loaded_data
	var/error
	var/is_edited
	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

/datum/computer_file/program/wordprocessor/proc/open_file(filename)
	var/datum/computer_file/data/F = computer.get_file(filename)
	if(istype(F))
		open_file = F.filename
		loaded_data = F.stored_data
		is_edited = FALSE
		return TRUE
	return FALSE

/datum/computer_file/program/wordprocessor/proc/create_file(filename, data = "")
	. = computer.save_data_file(filename, data, /datum/computer_file/data/text)
	if(.)
		is_edited = FALSE

/datum/computer_file/program/wordprocessor/proc/save_file(filename)
	. = computer.save_data_file(filename, loaded_data, /datum/computer_file/data/text)
	if(.)
		is_edited = FALSE

/datum/computer_file/program/wordprocessor/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["PRG_txtrpeview"])
		show_browser(usr,"<HTML><HEAD><TITLE>[open_file]</TITLE></HEAD>[digitalPencode2html(loaded_data)]</BODY></HTML>", "window=[open_file]")
		return TOPIC_HANDLED

	if(href_list["PRG_taghelp"])
		var/datum/codex_entry/entry = SScodex.get_codex_entry("pen")
		if(entry)
			SScodex.present_codex_entry(usr, entry)
		return TOPIC_HANDLED

	if(href_list["PRG_closebrowser"])
		browsing = FALSE
		return TOPIC_HANDLED

	if(href_list["PRG_backtomenu"])
		error = null
		return TOPIC_HANDLED

	if(href_list["PRG_loadmenu"])
		browsing = TRUE
		return TOPIC_HANDLED

	if(href_list["PRG_openfile"])
		. = TOPIC_HANDLED
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				if(!save_file(open_file))
					error = "I/O error: Unable to save file '[open_file]'."
					browsing = FALSE
					return
		browsing = FALSE
		if(!open_file(href_list["PRG_openfile"]))
			error = "I/O error: Unable to open file '[href_list["PRG_openfile"]]'."
		return

	if(href_list["PRG_newfile"])
		. = TOPIC_HANDLED
		if(is_edited)
			if(alert("Would you like to save your changes first?",,"Yes","No") == "Yes")
				if(!save_file(open_file))
					error = "I/O error: Unable to save file '[open_file]'."
					return
		var/newname = sanitize(input(usr, "Enter file name:", "New File") as text|null)
		if(!newname)
			return
		var/datum/computer_file/data/F = create_file(newname)
		if(!istype(F))
			error = "I/O error: Unable to create file '[newname]'."
			return
		open_file = F.filename
		loaded_data = ""
		return

	if(href_list["PRG_saveasfile"])
		. = TOPIC_HANDLED
		var/newname = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
		if(!newname)
			return
		var/datum/computer_file/data/F = create_file(newname, loaded_data)
		if(!istype(F))
			error = "I/O error: Unable to create file '[newname]'."
			return
		open_file = F.filename
		return

	if(href_list["PRG_savefile"])
		. = TOPIC_HANDLED
		if(!open_file)
			open_file = sanitize(input(usr, "Enter file name:", "Save As") as text|null)
			if(!open_file)
				return
		if(!save_file(open_file))
			error = "I/O error: Unable to save file '[open_file]'."
		return

	if(href_list["PRG_editfile"])
		var/oldtext = html_decode(loaded_data)
		oldtext = replacetext_char(oldtext, "\[br\]", "\n")

		var/newtext = sanitize(replacetext_char(input(usr, "Editing file '[open_file]'. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
		if(!newtext)
			return
		loaded_data = newtext
		is_edited = TRUE
		return TOPIC_HANDLED

	if(href_list["PRG_printfile"])
		. = TOPIC_HANDLED
		if(!computer.print_paper(digitalPencode2html(loaded_data)))
			error = "Hardware error: Printer missing or out of paper."
		return

/datum/nano_module/program/computer_wordprocessor
	name = "Word Processor"

/datum/nano_module/program/computer_wordprocessor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/wordprocessor/PRG
	PRG = program

	if(PRG.error)
		data["error"] = PRG.error
	if(PRG.browsing)
		data["browsing"] = PRG.browsing
		if(!PRG.computer || !PRG.computer.has_component(PART_HDD))
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			var/list/files[0]
			for(var/datum/computer_file/F in PRG.computer.get_all_files())
				if(F.filetype == "TXT")
					files.Add(list(list(
						"name" = F.filename,
						"size" = F.size
					)))
			data["files"] = files

			var/obj/item/stock_parts/computer/hard_drive/portable/RHDD = PRG.computer.get_component(PART_DRIVE)
			if(RHDD)
				data["usbconnected"] = TRUE
				var/list/usbfiles[0]
				for(var/datum/computer_file/F in PRG.computer.get_all_files(disk = RHDD))
					if(F.filetype == "TXT")
						usbfiles.Add(list(list(
							"name" = F.filename,
							"size" = F.size,
						)))
				data["usbfiles"] = usbfiles
	else if(PRG.open_file)
		data["filedata"] = digitalPencode2html(PRG.loaded_data)
		data["filename"] = PRG.is_edited ? "[PRG.open_file]*" : PRG.open_file
	else
		data["filedata"] = digitalPencode2html(PRG.loaded_data)
		data["filename"] = "UNNAMED"

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "word_processor.tmpl", "Word Processor", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
