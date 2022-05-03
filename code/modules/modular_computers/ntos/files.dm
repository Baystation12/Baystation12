/// Return a list of all files, leaving out hidden files by default.
/datum/extension/interactive/ntos/proc/get_all_files(hidden = FALSE, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	. = list()
	if(istype(disk))
		if(hidden)
			return disk.stored_files
		else
			for(var/datum/computer_file/F in disk.stored_files)
				if(!F.hidden)
					. += F

/// Attempt to get the specified file. Returns null on failure.
/datum/extension/interactive/ntos/proc/get_file(filename, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(istype(disk))
		return disk.find_file_by_name(filename)

/// Attempts to create Data file. Returns file on success, otherwise null.
/datum/extension/interactive/ntos/proc/create_data_file(filename, data, file_type = /datum/computer_file/data, list/metadata, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!istype(disk))
		return
	return disk.create_data_file(filename, data, file_type, metadata)

/// Attempts to save Data file, creating it if necessary. Returns file on success, otherwise null.
/datum/extension/interactive/ntos/proc/save_data_file(filename, data, file_type = /datum/computer_file/data, list/metadata, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!istype(disk))
		return
	return disk.save_data_file(filename, data, file_type, metadata)

/// Adds date to a Data file, creating it if necessary. Enforces file type. Returns file on success, otherwise null.
/datum/extension/interactive/ntos/proc/update_data_file(filename, new_data, file_type = /datum/computer_file/data, list/metadata, replace_content = FALSE, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!istype(disk))
		return
	return disk.update_data_file(filename, new_data, file_type, metadata, replace_content)

/// Attempts to save a file object. Returns file on success, otherwise null.
/datum/extension/interactive/ntos/proc/create_file(datum/computer_file/file, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!istype(disk))
		return
	return disk.create_file(file)

/// Attempts to save a file object, replacing existing one with the same name if present. Returns file on success, otherwise null.
/datum/extension/interactive/ntos/proc/save_file(datum/computer_file/file, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!istype(disk))
		return
	return disk.save_file(file)

/// Check if the file can be created. Returns TRUE if so, otherwise FALSE.
/datum/extension/interactive/ntos/proc/try_create_file(datum/computer_file/file, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!istype(disk))
		return FALSE
	return disk.try_create_file(file)

/// Attempts to remove the specified file. Returns TRUE on success, otherwise FALSE.
/datum/extension/interactive/ntos/proc/delete_file(filename, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!istype(disk))
		return FALSE

	var/datum/computer_file/F = disk.find_file_by_name(filename)
	if(!istype(F) || F.undeletable)
		return FALSE

	return disk.remove_file(F)

/// Attempts to rename the specified file. Returns TRUE on success, otherwise FALSE.
/datum/extension/interactive/ntos/proc/rename_file(filename, filename_new, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(filename == filename_new)
		return TRUE

	if(!istype(disk))
		return FALSE

	var/datum/computer_file/F = disk.find_file_by_name(filename)
	if(!istype(F) || F.undeletable)
		return FALSE

	return disk.rename_file(F, filename_new)

/// Attempts to copy the specified file. Returns file on success, otherwise null.
/datum/extension/interactive/ntos/proc/clone_file(filename, obj/item/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	return move_file(filename, "[filename]_copy", disk, disk, TRUE)

/// Attempts to copy the specified file to another disk. Returns file on success, otherwise null.
/datum/extension/interactive/ntos/proc/copy_between_disks(filename, obj/item/stock_parts/computer/hard_drive/disk_from, obj/item/stock_parts/computer/hard_drive/disk_to)
	return move_file(filename, filename, disk_from, disk_to, TRUE)

/// Attempts to move or copy the specified file, potentially between disks, and renaming it in the process if necessary
/datum/extension/interactive/ntos/proc/move_file(filename, filename_new, obj/item/stock_parts/computer/hard_drive/disk_from, obj/item/stock_parts/computer/hard_drive/disk_to, copy = FALSE)
	if(!istype(disk_from) || !istype(disk_to))
		return

	var/datum/computer_file/F = disk_from.find_file_by_name(filename)
	if(!istype(F) || F.undeletable)
		return

	if(disk_from == disk_to && F.filename == filename_new)
		return F // We don't need to do anything

	var/datum/computer_file/FC = F.clone()
	if(FC.filename != filename_new)
		FC.filename = filename_new
	FC = disk_to.create_file(FC)
	if(FC && !copy) // Failure to remove the old file is not considered critical
		disk_from.remove_file(F)
	return FC