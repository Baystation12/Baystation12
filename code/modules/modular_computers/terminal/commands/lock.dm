/// Toggles storage devices being read-only
/datum/terminal_command/lock
	name = "lock"
	man_entry = list(
		"Format: lock \[did\]",
		"Lists storage devices, or toggle read-only flag on storage device specified by device id.",
		"For example, 'lock R' will toggle read-only mode on the device mounted on R:.",
		"WARNING: All files on affected device will be read-only, and new files cannot be created."
	)
	pattern = "^lock"
	skill_needed = SKILL_ADEPT

/datum/terminal_command/lock/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/arguments = get_arguments(text)
	if(isnull(arguments))
		return syntax_error()
	var/list/drives = list(
		"C" = terminal.computer.get_component(PART_HDD),
		"R" = terminal.computer.get_component(PART_DRIVE)
	)
	if(!istype(drives["C"], /obj/item/stock_parts/computer/hard_drive))
		return "[name]: Error; hard drive not found."
	. = syntax_error()
	var/obj/item/stock_parts/computer/hard_drive/D
	if(!arguments.len)
		. = list()
		. += "[name]: Listing storage device status..."
		for(var/did in drives)
			D = drives[did]
			if(!istype(D))
				continue
			. += ""
			. += "** Device mounted on device id [did]: **"
			. += D.diagnostics()
	else if(arguments.len == 1)
		if(length(arguments[1]) != 1)
			return
		D = drives[arguments[1]]
		if(!istype(D))
			return "[name]: Error; invalid device id.";
		D.read_only = D.read_only ? FALSE : TRUE
		return "[name]: Read-only mode on [arguments[1]] is now [D.read_only ? "enabled" : "disabled"]."
