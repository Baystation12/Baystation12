//Helper datum for a shitty terminal emulator.

/datum/terminal
	var/datum/browser/panel
	var/list/commands = list(
		"^exit" = .proc/exit,
		"^man" = .proc/man
	)
	var/list/history = list()
	var/list/history_max_length = 20

/datum/terminal/New(mob/user)
	..()
	var/list/patterns = commands.Copy()
	commands.Cut()
	for(var/pattern in patterns)
		commands[regex(pattern)] = patterns[pattern]
	if(user)
		show_terminal(user)

/datum/terminal/Destroy()
	commands = null
	panel.close()
	QDEL_NULL(panel)
	return ..()

/datum/terminal/proc/get_user()
	if(panel)
		return panel.user

/datum/terminal/proc/show_terminal(mob/user)
	panel = new(user, "terminal", "Terminal", 500, 400, src)
	update_content()
	panel.open()

/datum/terminal/proc/update_content()
	var/list/content = history.Copy()
	content += "<form action='byond://'><input type='hidden' name='src' value='\ref[src]'>> <input type='text' size='40' name='input'><input type='submit' value='Enter'></form>"
	panel.set_content(jointext(content, "<br>"))

/datum/terminal/Topic(href, href_list)
	if(..())
		return 1
	if(href_list["input"])
		var/input = sanitize(href_list["input"])
		history += "> [input]"
		var/output = parse(input, usr)
		if(output)
			history += output
			if(length(history) > history_max_length)
				history.Cut(1, length(history) - history_max_length + 1)
			update_content()
			panel.update()
			return 1
		else
			qdel(src)
			return 1
	if(href_list["close"])
		qdel(src)
		return 1

/datum/terminal/proc/parse(text, mob/user)
	for(var/regex/pattern in commands)
		if(findtext(text, pattern))
			return call(src, commands[pattern])(text, user)
	return "Not a valid command."

/datum/terminal/proc/exit()

/datum/terminal/proc/man()
	. = list()
	. += "The following commands are recognized:"
	for(var/regex/command in commands)
		. += command.name