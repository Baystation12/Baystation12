/// Shuts down the computer this terminal is running on
/datum/terminal_command/shutdown
	name = "shutdown"
	man_entry = list(
		"Format: shutdown",
		"Turns the system off immediately"
	)
	pattern = "^shutdown$"

/datum/terminal_command/shutdown/proper_input_entered(text, mob/user, datum/terminal/terminal)
	terminal.computer.system_shutdown()
	qdel(terminal)
	return list()
