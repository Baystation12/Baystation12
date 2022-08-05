/// System for a shitty terminal emulator.
/datum/terminal
	var/name = "Terminal"
	var/datum/browser/panel
	var/list/history = list()
	var/list/history_max_length = 50
	var/datum/extension/interactive/ntos/computer

/datum/terminal/New(mob/user, datum/extension/interactive/ntos/computer)
	..()
	src.computer = computer
	if(user && can_use(user))
		show_terminal(user)
	START_PROCESSING(SSprocessing, src)

/datum/terminal/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	if(computer && computer.terminals)
		computer.terminals -= src
	computer = null
	if(panel)
		panel.close()
		QDEL_NULL(panel)
	return ..()

/datum/terminal/proc/can_use(mob/user)
	if(!user)
		return FALSE
	if(!computer || !computer.on)
		return FALSE
	if(!CanInteractWith(user, computer, GLOB.default_state))
		return FALSE
	return TRUE

/datum/terminal/Process()
	if(!can_use(get_user()))
		qdel(src)

/datum/terminal/proc/command_by_name(name)
	for(var/command in GLOB.terminal_commands)
		var/datum/terminal_command/command_datum = command
		if(command_datum.name == name)
			return command

/datum/terminal/proc/get_user()
	if(panel)
		return panel.user

/datum/terminal/proc/show_terminal(mob/user)
	panel = new(user, "terminal-\ref[computer]", name, 800, 600, src)
	update_content()
	panel.open()

/datum/terminal/proc/update_content()
	var/list/content = history.Copy()
	content += "<form action='byond://'><input type='hidden' name='src' value='\ref[src]'> <input type='text' size='40' name='input' autofocus><input type='submit' value='Enter'></form>"
	content += "<i>type `man` for a list of available commands.</i>"
	panel.set_content(jointext(content, "<br>"))

/datum/terminal/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	if(!can_use(usr) || href_list["close"])
		qdel(src)
		return TOPIC_HANDLED
	if(href_list["input"])
		var/input = sanitize(href_list["input"])
		history += "> [input]"
		var/output = parse(input, usr)
		if(QDELETED(src)) // Check for exit.
			return TOPIC_HANDLED
		history += output
		if(length(history) > history_max_length)
			history.Cut(1, length(history) - history_max_length + 1)
		update_content()
		panel.update()
		return TOPIC_HANDLED

/datum/terminal/proc/parse(text, mob/user)
	if(user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		for(var/datum/terminal_command/command in GLOB.terminal_commands)
			. = command.parse(text, user, src)
			if(!isnull(.))
				return
	else
		. = skill_critical_fail(user)
		if(!isnull(.)) // If it does something silently, we give generic text.
			return
	return "Command [text] not found."

/datum/terminal/proc/skill_critical_fail(user)
	var/list/candidates = list()
	for(var/datum/terminal_skill_fail/scf in GLOB.terminal_fails)
		if(scf.can_run(user, src))
			candidates[scf] = scf.weight
	var/datum/terminal_skill_fail/chosen = pickweight(candidates)
	if(istype(chosen))
		return chosen.execute(src)
