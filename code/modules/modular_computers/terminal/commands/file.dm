/// Terminal file management
/datum/terminal_command/file
	name = "file"
	man_entry = list(
		"Format: file \[-flag filename \[filename2\]\]",
		"Without options, list all files on storage devices.",
		"With -h followed by filename, toggle the hidden flag on the file.",
		"With -r followed by filename, remove the file.",
		"With -m followed by filename and filename2, move or rename the file to the second filename",
		"With -c followed by filename and filename2, copy the file to the second filename",
		"If multiple storage devices are present, files on a specific device can be accessed by prefixing the filename with the device id. For example, the command 'file -m R:original C:result' would move a file with the name 'original' on the external storage device to the internal hard drive and rename it to 'result'. If no prefix is used, C: is assumed."
	)
	pattern = "^file"

/datum/terminal_command/file/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/arguments = get_arguments(text)
	if(isnull(arguments))
		return syntax_error()
	var/list/drives = list(
		"C" = terminal.computer.get_component(PART_HDD),
		"R" = terminal.computer.get_component(PART_DRIVE)
	)
	if(!istype(drives["C"], /obj/item/stock_parts/computer/hard_drive))
		return "[name]: Error; hard drive not found."
	. = syntax_error()
	// File list
	if(!arguments.len)
		. = list()
		. += "[name]: Listing data storage content..."
		. += output_file_list(drives, terminal.history_max_length - 5)
	// Run command with one filename
	else if(arguments.len == 2)
		var/list/source = get_file_location(drives, arguments[2])
		if(!source)
			return "[name]: Error; unable to resolve filename."
		if(arguments[1] == "-h")
			var/datum/computer_file/F = terminal.computer.get_file(source["name"], source["drive"])
			if(!istype(F))
				return "[name]: Error; could not find file '[source["name"]]'."
			var/obj/item/stock_parts/computer/hard_drive/D = source["drive"]
			if(D.read_only)
				return "[name]: Error; could not modify attribute for file '[source["name"]]'."
			F.hidden = F.hidden ? FALSE : TRUE
			return "[name]: File '[source["name"]]' set to be [(F.hidden ? "in" : "")]visible.";
		else if(arguments[1] == "-r")
			if(!terminal.computer.delete_file(source["name"], source["drive"]))
				return "[name]: Error; could not delete file '[source["name"]]'."
			return "[name]: File deleted."
	// Run command with two filenames
	else if(arguments.len == 3)
		var/list/source = get_file_location(drives, arguments[2])
		if(!source)
			return "[name]: Error; unable to resolve filename."
		var/list/destination = get_file_location(drives, arguments[3])
		if(!destination)
			return "[name]: Error; unable to resolve filename2."
		if(arguments[1] == "-m")
			if(!terminal.computer.move_file(source["name"], destination["name"], source["drive"], destination["drive"]))
				return "[name]: Error; could not move the file '[source["name"]]'."
			return "[name]: File moved."
		else if(arguments[1] == "-c")
			if(!terminal.computer.move_file(source["name"], destination["name"], source["drive"], destination["drive"], TRUE))
				return "[name]: Error; could not copy the file '[source["name"]]'."
			return "[name]: File copied."

/datum/terminal_command/file/proc/output_file_list(list/drives, max_lines)
	var/list/O = list()
	for(var/did in drives)
		var/obj/item/stock_parts/computer/hard_drive/D = drives[did]
		if(!istype(D))
			continue
		O += ""
		O += "** Files on storage device [did]: ([D.used_capacity]GQ used out of [D.max_capacity]GQ) **"
		O += "Flags Type Size Name"
		// It's thematically appropriate for the command to bypass the abstraction
		// of NTOS and access the hardware directly instead.
		if(!D.stored_files.len)
			O += "No files found on device."
		else
			var/i = 0
			for(var/datum/computer_file/F in D.stored_files)
				if(O.len >= max_lines) // There's a line limit in the terminal, so if we approach it, break off and just list number of files on the drives.
					O += ".. [(D.stored_files.len - i)] additional files."
					break
				var/flags = "+[(F.hidden ? "h" : "")][(F.read_only ? "r" : "rw")]"
				O += "[flags] [F.filetype] [F.size]GQ [F.filename]"
				i++
	return O

/datum/terminal_command/file/proc/get_file_location(list/drives, text)
	var/list/pieces = splittext(text, ":")
	if(!pieces.len)
		return
	var/obj/item/stock_parts/computer/hard_drive/D
	var/name
	if(pieces.len == 1)
		D = drives["C"]
		name = pieces[1]
	else if(pieces.len == 2)
		D = drives[pieces[1]]
		name = pieces[2]
	else
		return
	if(name && istype(D))
		return list("name" = name, "drive" = D)
