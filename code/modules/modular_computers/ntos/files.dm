/datum/extension/interactive/ntos/proc/get_all_files(var/obj/item/weapon/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	. = list()
	if(disk)
		return disk.stored_files

/datum/extension/interactive/ntos/proc/get_file(filename, var/obj/item/weapon/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(disk)
		return disk.find_file_by_name(filename)

/datum/extension/interactive/ntos/proc/create_file(var/newname, var/data, var/file_type = /datum/computer_file/data, var/list/metadata, var/obj/item/weapon/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!newname)
		return
	if(!disk)
		return
	if(get_file(newname))
		return
	
	var/datum/computer_file/data/F = new file_type(md = metadata)
	F.filename = newname
	F.stored_data = data
	F.calculate_size()
	if(disk.store_file(F))
		return F

/datum/extension/interactive/ntos/proc/store_file(var/datum/computer_file/file, var/obj/item/weapon/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE
	var/datum/computer_file/data/old_version = disk.find_file_by_name(file.filename)
	if(old_version)
		disk.remove_file(old_version)
	if(!disk.store_file(file))
		disk.store_file(old_version)
		return FALSE
	else
		return TRUE

/datum/extension/interactive/ntos/proc/try_store_file(var/datum/computer_file/file, var/obj/item/weapon/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE
	return disk.try_store_file(file)

/datum/extension/interactive/ntos/proc/save_file(var/newname, var/data, var/file_type = /datum/computer_file/data, var/list/metadata, var/obj/item/weapon/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE
	var/datum/computer_file/data/F = disk.find_file_by_name(newname)
	if(!F) //try to make one if it doesn't exist
		return !!create_file(newname, data, file_type, metadata, disk)

	//Try to save file, possibly won't fit size-wise
	var/datum/computer_file/data/backup = F.clone()
	disk.remove_file(F)
	F.stored_data = data
	F.metadata = metadata && metadata.Copy()
	F.calculate_size()
	if(!disk.store_file(F))
		disk.store_file(backup)
		return FALSE
	return TRUE

/datum/extension/interactive/ntos/proc/delete_file(var/filename, var/obj/item/weapon/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE

	var/datum/computer_file/F = disk.find_file_by_name(filename)
	if(!F || F.undeletable)
		return FALSE

	return disk.remove_file(F)
	
/datum/extension/interactive/ntos/proc/clone_file(var/filename, var/obj/item/weapon/stock_parts/computer/hard_drive/disk = get_component(PART_HDD))
	if(!disk)
		return FALSE

	var/datum/computer_file/F = disk.find_file_by_name(filename)
	if(!F)
		return FALSE

	var/datum/computer_file/C = F.clone(1)

	return disk.store_file(C)

/datum/extension/interactive/ntos/proc/copy_between_disks(var/filename, var/obj/item/weapon/stock_parts/computer/hard_drive/disk_from, var/obj/item/weapon/stock_parts/computer/hard_drive/disk_to)
	if(!istype(disk_from) || !istype(disk_to))
		return FALSE

	var/datum/computer_file/F = disk_from.find_file_by_name(filename)
	if(!istype(F))
		return FALSE
	var/datum/computer_file/C = F.clone(0)
	return disk_to.store_file(C)