// /data/ files store data in string format.
// They don't contain other logic for now.
/datum/computer_file/data
	var/stored_data = "" 			// Stored data in string format.
	filetype = "DAT"
	var/block_size = 250
	var/do_not_edit = 0				// Whether the user will be reminded that the file probably shouldn't be edited.
	var/automatic_newlines = FALSE	// For text editor. Treat \n as [br] and vice versa in the text editing pop-up.

/datum/computer_file/data/clone()
	var/datum/computer_file/data/temp = ..()
	temp.stored_data = stored_data
	temp.block_size = block_size
	temp.do_not_edit = do_not_edit
	temp.automatic_newlines = automatic_newlines
	return temp

// Calculates file size from amount of characters in saved string
/datum/computer_file/data/proc/calculate_size()
	size = max(1, round(length(stored_data) / block_size))

/datum/computer_file/data/logfile
	filetype = "LOG"