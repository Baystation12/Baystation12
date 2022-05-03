/// Scans the network for connected devices and returns their NIDs
/datum/terminal_command/netscan
	name = "netscan"
	man_entry = list(
		"Format: netscan",
		"Scans the local network for devices and returns their NIDs."
	)
	pattern = "^netscan$"
	skill_needed = SKILL_EXPERT

/datum/terminal_command/netscan/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if (!ntnet_global || !terminal.computer.get_ntnet_status())
		return network_error()
	. = list("Broadcast-pinging local network...")
	for (var/nid in ntnet_global.registered_nids)
		var/datum/extension/interactive/ntos/comp = ntnet_global.get_os_by_nid(nid)
		if (comp && comp.get_ntnet_status_incoming())
			. += "NID [nid]"
	. += "Found [length(.) - 1] responding devices."
