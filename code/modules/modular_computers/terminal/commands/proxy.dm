/// Sets this computer up to use another as a proxy. If the proxy device also has a proxy itself set up, the last device in the chain is used.
/datum/terminal_command/proxy
	name = "proxy"
	man_entry = list(
		"Format: proxy \[-s nid\]",
		"Without options, displays the proxy state of network device.",
		"With -s option and no further arguments, clears proxy settings.",
		"With -s followed by nid (number), sets proxy to nid.",
		"A set proxy will tunnel all network connections through the designated device.",
		"It is recommended that the user ensure that the target device is accessible."
	)
	pattern = "^proxy"
	skill_needed = SKILL_EXPERT

/datum/terminal_command/proxy/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/list/arguments = get_arguments(text)
	if(isnull(arguments))
		return syntax_error()
	var/obj/item/stock_parts/computer/network_card/network_card = terminal.computer.get_component(PART_NETWORK)
	if(!network_card || !network_card.check_functionality())
		return "[name]: Could not find valid network interface."
	if(!arguments.len)
		if(!network_card.proxy_id)
			return "[name]: This device is not using a proxy."
		return "[name]: This device is set to connect via proxy with NID '[network_card.proxy_id]'."
	else if(arguments.len == 1 && arguments[1] == "-s")
		if(!network_card.proxy_id)
			return "[name]: Error; this device is not using a proxy."
		network_card.proxy_id = null
		return "[name]: Device proxy cleared."
	else if(arguments.len == 2 && arguments[1] == "-s")
		var/nid = text2num(arguments[2])
		if(!nid)
			return "[name]: Error; invalid NID."
		var/datum/extension/interactive/ntos/target = ntnet_global.get_os_by_nid(nid)
		if(target == terminal.computer)
			return "[name]: Error: cannot setup a device to be its own proxy."
		if(!terminal.computer.get_ntnet_status_incoming() || !target || !target.get_ntnet_status_incoming()) // Both devices only need a direct connection to NTNet to set up
			return "[name]: Error; cannot locate target device. Try ping for diagnostics."
		var/log_entry = "([time_stamp()]) - Proxy routing request accepted from: [network_card.get_network_tag_direct()].\[br\]"
		if(!target.update_data_file("proxy", log_entry, /datum/computer_file/data/logfile))
			return "[name]: Error; unable to save proxy registration on target device."
		network_card.proxy_id = nid
		return "[name]: Device proxy set to NID '[nid]'."
	return syntax_error()
