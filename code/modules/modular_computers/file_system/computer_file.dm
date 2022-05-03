var/global/file_uid = 0

/datum/computer_file
	/// Placeholder. Whitespace and most special characters are not allowed.
	var/filename = "NewFile"
	/// File full names are [filename].[filetype] so like NewFile.XXX in this case
	var/filetype = "XXX"
	/// File size in GQ. Integers only!
	var/size = 1
	/// Holder that contains this file.
	var/obj/item/stock_parts/computer/hard_drive/holder
	/// Whether the file may be sent to someone via NTNet transfer, email or other means.
	var/unsendable = FALSE
	/// Whether the file may be deleted. Setting to TRUE prevents deletion/renaming/etc.
	var/undeletable = FALSE
	/// Whether the file is hidden from view in the OS
	var/hidden = FALSE
	/// Protects files that should never be edited by the user due to special properties.
	var/read_only = FALSE
	/// UID of this file
	var/uid
	/// Any metadata the file uses.
	var/list/metadata
	/// Paper type to use for printing
	var/papertype = /obj/item/paper

/datum/computer_file/New(list/md = null)
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

/// Returns independent copy of this file.
/datum/computer_file/proc/clone()
	var/datum/computer_file/temp = new type
	temp.unsendable = unsendable
	temp.undeletable = undeletable
	temp.hidden = hidden
	temp.size = size
	if(metadata)
		temp.metadata = metadata.Copy()
	temp.filename = filename
	temp.filetype = filetype
	return temp
