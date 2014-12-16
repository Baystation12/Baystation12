/obj/machinery/terminal/proc/process_input(var/text_input)

	var/list/sanitized_input = text2list(sanitize(trim(text_input))," ")

	// TODO: accounts and login.
	//if(!logged_in)
	//	return

	if(!sanitized_input || !sanitized_input.len)
		return

	terminal_output("<font color='#AAAAAA'>$</font> [text_input]")

	var/datum/computer_file/program/command = get_file(lowertext(sanitized_input[1]),IS_PROGRAM,program_dir)
	if(command)
		command.execute_program(sanitized_input,src)

	terminal_output(get_prompt(),1)
	interact(usr)

/obj/machinery/terminal/proc/get_prompt()
	var/prompt = "<font color='#AAAA00'>[current_dir.get_path()]</font>"
	if(logged_in)
		prompt = "<font color='#00AA00'>[logged_in.name]@[domain]</font> [prompt]"
	return "[prompt]"

/obj/machinery/terminal/proc/terminal_output(var/text_output,var/colour_set)
	if(!colour_set)
		text_output = "<font color='#AAAAAA'>[text_output]</font>"
	buffer.Insert(1,text_output)
	// Keep the scrollback manageable.
	if(buffer.len > 30)
		buffer.Cut(30)

/obj/machinery/terminal/proc/terminal_shutdown()
	for(var/pid in executing_programs)
		terminate_program(pid)
	icon_state = "comm_monitor0"
	return

/obj/machinery/terminal/proc/terminal_startup()
	// Reset to base state.
	// TODO: kill network
	buffer.Cut()
	current_dir = root
	// Update system hardware.
	RefreshParts()
	terminal_output("NTOS-0.1.17 Terminal Operating System")
	terminal_output("Copyright (C) 2558 NanoTrasen Synthetic Systems")
	terminal_output("-----------------------------------------------")
	icon_state = "comm_logs"

/obj/machinery/terminal/proc/terminate_program(var/pid)
	var/killed = 0
	var/datum/computer_file/program/command = executing_programs[pid]
	if(command)
		killed = 1
		command.terminate_program(src)
	executing_programs[pid] = null
	return killed

/obj/machinery/terminal/proc/get_pid(var/datum/computer_file/program/command)
	var/new_pid = 0
	while(executing_programs["[new_pid]"])
		new_pid++
	executing_programs["[new_pid]"] = command
	return "[new_pid]"

/obj/machinery/terminal/process()

	if(!system_state)
		return
	..()
	if(stat & (BROKEN|NOPOWER))
		return

	var/available_resources = 0
	if(processor)
		available_resources = processor.rating*10
	for(var/pid in executing_programs)
		if(available_resources <= 0)
			break
		var/datum/computer_file/program/command = executing_programs[pid]
		if(!command)
			executing_programs -= null
			continue
		if(available_resources <= command.processor_cost)
			break
		command.process(src)
		if(command.program_state == IS_TERMINATING)
			terminate_program(pid)
	return

/obj/machinery/terminal/proc/bind_port(var/port, var/datum/computer_file/program/command)
	open_ports["[port]"] = command
	terminal_output("Port [port] bound to process.")

/obj/machinery/terminal/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["text_input"])
		show_typing(usr,href_list["text_input"])
		process_input(href_list["text_input"])
	interact(usr)
	return 1