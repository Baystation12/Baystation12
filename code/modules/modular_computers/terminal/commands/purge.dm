/// Purge NTNet log and reset intrusition alarm
/datum/terminal_command/purge
	name = "purge"
	man_entry = list(
		"Format: purge",
		"Purge network log and reset intrusion network alarm.",
		"NOTICE: Requires network admin access."
	)
	pattern = "^purge$"
	req_access = list(access_network_admin)
	skill_needed = SKILL_PROF

/datum/terminal_command/purge/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(!ntnet_global || !terminal.computer.get_ntnet_status())
		return network_error()
	terminal.computer.add_log("Network packet sent to NTNet Statistics & Configuration")
	ntnet_global.resetIDS()
	ntnet_global.purge_logs()
	return list("[name]: NTNet intrusion alarm and log purge complete.")
