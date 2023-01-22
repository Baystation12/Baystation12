/**
  * Important! Avoid editing the content of file objects already saved on a disk,
  * as this bypasses checks for anything that might prevent saving. Instead,
  * clone the file, make the changes to the clone, and attempt to save the clone
  * with the same filename using save_file(). Additional useful procs for data
  * files in particular are also available.
  */
/obj/item/stock_parts/computer/hard_drive
	name = "basic hard drive"
	desc = "A small power efficient solid state drive, with 128GQ of storage capacity for use in basic computers where power efficiency is desired."
	power_usage = 25
	icon_state = "hdd_normal"
	hardware_size = 1
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)

	var/max_capacity = 128
	var/used_capacity = 0
	/// List of stored files on this drive. DO NOT MODIFY DIRECTLY!
	var/list/stored_files = list()
	/// Whether drive is protected against changes
	var/read_only = FALSE

/obj/item/stock_parts/computer/hard_drive/advanced
	name = "advanced hard drive"
	desc = "A small hybrid hard drive with 256GQ of storage capacity for use in higher grade computers where balance between power efficiency and capacity is desired."
	max_capacity = 256
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	power_usage = 50
	icon_state = "hdd_advanced"
	hardware_size = 2

/obj/item/stock_parts/computer/hard_drive/super
	name = "super hard drive"
	desc = "A small hard drive with 512GQ of storage capacity for use in cluster storage solutions where capacity is more important than power efficiency."
	max_capacity = 512
	origin_tech = list(TECH_DATA = 3, TECH_ENGINEERING = 3)
	power_usage = 100
	icon_state = "hdd_super"
	hardware_size = 2

/obj/item/stock_parts/computer/hard_drive/cluster
	name = "cluster hard drive"
	desc = "A large storage cluster consisting of multiple hard drives for usage in high capacity storage systems. Has capacity of 2048 GQ."
	power_usage = 500
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)
	max_capacity = 2048
	icon_state = "hdd_cluster"
	hardware_size = 3

/obj/item/stock_parts/computer/hard_drive/small
	name = "small hard drive"
	desc = "A small highly efficient solid state drive for portable devices."
	power_usage = 10
	origin_tech = list(TECH_DATA = 2, TECH_ENGINEERING = 2)
	max_capacity = 64
	icon_state = "hdd_small"
	hardware_size = 1

/obj/item/stock_parts/computer/hard_drive/micro
	name = "micro hard drive"
	desc = "A small micro hard drive for portable devices."
	power_usage = 2
	origin_tech = list(TECH_DATA = 1, TECH_ENGINEERING = 1)
	max_capacity = 32
	icon_state = "hdd_micro"
	hardware_size = 1

/obj/item/stock_parts/computer/hard_drive/Initialize()
	. = ..()
	install_default_programs()
	recalculate_size()

/obj/item/stock_parts/computer/hard_drive/diagnostics()
	. = ..()
	// 999 is a byond limit that is in place. It's unlikely someone will reach that many files anyway, since you would sooner run out of space.
	. += "NT-NFS File Table Status: [stored_files.len]/999"
	. += "Storage capacity: [used_capacity]/[max_capacity]GQ"
	. += "Read-only mode: [(read_only ? "ON" : "OFF")]"

/// Tries to find the file by filename. Returns null on failure
/obj/item/stock_parts/computer/hard_drive/proc/find_file_by_name(filename)
	if(!filename)
		return
	if(!check_functionality())
		return
	for(var/datum/computer_file/F in stored_files)
		if(F.filename == filename)
			return F

/// Use this proc to add Data file to the drive.
/obj/item/stock_parts/computer/hard_drive/proc/create_data_file(filename, data, file_type = /datum/computer_file/data, list/metadata)
	if(!filename)
		return

	var/datum/computer_file/data/F = new file_type(md = metadata)
	F.filename = filename
	F.stored_data = data
	F.calculate_size()
	return create_file(F)

/// Use this proc to save Data file to the drive.
/obj/item/stock_parts/computer/hard_drive/proc/save_data_file(filename, data, file_type = /datum/computer_file/data, list/metadata)
	if(!filename)
		return

	var/datum/computer_file/data/EF = find_file_by_name(filename)
	if(!istype(EF))
		return create_data_file(filename, data, file_type, metadata)

	if(EF.read_only)
		return

	EF = EF.clone()
	EF.stored_data = data
	EF.metadata = metadata && metadata.Copy()
	EF.calculate_size()
	return save_file(EF)

