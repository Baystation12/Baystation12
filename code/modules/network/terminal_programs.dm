/datum/computer_file/program
	file_contents = "BINARY"
	file_type = IS_PROGRAM
	var/operands = 0
	var/default_port
	var/processor_cost = 1
	var/program_state = 0

/datum/computer_file/program/write_contents()
	holder.terminal_output("write error: target is a binary file.")

/datum/computer_file/program/proc/execute_program(var/list/args)
	if(args.len <= operands)
		holder.terminal_output("[name]: missing operand")
		return 0

	var/pid = holder.get_pid()

	if(default_port)
		holder.bind_port(default_port,src)

	if(pid)
		program_state = IS_RUNNING
		return pid
	else
		holder.terminal_output("[name]: could not obtain pid, terminating")

/datum/computer_file/program/proc/process()
	program_state = IS_TERMINATING
	return

/datum/computer_file/program/proc/terminate_program()
	program_state = IS_IDLE
	return

/datum/computer_file/program/proc/get_input(var/input)
	if(program_state != IS_RUNNING)
		return 0