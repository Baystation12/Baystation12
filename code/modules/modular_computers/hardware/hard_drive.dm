/datum/computer_hardware/hard_drive/
	name = "Hard Drive"
	desc = "A small power efficient solid state drive, with 25GQ of storage capacity for use in basic computers where power efficiency is desired."
	power_usage = 25					// SSD or something with low power usage
	var/max_capacity = 25
	var/list/stored_files = list()		// List of stored files on this drive.

/datum/computer_hardware/hard_drive/advanced
	desc = "A small hybrid hard drive with 35GQ of storage capacity for use in higher grade computers where balance between power efficiency and capacity is desired."
	max_capacity = 35
	power_usage = 50 					// Hybrid, medium capacity and medium power storage

/datum/computer_hardware/hard_drive/super
	desc = "A small hard drive with 60GQ of storage capacity for use in cluster storage solutions where capacity is more important than power efficiency."
	max_capacity = 60
	power_usage = 100					// High-capacity but uses lots of power, shortening battery life. Best used with APC link.

// Checks whether file can be stored on the hard drive.
/datum/computer_hardware/hard_drive/proc/can_store_file(var/size = 1)
	if(stored_files.len + size > max_capacity)
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