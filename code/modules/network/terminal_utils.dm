// TODO: clean up if(pid) etc

/datum/computer_file/program/clear
	name = "clear"

/datum/computer_file/program/clear/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		holder.buffer.Cut()
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/netstat
	name = "netstat"
	default_port = 23

/datum/computer_file/program/netstat/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		holder.terminal_output("Terminal IP configuration")
		holder.terminal_output("Subspace adapter")
		holder.terminal_output("Local Area Connection Test:")
		holder.terminal_output("This is a literal string for testing.")
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/connect
	name = "connect"
	operands = 1

/datum/computer_file/program/connect/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		holder.terminal_output("You tried to connect to target address: [args[2]]")
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/disconnect
	name = "disconnect"
	operands = 1

/datum/computer_file/program/disconnect/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		holder.terminal_output("You tried to disconnect.")
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/logout
	name = "logout"

/datum/computer_file/program/logout/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		if(holder.logged_in)
			holder.current_dir = holder.root
			holder.logged_in = null
			holder.terminal_output("Logging out... done.")
		else
			holder.terminal_output("No account currently logged in.")
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/login
	name = "login"
	operands = 2

/datum/computer_file/program/login/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		if(holder.logged_in)
			holder.terminal_output("Already logged in as [holder.logged_in.name] on [holder.domain].")
		else
			holder.terminal_output("Attempting to authenticate with server...")
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/ls
	name = "ls"

/datum/computer_file/program/ls/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		var/datum/computer_file/directory/target_dir
		if(args.len > 1)
			target_dir = holder.get_file(args[2], IS_DIRECTORY)
		else
			target_dir = holder.current_dir
		if(target_dir)
			for(var/file_name in target_dir.contents)
				var/datum/computer_file/tar_file = target_dir.contents[file_name]
				var/tar_file_type = ""
				switch(tar_file.file_type)
					if(IS_DIRECTORY)
						tar_file_type = "directory"
					if(IS_PROGRAM)
						tar_file_type = "executable"
				var/output_str = "[tar_file.name]"
				while(length(output_str) < 60) output_str +=  " "
				holder.terminal_output("[output_str][tar_file_type]")
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/cd
	name = "cd"
	operands = 1

/datum/computer_file/program/cd/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		if(args[2] == "..")
			if(holder.current_dir.parent)
				holder.current_dir = holder.current_dir.parent
		else
			var/datum/computer_file/file = holder.get_file(args[2], IS_DIRECTORY)
			if(file)
				holder.current_dir = file
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/rm
	name = "rm"
	operands = 1

/datum/computer_file/program/rm/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		var/datum/computer_file/file = holder.get_file(args[2], IS_DIRECTORY)
		if(file)
			holder.current_dir.contents -= file
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/mkdir
	name = "mkdir"
	operands = 1

/datum/computer_file/program/mkdir/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		holder.current_dir.add_file(new /datum/computer_file/directory(src,args[2],holder.current_dir))
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/write
	name = "write"
	operands = 1

/datum/computer_file/program/write/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		var/datum/computer_file/new_file = new (holder,args[2],holder.current_dir)
		var/list/write_args = args.Copy()
		write_args.Cut(1,3)
		new_file.write_contents(list2text(write_args, " "))
		holder.current_dir.add_file(new_file)
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/cat
	name = "cat"
	operands = 1

/datum/computer_file/program/cat/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		var/datum/computer_file/file = holder.get_file(args[2], IS_FILE)
		if(file)
			holder.terminal_output("[file.file_contents]")
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/run
	name = "run"
	operands = 1

/datum/computer_file/program/run/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		var/datum/computer_file/program/tar_file = holder.get_file(args[2], IS_PROGRAM)
		if(tar_file)
			var/list/write_args = args.Copy()
			write_args.Cut(2)
			tar_file.execute_program(write_args)
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/cp
	name = "cp"
	operands = 2

/datum/computer_file/program/cp/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		var/datum/computer_file/tar_file = holder.get_file(args[2])
		var/datum/computer_file/copied_file = tar_file.copy_file()
		copied_file.name = args[3]
		holder.current_dir.add_file(copied_file)
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/kill
	name = "kill"
	operands = 1

/datum/computer_file/program/kill/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		if(holder.terminate_program(lowertext(args[2])))
			holder.terminal_output("kill: Killed [lowertext(args[2])].")
		else
			holder.terminal_output("kill: No process with that pid.")
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/procs
	name = "procs"

/datum/computer_file/program/procs/execute_program(var/list/args)
	var/pid = ..()
	if(pid)
		for(var/check_pid in holder.executing_programs)
			var/datum/computer_file/program/command = holder.executing_programs[check_pid]
			if(!command)
				holder.executing_programs -= null
			else
				holder.terminal_output("[command.name] \[[check_pid]\]")
	program_state = IS_TERMINATING
	return pid

/datum/computer_file/program/shutdown
	name = "shutdown"

/datum/computer_file/program/shutdown/process()
	program_state = IS_TERMINATING
	holder.terminal_shutdown()