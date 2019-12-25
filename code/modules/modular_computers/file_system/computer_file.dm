var/global/file_uid = 0

/datum/computer_file/
	var/filename = "NewFile" 								// Placeholder. No spacebars
	var/filetype = "XXX" 									// File full names are [filename].[filetype] so like NewFile.XXX in this case
	var/size = 1											// File size in GQ. Integers only!
	var/obj/item/weapon/stock_parts/computer/hard_drive/holder	// Holder that contains this file.
	var/unsendable = 0										// Whether the file may be sent to someone via NTNet transfer or other means.
	var/undeletable = 0										// Whether the file may be deleted. Setting to 1 prevents deletion/renaming/etc.
	var/uid													// UID of this file
	var/list/metadata											// Any metadata the file uses.
	var/papertype = /obj/item/weapon/paper

/datum/computer_file/New(var/list/md = null)
	..()
	uid = file_uid
	file_uid++
	if(islist(md))
		metadata = md.Copy()

/datum/computer_file/Destroy()
	. = ..()
	if(!holder)
		return

	holder.remove_file(src)

// Returns independent copy of this file.
/datum/computer_file/proc/clone(var/rename = 0)
	var/datum/computer_file/temp = new type
	temp.unsendable = unsendable
	temp.undeletable = undeletable
	temp.size = size
	if(metadata)
		temp.metadata = metadata.Copy()
	if(rename)
		temp.filename = filename + "(Copy)"
	else
		temp.filename = filename
	temp.filetype = filetype
	return temp