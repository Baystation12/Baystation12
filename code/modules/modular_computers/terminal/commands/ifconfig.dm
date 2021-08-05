/// Shows information about the network card in the computer and active remote terminals
/datum/terminal_command/ifconfig
	name = "ifconfig"
	man_entry = list(
		"Format: ifconfig \[identificator\]",
		"If no identificator is specified, returns network adaptor information.",
		"If identificator is specified, assign it to this interface.",
		"Returns network adaptor information."
	)
	pattern = "^ifconfig"
	skill_needed = SKILL_EXPERT

/datum/terminal_command/ifconfig/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/command = copytext(text, 1, length(name) + 2)
	if(command != name && command != "[name] ")
		return syntax_error()
	var/obj/item/stock_parts/computer/network_card/network_card = terminal.computer.get_component(PART_NETWORK)
	if(!network_card)
		return "[name]: No network adaptor found."
	if(!network_card.check_functionality())
		return "[name]: Network adaptor not activated."
	var/argument = copytext(text, length(name) + 2, 0)
	if(!argument)
		. = list(
			"[name]: Resolving visible network id for outgoing connections...",
			"Resolved tag - [network_card.get_network_tag()]",
			"Actual tag - [network_card.get_network_tag_direct()]"
		)
		if(terminal.computer.terminals)
			var/list/remote_connections = list()
			for(var/datum/terminal/remote/rt in terminal.computer.terminals)
				var/obj/item/stock_parts/computer/network_card/origin_nc = rt.origin_computer.get_component(PART_NETWORK)
				var/obj/item/stock_parts/computer/network_card/remote_nc = rt.computer.get_component(PART_NETWORK)
				if(origin_nc && remote_nc)
					remote_connections += "[origin_nc.get_network_tag()] -> [remote_nc.get_network_tag_direct()]"
			if(remote_connections.len)
				. += ""
				. += "Active ssh sessions:"
				. += remote_connections
		return
	else if (!network_card.set_identification_string(argument))
		return "[name]: Error; invalid identification string."
	return "[name]: Identification string set to '[argument]'."
