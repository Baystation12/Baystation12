/// Shows and manipulates programs running on the computer
/datum/terminal_command/prog
	name = "prog"
	man_entry = list(
		"Format: prog \[-flag pid|filename\]",
		"Without options, list all programs currently running.",
		"With -f followed by pid (number), toggle the program between running in foreground or background.",
		"With -k and no further arguments, terminates all running programs.",
		"With -k followed by pid (number), terminates the specified program.",
		"With -x followed by filename, attempt to execute filename as a program.",
		"With -a and no further arguments, clears the autorun setting.",
		"With -a followed by filename, set autorun to use the specified filename.",
		"NOTICE: Programs are executed using access credentials of the original terminal session."
	)
	pattern = "^prog"
	skill_needed = SKILL_ADEPT

/datum/terminal_command/prog/proper_input_entered(text, mob/user, datum/terminal/terminal)
	. = syntax_error()
	var/list/arguments = get_arguments(text)
	if(isnull(arguments))
		return
	// Program list
	if(!arguments.len)
		. = list()
		. += "[name]: Listing running programs..."
		. += "PID Status Filename"
		for(var/datum/computer_file/program/P in terminal.computer.running_programs)
			if(P.program_state)
				. += "[P.uid] - [(P.program_state == PROGRAM_STATE_ACTIVE ? "active" : "bckgrn")] - [P.filename]"
		. += ""
	// Run command with flag only
	else if(arguments.len == 1)
		if(arguments[1] == "-k")
			for(var/datum/computer_file/program/P in terminal.computer.running_programs)
				terminal.computer.kill_program_remote(P, 1)
			return "[name]: All running programs terminated."
		else if(arguments[1] == "-a")
			if(!terminal.computer.set_autorun(null))
				return "[name]: Error; could not modify autorun data."
			return "[name]: Autorun disabled"
	// Run command on a pid or filename
	else if(arguments.len == 2)
		if(arguments[1] == "-f")
			var/datum/computer_file/program/P = get_program_by_pid(arguments[2], terminal)
			if(!istype(P))
				return "[name]: Error; invalid pid."
			(P.program_state == PROGRAM_STATE_ACTIVE ? terminal.computer.minimize_program() : terminal.computer.activate_program(P))
			return "[name]: Program focus toggled."
		else if(arguments[1] == "-k")
			var/datum/computer_file/program/P = get_program_by_pid(arguments[2], terminal)
			if(!istype(P))
				return "[name]: Error; invalid pid."
			terminal.computer.kill_program_remote(P, 1)
			return "[name]: Program [P.filename] terminated."
		else if(arguments[1] == "-x")
			var/datum/computer_file/program/P = terminal.computer.run_program_remote(arguments[2], user, 0)
			if(!istype(P))
				return "[name]: Error; unable to execute program '[arguments[2]]'."
			return "[name]: Program '[P.filename]' running with pid [P.uid]."
		else if(arguments[1] == "-a")
			if(!terminal.computer.set_autorun(arguments[2]))
				return "[name]: Error; could not modify autorun data."
			return "[name]: Autorun updated to '[arguments[2]]'"

/datum/terminal_command/prog/proc/get_program_by_pid(pid, datum/terminal/terminal)
	pid = text2num(pid)
	if(!pid)
		return
	for(var/datum/computer_file/program/P in terminal.computer.running_programs)
		if(P.uid == pid && P.program_state)
			return P
