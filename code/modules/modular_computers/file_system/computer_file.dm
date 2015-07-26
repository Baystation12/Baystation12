/datum/computer_file/
	var/filename = "NewFile" 						// Placeholder. No spacebars
	var/filetype = "XXX" 							// File full names are [filename].[filetype] so like NewFile.XXX in this case
	var/size = 1									// File size in GQ. Integers only!
	var/datum/computer_hardware/hard_drive/holder	// Holder that contains this file.
	var/unsendable = 0								// Whether the file may be sent to someone via NTNet transfer or other means.
	var/undeletable = 0								// Whether the file may be deleted. Setting to 1 prevents deletion/renaming/etc.

/datum/computer_file/Destroy()
	if(!holder)
		return ..()

	holder.stored_files -= src
	// holder.holder is the computer that has drive installed. If we are Destroy()ing program that's currently running kill it.
	if(holder.holder && holder.holder.active_program == src)
		holder.holder.kill_program(1)
	holder = null
	..()

// Returns independent copy of this file.
/datum/computer_file/proc/clone()
	var/datum/computer_file/temp
	temp.unsendable = unsendable
	temp.undeletable = undeletable
	temp.size = size
	temp.filename = filename + "(Copy)"
	temp.filetype = filetype
	return temp