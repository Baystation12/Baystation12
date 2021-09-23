/datum/computer_file/program/filemanager
	filename = "filemanager"
	filedesc = "NTOS File Manager"
	extended_desc = "This program allows management of files."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "folder-collapsed"
	size = 8
	requires_ntnet = FALSE
	available_on_ntnet = FALSE
	undeletable = TRUE
	nanomodule_path = /datum/nano_module/program/computer_filemanager/
	var/open_file
	var/error
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

/datum/computer_file/program/filemanager/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["PRG_openfile"])
		. = TOPIC_HANDLED
		open_file = href_list["PRG_openfile"]
	if(href_list["PRG_newtextfile"])
		. = TOPIC_HANDLED
		var/newname = sanitize(input(usr, "Enter file name or leave blank to cancel:", "File rename"))
		if(!newname)
			return
		if(!computer.create_data_file(newname, file_type = /datum/computer_file/data/text))
			error = "File error: Unable to create file on disk."
			return
	if(href_list["PRG_deletefile"])
		. = TOPIC_HANDLED
		computer.delete_file(href_list["PRG_deletefile"])
	if(href_list["PRG_clone"])
		. = TOPIC_HANDLED
		computer.clone_file(href_list["PRG_clone"])
	if(href_list["PRG_rename"])
		. = TOPIC_HANDLED
		var/newname = sanitize(input(usr, "Enter new file name:", "File rename", href_list["PRG_rename"]))
		if(!newname)
			return
		if(!computer.rename_file(href_list["PRG_rename"], newname))
			error = "File error: Unable to rename file."
			return
	if(href_list["PRG_usbdeletefile"])
		. = TOPIC_HANDLED
		computer.delete_file(href_list["PRG_usbdeletefile"], computer.get_component(PART_DRIVE))
	if(href_list["PRG_copytousb"])
		. = TOPIC_HANDLED
		computer.copy_between_disks(href_list["PRG_copytousb"], computer.get_component(PART_HDD), computer.get_component(PART_DRIVE))
	if(href_list["PRG_copyfromusb"])
		. = TOPIC_HANDLED
		computer.copy_between_disks(href_list["PRG_copyfromusb"], computer.get_component(PART_DRIVE), computer.get_component(PART_HDD))
	if(href_list["PRG_closefile"])
		. = TOPIC_HANDLED
		open_file = null
		error = null
	if(href_list["PRG_edit"])
		. = TOPIC_HANDLED
		if(!open_file)
			return
		var/datum/computer_file/data/F = computer.get_file(open_file)
		if(!istype(F))
			return
		if(F.do_not_edit && (alert("WARNING: This file is not compatible with editor. Editing it may result in permanently corrupted formatting or damaged data consistency. Edit anyway?", "Incompatible File", "No", "Yes") == "No"))
			return
		if(F.read_only)
			error = "This file is read only. You cannot edit it."
			return

		var/oldtext = html_decode(F.stored_data)
		oldtext = replacetext_char(oldtext, "\[br\]", "\n")

		var/newtext = sanitize(replacetext_char(input(usr, "Editing file [open_file]. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
		if(!newtext)
			return

		computer.update_data_file(F.filename, newtext, F.type, replace_content = TRUE)
	if(href_list["PRG_printfile"])
		. = TOPIC_HANDLED
		if(!open_file)
			return
		var/datum/computer_file/data/F = computer.get_file(open_file)
		if(!istype(F))
			return
		if(!computer.print_paper(F.generate_file_data(),F.filename,F.papertype, F.metadata))
			error = "Hardware error: Unable to print the file."
			return
	if(.)
		SSnano.update_uis(NM)

/datum/nano_module/program/computer_filemanager
	name = "NTOS File Manager"

/datum/nano_module/program/computer_filemanager/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/filemanager/PRG
	PRG = program

	if(PRG.error)
		data["error"] = PRG.error
	if(PRG.open_file)
		if(!PRG.computer || !PRG.computer.has_component(PART_HDD))
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			var/datum/computer_file/data/F = PRG.computer.get_file(PRG.open_file)
			if(!istype(F))
				data["error"] = "I/O ERROR: Unable to open file."
			else
				data["filedata"] = F.generate_file_data(user)
				data["filename"] = "[F.filename].[F.filetype]"
	else
		if(!PRG.computer || !PRG.computer.has_component(PART_HDD))
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			var/list/files[0]
			for(var/datum/computer_file/F in PRG.computer.get_all_files())
				files.Add(list(list(
					"name" = F.filename,
					"type" = F.filetype,
					"size" = F.size,
					"undeletable" = F.undeletable
				)))
			data["files"] = files
			var/obj/item/stock_parts/computer/hard_drive/portable/RHDD = PRG.computer.get_component(PART_DRIVE)
			if(RHDD)
				data["usbconnected"] = TRUE
				var/list/usbfiles[0]
				for(var/datum/computer_file/F in PRG.computer.get_all_files(disk = RHDD))
					usbfiles.Add(list(list(
						"name" = F.filename,
						"type" = F.filetype,
						"size" = F.size,
						"undeletable" = F.undeletable
					)))
				data["usbfiles"] = usbfiles

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "file_manager.tmpl", "NTOS File Manager", 600, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
