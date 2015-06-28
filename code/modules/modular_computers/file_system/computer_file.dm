/datum/computer_file/
	var/filename = "NewFile" 						// Placeholder. No spacebars
	var/filetype = "XXX" 							// File full names are [filename].[filetype] so like NewFile.XXX in this case
	var/size = 1									// File size in GQ (default 1, do not change unless you really have to). Non-1 values are currently unused but they should be supported.
	var/datum/computer_hardware/hard_drive/holder	// Holder that contains this file.
	var/icon_path = null							// !!32x32!! icon of this program


/datum/computer_file/Destroy()
	if(!holder)
		return ..()

	holder.stored_files -= src
	// holder.holder is the computer that has drive installed. If we are Destroy()ing program that's currently running kill it.
	if(holder.holder && holder.holder.active_program == src)
		holder.holder.kill_program(1)
	holder = null
	..()
