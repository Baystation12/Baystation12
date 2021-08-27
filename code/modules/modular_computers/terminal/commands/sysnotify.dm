/// Causes computer to play a sound and show a message to everyone around it
/datum/terminal_command/sysnotify
	name = "sysnotify"
	man_entry = list(
		"Format: sysnotify message",
		"Triggers a system notification showing the specified message, along with an audio alert."
	)
	pattern = "^sysnotify"
	skill_needed = SKILL_PROF

/datum/terminal_command/sysnotify/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/argument = copytext(text, length(name) + 2, 0)
	if(copytext(text, 1, length(name) + 2) != "[name] " || !argument)
		return syntax_error()
	terminal.computer.audible_notification("sound/machines/ping.ogg")
	terminal.computer.visible_notification(argument)
	return list()
