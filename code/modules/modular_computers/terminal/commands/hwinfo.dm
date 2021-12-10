/// Show information about the hardware on the computer
/datum/terminal_command/hwinfo
	name = "hwinfo"
	man_entry = list(
		"Format: hwinfo \[name\]",
		"If no device specified, lists hardware.",
		"If device is specified by name, runs diagnostic tests."
	)
	pattern = "^hwinfo"
	skill_needed = SKILL_ADEPT

/datum/terminal_command/hwinfo/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/command = copytext_char(text, 1, length(name) + 2)
	if(command != name && command != "[name] ")
		return syntax_error()

	var/argument = copytext_char(text, length(name) + 2, 0)
	if(!argument)
		. = list("[name]: Hardware Detected:")
		for(var/obj/item/stock_parts/computer/ch in  terminal.computer.get_all_components())
			. += ch.name
		return
	else
		var/obj/item/stock_parts/computer/ch = terminal.computer.find_hardware_by_name(argument)
		if(!ch)
			return "[name]: No such hardware found."
		. = list("[name]: Running diagnostic protocols...")
		. += "Device type: [ch.name]"
		. += ch.diagnostics()
		return
