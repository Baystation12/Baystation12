/// Manages the NTNet banlist
/datum/terminal_command/banned
	name = "banned"
	man_entry = list(
		"Format: banned \[-flag nid\]",
		"Without options, list currently banned network ids.",
		"With -b followed by nid (number), ban the network id.",
		"With -u followed by nid (number), unban the network id.",
		"NOTICE: Requires network operator access for viewing, and admin access for modification"
	)
	pattern = "^banned"
	req_access = list(list(access_network, access_network_admin))
	skill_needed = SKILL_ADEPT

/datum/terminal_command/banned/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/arguments = get_arguments(text)
	if(isnull(arguments))
		return syntax_error()
	if(!ntnet_global || !terminal.computer.get_ntnet_status())
		return network_error()
	if(!arguments.len)
		if (ntnet_global.banned_nids.len)
			return list("[name]: The following network ids are banned:", jointext(ntnet_global.banned_nids, ", "))
		else
			return "[name]: There are no banned network ids."
	else if(arguments.len == 2)
		if(!has_access(list(access_network_admin), user.GetAccess()))
			return "[name]: ACCESS DENIED"
		var/nid = text2num(arguments[2])
		if(arguments[1] == "-b")
			if (nid && !(nid in ntnet_global.banned_nids))
				LAZYADD(ntnet_global.banned_nids, nid)
				return "[name]: Network id '[nid]' banned."
			else
				return "[name]: Error; network id invalid or already banned."
		else if(arguments[1] == "-u")
			if (nid in ntnet_global.banned_nids)
				ntnet_global.banned_nids -= nid
				return "[name]: Network id '[nid]' unbanned."
			else
				return "[name]: Error; network id not found on list of banned ids."
	return syntax_error()
