/datum/computer_file
	var/name = "data.dat"                    // Identifying string.
	var/file_type = IS_FILE                  // I kinda wish BYOND did enums.
	var/permissions = 0                      // Bitflags for tracking access permissions for this file.
	var/file_contents = "EMPTY"              // Literal contents of file. Raw text.
	var/obj/machinery/terminal/holder        // Computer that the file is stored on.
	var/datum/computer_file/directory/parent // Next directory up the chain from this one.

/datum/computer_file/New(var/obj/machinery/terminal/new_holder, var/new_name, var/datum/computer_file/directory/new_parent, var/permission_level)
	if(new_holder)
		holder = new_holder
	if(new_parent)
		parent = new_parent
	if(new_name)
		name = new_name
	if(permission_level)
		permissions = permission_level

/datum/computer_file/proc/copy_file()
	var/datum/computer_file/new_file = new type (null,null,null)
	new_file.file_type = file_type
	new_file.file_contents = file_contents
	new_file.permissions = permissions
	return new_file

/datum/computer_file/proc/write_contents(var/data)
	file_contents = "[data]"

/datum/computer_file/directory
	name = "dir"
	file_type = IS_DIRECTORY
	var/list/contents = list()

/datum/computer_file/directory/copy_file()
	var/datum/computer_file/directory/new_dir = ..()
	for(var/file in contents)
		var/datum/computer_file/tar_file = contents[file]
		var/datum/computer_file/copied_file = tar_file.copy_file()
		copied_file.name = tar_file.name
		new_dir.add_file(copied_file)
	return new_dir

/datum/computer_file/directory/write_contents()
	holder.terminal_output("write error: target is a directory.")

/datum/computer_file/directory/proc/get_path()
	var/dir_path = ((name=="root") ? "/" : "[name]/")
	if(parent)
		dir_path = "[parent.get_path()][dir_path]"
	return dir_path

/datum/computer_file/directory/proc/add_file(var/datum/computer_file/new_file)
	//Todo check user write permission for this directory
	if(contents[new_file.name])
		del(contents[new_file.name])
	contents[new_file.name] = new_file

/obj/machinery/terminal/proc/get_file(var/file_name, var/needs_file_type, var/datum/computer_file/directory/target_dir)
	if(!target_dir)
		target_dir = current_dir
	var/list/file_path = text2list(file_name,"/")
	var/i = 0
	var/datum/computer_file/file
	for(var/token in file_path)
		i++
		if(token == "..")
			if(target_dir.parent)
				target_dir = target_dir.parent
			else
				file = null
				break
		else
			file = target_dir.contents[token]
			if(!file)
				file = null
				break
			else if(file.file_type == IS_DIRECTORY)
				target_dir = file
			else
				if(i < file_path.len)
					file = null
					break

	if(!file)
		terminal_output("read error: '[file_name]' not found.")
	else if(needs_file_type && file.file_type != needs_file_type)
		var/file_type = "valid file"
		switch(needs_file_type)
			if(IS_DIRECTORY)
				file_type = "directory"
			if(IS_FILE)
				file_type = "file"
			if(IS_PROGRAM)
				file_type = "executable"
		terminal_output("read error: '[file_name]' is not a [file_type].")
	else
		return file