/obj/machinery/terminal/auth_server
	name = "authentication server"

/obj/machinery/terminal/auth_server/New()
	..()
	program_dir.add_file(new /datum/computer_file/program/authentication(src,null,program_dir))

/obj/machinery/terminal/auth_server/terminal_startup()
	..()
	var/datum/computer_file/program/command = get_file("authdaemon",IS_PROGRAM,program_dir)
	if(command)
		command.execute_program(list(),src)

// Passively running programs for network authentication terminals here.
/datum/computer_file/program/authentication
	name = "authdaemon"

/datum/computer_file/program/authentication/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		holder.terminal_output("Authentication daemon launched.")
	return pid

/datum/computer_file/program/authentication/process()
	holder.terminal_output("Authentication program ticking.")

/datum/computer_file/program/authentication/terminate_program()
	holder.terminal_output("Authentication program terminating.")
	..()