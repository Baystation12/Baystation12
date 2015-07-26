/datum/computer_hardware/hard_drive/
	name = "Hard Drive"
	desc = "A small power efficient solid state drive, with 128GQ of storage capacity for use in basic computers where power efficiency is desired."
	power_usage = 25					// SSD or something with low power usage
	var/max_capacity = 128
	var/used_capacity = 0
	var/list/stored_files = list()		// List of stored files on this drive. DO NOT MODIFY DIRECTLY!

/datum/computer_hardware/hard_drive/advanced
	desc = "A small hybrid hard drive with 256GQ of storage capacity for use in higher grade computers where balance between power efficiency and capacity is desired."
	max_capacity = 256
	power_usage = 50 					// Hybrid, medium capacity and medium power storage

/datum/computer_hardware/hard_drive/super
	desc = "A small hard drive with 512GQ of storage capacity for use in cluster storage solutions where capacity is more important than power efficiency."
	max_capacity = 512
	power_usage = 100					// High-capacity but uses lots of power, shortening battery life. Best used with APC link.

/datum/computer_hardware/hard_drive/cluster
	desc = "A large storage cluster consisting of multiple hard drives for usage in high capacity storage systems. Has capacity of 2048 GQ."
	power_usage = 500
	max_capacity = 2048

// For tablets, etc. - highly power efficient.
/datum/computer_hardware/hard_drive/small
	desc = "A small highly efficient solid state drive for portable devices."
	power_usage = 10
	max_capacity = 64

/datum/computer_hardware/hard_drive/micro
	desc = "A small micro hard drive for portable devices."
	power_usage = 2
	max_capacity = 32

// Use this proc to add file to the drive. Returns 1 on success and 0 on failure. Contains necessary sanity checks.
/datum/computer_hardware/hard_drive/proc/store_file(var/datum/computer_file/F)
	if(!F || !istype(F))
		return 0

	if(!can_store_file(F.size))
		return 0

	if(!stored_files)
		return 0

	// This file is already stored. Don't store it again.
	if(F in stored_files)
		return 0

	stored_files.Add(F)
	recalculate_size()
	return 1

// Use this proc to remove file from the drive. Returns 1 on success and 0 on failure. Contains necessary sanity checks.
/datum/computer_hardware/hard_drive/proc/remove_file(var/datum/computer_file/F)
	if(!F || !istype(F))
		return 0

	if(!stored_files)
		return 0

	if(F in stored_files)
		stored_files -= F
		recalculate_size()
		return 1
	else
		return 0

// Loops through all stored files and recalculates used_capacity of this drive
/datum/computer_hardware/hard_drive/proc/recalculate_size()
	var/total_size = 0
	for(var/datum/computer_file/F in stored_files)
		total_size = F.size

	used_capacity = total_size

// Checks whether file can be stored on the hard drive.
/datum/computer_hardware/hard_drive/proc/can_store_file(var/size = 1)
	// In the unlikely event someone manages to create that many files.
	// BYOND is acting weird with numbers above 999 in loops (infinite loop prevention)
	if(stored_files.len >= 999)
		return 0
	if(used_capacity + size > max_capacity)
		return 0
	else
		return 1

// Tries to find the file by filename. Returns null on failure
/datum/computer_hardware/hard_drive/proc/find_file_by_name(var/filename)
	if(!filename)
		return null

	if(!stored_files)
		return null

	for(var/datum/computer_file/F in stored_files)
		if(F.filename == filename)
			return F
	return null

/datum/computer_hardware/hard_drive/Destroy()
	if(holder && (holder.hard_drive == src))
		holder.hard_drive = null
	if(holder2 && (holder2.hard_drive == src))
		holder2.hard_drive = null
	stored_files = null
	..()