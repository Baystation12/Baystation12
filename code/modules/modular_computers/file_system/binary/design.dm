// Autolathe design file
/datum/computer_file/binary/design
	filetype = "CD" // Construction Design
	size = 4
	var/datum/design/design = null
	var/copy_protected = FALSE

/datum/computer_file/binary/design/clone()
	var/datum/computer_file/binary/design/F = ..()
	F.design = design
	F.copy_protected = copy_protected
	return F

/datum/computer_file/binary/design/proc/set_filename(new_name)
	filename = sanitizeFileName("[new_name]")
	if(findtext(filename, "datum_design_") == 1)
		filename = copytext(filename, 14)

/datum/computer_file/binary/design/proc/set_design_type(design_type)
	set_filename(design_type)
	design = design_type // Temporarily assign that to pass the type down into research controller
	SSresearch.initialize_design_file(src)

/datum/computer_file/binary/design/proc/on_design_set()
	set_filename(design.id)

/datum/computer_file/binary/design/proc/set_copy_protection(enabled)
	copy_protected = enabled

	if(copy_protected)
		filetype = "SCD" // Secure Construction Design
	else
		filetype = "CD"

/datum/computer_file/binary/design/proc/check_license()
	if(!copy_protected)
		return TRUE

	var/obj/item/weapon/computer_hardware/hard_drive/portable/disk = holder
	if(!istype(disk) || disk.license <= 0)
		return FALSE

	return TRUE


/datum/computer_file/binary/design/proc/use_license()
	if(!check_license())
		return FALSE

	if(!copy_protected)
		return TRUE

	var/obj/item/weapon/computer_hardware/hard_drive/portable/disk = holder
	disk.license -= 1
	return TRUE


/datum/computer_file/binary/design/ui_data()
	var/list/data = design.ui_data().Copy()
	data["copy_protected"] = copy_protected
	data["filename"] = filename
	return data
