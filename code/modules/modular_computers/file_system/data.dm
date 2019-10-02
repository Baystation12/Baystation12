// /data/ files store data in string format.
// They don't contain other logic for now.
/datum/computer_file/data
	var/stored_data = "" 			// Stored data in string format.
	filetype = "DAT"
	var/block_size = 250
	var/do_not_edit = 0				// Whether the user will be reminded that the file probably shouldn't be edited.
	var/original_data

/datum/computer_file/data/clone()
	var/datum/computer_file/data/temp = ..()
	temp.stored_data = stored_data
	temp.original_data = original_data
	return temp

/datum/computer_file/data/proc/data_integrity()
	return original_data == stored_data

// Calculates file size from amount of characters in saved string
/datum/computer_file/data/proc/calculate_size()
	size = max(1, round(length(stored_data) / block_size))

/datum/computer_file/data/logfile
	filetype = "LOG"