/// Use this proc to add data to a Data file on the drive. Unlike using save_data_file directly, this enforces exact file type match with existing file
/obj/item/stock_parts/computer/hard_drive/proc/update_data_file(filename, new_data, file_type = /datum/computer_file/data, list/metadata, replace_content = FALSE)
	if(!filename || !new_data)
		return

	var/datum/computer_file/data/F = find_file_by_name(filename)
	if(!istype(F, file_type))
		return create_data_file(filename, new_data, file_type, metadata)
	else if(F.type != file_type)
		return
	else
		return save_data_file(filename, (replace_content ? new_data : F.stored_data + new_data), file_type, metadata)

/// Use this proc to add file to the drive. Contains necessary sanity checks.
/obj/item/stock_parts/computer/hard_drive/proc/create_file(datum/computer_file/F)
	if(!try_create_file(F))
		return
	F.holder = src
	stored_files += F
	recalculate_size()
	return F

/// Use this proc to add file or update it if it already exists. Contains necessary sanity checks.
/obj/item/stock_parts/computer/hard_drive/proc/save_file(datum/computer_file/F)
	var/datum/computer_file/EF = find_file_by_name(F.filename)
	if(!istype(EF))
		return create_file(F)

	if(!can_write_file(F))
		return
	if(!can_store_file(F.size, EF.size))
		return
	if(F in stored_files)
		return

	EF.holder = null
	stored_files -= EF
	F.holder = src
	stored_files += F
	recalculate_size()
	return F

/// Use this proc to remove file from the drive. Contains necessary sanity checks.
/obj/item/stock_parts/computer/hard_drive/proc/remove_file(datum/computer_file/F)
	. = FALSE
	if(!can_write_file(F))
		return
	if(!(F in stored_files))
		return

	F.holder = null
	stored_files -= F
	recalculate_size()
	return TRUE

/// Use this proc to rename file on the drive. Contains necessary sanity checks.
/obj/item/stock_parts/computer/hard_drive/proc/rename_file(datum/computer_file/F, filename_new)
	. = FALSE
	if(!can_write_file(F))
		return
	if(!validate_name(filename_new))
		return

	var/datum/computer_file/EF = find_file_by_name(filename_new)
	if(istype(EF))
		return

	F.filename = filename_new
	return TRUE

/// Use this proc to check if the file can be created.
/obj/item/stock_parts/computer/hard_drive/proc/try_create_file(datum/computer_file/F)
	. = FALSE
	if(!can_write_file(F))
		return
	if(!can_store_file(F.size))
		return
	if(!validate_name(F.filename))
		return
	if(F in stored_files)
		return

	var/datum/computer_file/EF = find_file_by_name(F.filename)
	if(istype(EF))
		return

	return TRUE

/// Loops through all stored files and recalculates used_capacity of this drive
/obj/item/stock_parts/computer/hard_drive/proc/recalculate_size()
	var/total_size = 0
	for(var/datum/computer_file/F in stored_files)
		total_size += F.size
	used_capacity = total_size

/// Checks whether there is space to store file on the hard drive.
/obj/item/stock_parts/computer/hard_drive/proc/can_store_file(size = 1, replaced_size = 0)
	// In the unlikely event someone manages to create that many files.
	// BYOND is acting weird with numbers above 999 in loops (infinite loop prevention)
	if(stored_files.len >= 999)
		return FALSE
	if(used_capacity + size - replaced_size > max_capacity)
		return FALSE
	return TRUE

/// Checks whether the file can be written to the drive.
/obj/item/stock_parts/computer/hard_drive/proc/can_write_file(datum/computer_file/F)
	if(!istype(F))
		return FALSE
	if(!check_functionality())
		return FALSE
	if(read_only)
		return FALSE
	return TRUE

/// Validates filename
/obj/item/stock_parts/computer/hard_drive/proc/validate_name(filename)
	var/list/badchars = list("/","\\",":","*","?","\"","<",">","|","#",".",","," ")
	for(var/char in badchars)
		if(findtext(filename, char))
			return FALSE
	return TRUE

/obj/item/stock_parts/computer/hard_drive/check_functionality()
	return (..() && stored_files)

/// Installs default programs on the drive
/obj/item/stock_parts/computer/hard_drive/proc/install_default_programs()
	create_file(new/datum/computer_file/program/computerconfig(src)) 		// Computer configuration utility, allows hardware control and displays more info than status bar
	create_file(new/datum/computer_file/program/ntnetdownload(src))			// NTNet Downloader Utility, allows users to download more software from NTNet repository
	create_file(new/datum/computer_file/program/filemanager(src))			// File manager, allows text editor functions and basic file manipulation.

/obj/item/stock_parts/computer/hard_drive/Destroy()
	stored_files = null
	return ..()

