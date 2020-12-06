/datum/computer_file/program/filemanager
	filename = "filemanager"
	filedesc = "NTOS File Manager"
	extended_desc = "This program allows management of files."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "folder-collapsed"
	size = 8
	requires_ntnet = 0
	available_on_ntnet = 0
	undeletable = 1
	nanomodule_path = /datum/nano_module/program/computer_filemanager/
	var/open_file
	var/error
	usage_flags = PROGRAM_ALL
	category = PROG_UTIL

/datum/computer_file/program/filemanager/Topic(href, href_list)
	if(..())
		return 1

	if(href_list["PRG_openfile"])
		. = 1
		open_file = href_list["PRG_openfile"]
	if(href_list["PRG_newtextfile"])
		. = 1
		var/newname = sanitize(input(usr, "Enter file name or leave blank to cancel:", "File rename"))
		if(!newname)
			return 1
		if(computer.create_file(newname, file_type = /datum/computer_file/data/text))
			return 1
	if(href_list["PRG_deletefile"])
		. = 1
		computer.delete_file(href_list["PRG_deletefile"])
	if(href_list["PRG_usbdeletefile"])
		. = 1
		var/obj/item/weapon/stock_parts/computer/hard_drive/RHDD = computer.get_component(PART_DRIVE)
		computer.delete_file(href_list["PRG_usbdeletefile"], RHDD)

	if(href_list["PRG_closefile"])
		. = 1
		open_file = null
		error = null
	if(href_list["PRG_clone"])
		. = 1
		computer.clone_file(href_list["PRG_clone"])
	if(href_list["PRG_rename"])
		. = 1
		var/datum/computer_file/F = computer.get_file(href_list["PRG_rename"])
		if(!F || !istype(F))
			return 1
		var/newname = sanitize(input(usr, "Enter new file name:", "File rename", F.filename))
		if(F && newname)
			F.filename = newname
	if(href_list["PRG_edit"])
		. = 1
		if(!open_file)
			return 1
		var/datum/computer_file/data/F = computer.get_file(open_file)
		if(!F || !istype(F))
			return 1
		if(F.do_not_edit && (alert("WARNING: This file is not compatible with editor. Editing it may result in permanently corrupted formatting or damaged data consistency. Edit anyway?", "Incompatible File", "No", "Yes") == "No"))
			return 1
		if(F.read_only)
			error = "This file is read only. You cannot edit it."
			return 1

		var/oldtext = html_decode(F.stored_data)
		oldtext = replacetext(oldtext, "\[br\]", "\n")

		var/newtext = sanitize(replacetext(input(usr, "Editing file [open_file]. You may use most tags used in paper formatting:", "Text Editor", oldtext) as message|null, "\n", "\[br\]"), MAX_TEXTFILE_LENGTH)
		if(!newtext)
			return

		if(F)
			computer.save_file(F.filename, newtext)
	if(href_list["PRG_printfile"])
		. = 1
		if(!open_file)
			return 1
		var/datum/computer_file/data/F = computer.get_file(open_file)
		if(!F || !istype(F))
			return 1
		if(!computer.print_paper(digitalPencode2html(F.stored_data),F.filename,F.papertype, F.metadata))
			error = "Hardware error: Unable to print the file."
			return 1
	if(href_list["PRG_copytousb"])
		. = 1
		computer.copy_between_disks(href_list["PRG_copytousb"], computer.get_component(PART_HDD), computer.get_component(PART_DRIVE))
	if(href_list["PRG_copyfromusb"])
		. = 1
		computer.copy_between_disks(href_list["PRG_copyfromusb"], computer.get_component(PART_DRIVE), computer.get_component(PART_HDD))
	if(.)
		SSnano.update_uis(NM)

/datum/nano_module/program/computer_filemanager
	name = "NTOS File Manager"

/datum/nano_module/program/computer_filemanager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/datum/computer_file/program/filemanager/PRG
	PRG = program

	if(PRG.error)
		data["error"] = PRG.error
	if(PRG.open_file)
		var/datum/computer_file/data/F

		if(!PRG.computer || !PRG.computer.has_component(PART_HDD))
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			F = PRG.computer.get_file(PRG.open_file)
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
			var/obj/item/weapon/stock_parts/computer/hard_drive/portable/RHDD = PRG.computer.get_component(PART_DRIVE)
			if(RHDD)
				data["usbconnected"] = 1
				var/list/usbfiles[0]
				for(var/datum/computer_file/F in PRG.computer.get_all_files(RHDD))
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