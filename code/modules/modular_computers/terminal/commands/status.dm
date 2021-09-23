/// Shows status on NTNet
/datum/terminal_command/status
	name = "status"
	man_entry = list(
		"Format: status",
		"Reports network status information.",
		"NOTICE: Requires network operator or admin access."
	)
	pattern = "^status$"
	req_access = list(list(access_network, access_network_admin))
	skill_needed = SKILL_EXPERT

/datum/terminal_command/status/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(!terminal.computer.get_ntnet_status())
		return network_error()
	. = list()
	. += "NTnet status: [ntnet_global.check_function() ? "ENABLED" : "DISABLED"]"
	. += "Alarm status: [ntnet_global.intrusion_detection_enabled ? "ENABLED" : "DISABLED"]"
	if(ntnet_global.intrusion_detection_alarm)
		. += "NETWORK INCURSION DETECTED"
