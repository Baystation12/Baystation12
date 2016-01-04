/datum/computer_file/program/filemanager
	filename = "filemanager"
	filedesc = "NTOS File Manager"
	extended_desc = "This program allows management of files."
	program_icon_state = "generic"
	size = 8
	requires_ntnet = 0
	available_on_ntnet = 0
	undeletable = 1
	nanomodule_path = /datum/nano_module/computer_filemanager/
	var/open_file
	var/error

/datum/computer_file/program/filemanager/Topic(href, href_list)
	if(href_list["PRG_openfile"])
		open_file = href_list["PRG_openfile"]
	if(href_list["PRG_newtextfile"])
		var/newname = sanitize(input(usr, "Enter file name or leave blank to cancel:", "File rename"))
		if(!newname)
			return
		var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return
		var/datum/computer_file/data/F = new/datum/computer_file/data()
		F.filename = newname
		F.filetype = "TXT"
		HDD.store_file(F)
	if(href_list["PRG_deletefile"])
		var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return
		var/datum/computer_file/file = HDD.find_file_by_name(href_list["PRG_deletefile"])
		if(!file || file.undeletable)
			return
		HDD.remove_file(file)
	if(href_list["PRG_usbdeletefile"])
		var/obj/item/weapon/computer_hardware/hard_drive/RHDD = computer.portable_drive
		if(!RHDD)
			return
		var/datum/computer_file/file = RHDD.find_file_by_name(href_list["PRG_usbdeletefile"])
		if(!file || file.undeletable)
			return
		RHDD.remove_file(file)
	if(href_list["PRG_closefile"])
		open_file = null
		error = null
	if(href_list["PRG_clone"])
		var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return
		var/datum/computer_file/F = HDD.find_file_by_name(href_list["PRG_clone"])
		if(!F || !istype(F))
			return
		var/datum/computer_file/C = F.clone(1)
		HDD.store_file(C)
	if(href_list["PRG_rename"])
		var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return
		var/datum/computer_file/file = HDD.find_file_by_name(href_list["PRG_rename"])
		if(!file || !istype(file))
			return
		var/newname = sanitize(input(usr, "Enter new file name:", "File rename", file.filename))
		if(file && newname)
			file.filename = newname
	if(href_list["PRG_edit"])
		if(!open_file)
			return
		var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return
		var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
		if(!F || !istype(F))
			return
		// 16384 is the limit for file length in characters. Currently, papers have value of 2048 so this is 8 times as long, since we can't edit parts of the file independently.
		var/newtext = sanitize(html_decode(input(usr, "Editing file [open_file]. You may use most tags used in paper formatting:", "Text Editor", F.stored_data) as message), 16384)
		if(F)
			var/datum/computer_file/data/backup = F.clone()
			HDD.remove_file(F)
			F.stored_data = newtext
			F.calculate_size()
			// We can't store the updated file, it's probably too large. Print an error and restore backed up version.
			// This is mostly intended to prevent people from losing texts they spent lot of time working on due to running out of space.
			// They will be able to copy-paste the text from error screen and store it in notepad or something.
			if(!HDD.store_file(F))
				error = "I/O error: Unable to overwrite file. Hard drive is probably full. You may want to backup your changes before closing this window:<br><br>[F.stored_data]<br><br>"
				HDD.store_file(backup)
	if(href_list["PRG_printfile"])
		if(!open_file)
			return
		var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
		if(!HDD)
			return
		var/datum/computer_file/data/F = HDD.find_file_by_name(open_file)
		if(!F || !istype(F))
			return
		if(!computer.nano_printer)
			error = "Missing Hardware: Your computer does not have required hardware to complete this operation."
			return
		if(!computer.nano_printer.print_text(parse_tags(F.stored_data)))
			error = "Hardware error: Printer was unable to print the file. It may be out of paper."
			return
	if(href_list["PRG_copytousb"])
		var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
		if(!HDD || !RHDD)
			return
		var/datum/computer_file/F = HDD.find_file_by_name(href_list["PRG_copytousb"])
		if(!F || !istype(F))
			return
		var/datum/computer_file/C = F.clone(0)
		RHDD.store_file(C)
	if(href_list["PRG_copyfromusb"])
		var/obj/item/weapon/computer_hardware/hard_drive/HDD = computer.hard_drive
		var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD = computer.portable_drive
		if(!HDD || !RHDD)
			return
		var/datum/computer_file/F = RHDD.find_file_by_name(href_list["PRG_copyfromusb"])
		if(!F || !istype(F))
			return
		var/datum/computer_file/C = F.clone(0)
		HDD.store_file(C)
	..(href, href_list)

/datum/computer_file/program/filemanager/proc/parse_tags(var/t)
	t = replacetext(t, "\[center\]", "<center>")
	t = replacetext(t, "\[/center\]", "</center>")
	t = replacetext(t, "\[br\]", "<BR>")
	t = replacetext(t, "\[b\]", "<B>")
	t = replacetext(t, "\[/b\]", "</B>")
	t = replacetext(t, "\[i\]", "<I>")
	t = replacetext(t, "\[/i\]", "</I>")
	t = replacetext(t, "\[u\]", "<U>")
	t = replacetext(t, "\[/u\]", "</U>")
	t = replacetext(t, "\[time\]", "[worldtime2text()]")
	t = replacetext(t, "\[date\]", "[worlddate2text()]")
	t = replacetext(t, "\[large\]", "<font size=\"4\">")
	t = replacetext(t, "\[/large\]", "</font>")
	t = replacetext(t, "\[h1\]", "<H1>")
	t = replacetext(t, "\[/h1\]", "</H1>")
	t = replacetext(t, "\[h2\]", "<H2>")
	t = replacetext(t, "\[/h2\]", "</H2>")
	t = replacetext(t, "\[h3\]", "<H3>")
	t = replacetext(t, "\[/h3\]", "</H3>")
	t = replacetext(t, "\[*\]", "<li>")
	t = replacetext(t, "\[hr\]", "<HR>")
	t = replacetext(t, "\[small\]", "<font size = \"1\">")
	t = replacetext(t, "\[/small\]", "</font>")
	t = replacetext(t, "\[list\]", "<ul>")
	t = replacetext(t, "\[/list\]", "</ul>")
	t = replacetext(t, "\[table\]", "<table border=1 cellspacing=0 cellpadding=3 style='border: 1px solid black;'>")
	t = replacetext(t, "\[/table\]", "</td></tr></table>")
	t = replacetext(t, "\[grid\]", "<table>")
	t = replacetext(t, "\[/grid\]", "</td></tr></table>")
	t = replacetext(t, "\[row\]", "</td><tr>")
	t = replacetext(t, "\[tr\]", "</td><tr>")
	t = replacetext(t, "\[td\]", "<td>")
	t = replacetext(t, "\[cell\]", "<td>")
	t = replacetext(t, "\[logo\]", "<img src = ntlogo.png>")
	return t


/datum/nano_module/computer_filemanager
	name = "NTOS File Manager"

/datum/nano_module/computer_filemanager/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = default_state)

	var/datum/computer_file/program/filemanager/PRG
	var/list/data = list()
	if(program)
		data = program.get_header_data()
		PRG = program
	else
		return

	var/obj/item/weapon/computer_hardware/hard_drive/HDD
	var/obj/item/weapon/computer_hardware/hard_drive/portable/RHDD
	if(PRG.error)
		data["error"] = PRG.error
	if(PRG.open_file)
		var/datum/computer_file/data/file

		if(!PRG.computer || !PRG.computer.hard_drive)
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			HDD = PRG.computer.hard_drive
			file = HDD.find_file_by_name(PRG.open_file)
			if(!istype(file))
				data["error"] = "I/O ERROR: Unable to open file."
			else
				data["filedata"] = PRG.parse_tags(file.stored_data)
				data["filename"] = "[file.filename].[file.filetype]"
	else
		if(!PRG.computer || !PRG.computer.hard_drive)
			data["error"] = "I/O ERROR: Unable to access hard drive."
		else
			HDD = PRG.computer.hard_drive
			RHDD = PRG.computer.portable_drive
			var/list/files[0]
			for(var/datum/computer_file/F in HDD.stored_files)
				files.Add(list(list(
					"name" = F.filename,
					"type" = F.filetype,
					"size" = F.size,
					"undeletable" = F.undeletable
				)))
			data["files"] = files
			if(RHDD)
				data["usbconnected"] = 1
				var/list/usbfiles[0]
				for(var/datum/computer_file/F in RHDD.stored_files)
					usbfiles.Add(list(list(
						"name" = F.filename,
						"type" = F.filetype,
						"size" = F.size,
						"undeletable" = F.undeletable
					)))
				data["usbfiles"] = usbfiles

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "file_manager.tmpl", "NTOS File Manager", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


