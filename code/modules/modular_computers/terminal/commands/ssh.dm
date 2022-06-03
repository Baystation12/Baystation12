// Creates a remote terminal on the targeted computer
/datum/terminal_command/ssh
	name = "ssh"
	man_entry = list(
		"Format: ssh nid",
		"Opens a remote terminal on the device corresponding to the specified nid (number).",
		"NOTICE: Requires network admin access."
	)
	pattern = "^ssh"
	req_access = list(access_network_admin)
	skill_needed = SKILL_EXPERT

/datum/terminal_command/check_access(mob/user, datum/terminal/terminal)
	if(terminal.computer.emagged() && !istype(terminal, /datum/terminal/remote))
		return TRUE // Helps let antags do hacker gimmicks without having to get universal network access first.
	return ..()

/datum/terminal_command/ssh/proper_input_entered(text, mob/user, datum/terminal/terminal)
	if(istype(terminal, /datum/terminal/remote))
		return "[name]: Error; [name] is not supported on remote terminals."
	var/list/arguments = get_arguments(text)
	if(isnull(arguments) || arguments.len != 1)
		return syntax_error()
	if(!terminal.computer.get_ntnet_status())
		return network_error()
	. = list()
	if(terminal.computer.emagged())
		. += "CRYPTOGRAPHIC ATTACK PROTOCOL ENABLED"
	var/nid = text2num(arguments[1])
	if(!nid)
		. += "[name]: Error; invalid network id."
		return
	var/datum/extension/interactive/ntos/T = ntnet_global.get_os_by_nid(nid)
	if(!istype(T) || !T.get_ntnet_status_incoming()) // Target device only need a direct connection to NTNet
		. += "[name]: Error; cannot locate target device. Try ping for diagnostics."
		return
	if(T == terminal.computer)
		. += "[name]: Error: cannot open remote terminal session on same device."
		return
	if(T.has_terminal(user))
		. += "[name]: Error; a remote terminal to this device is already active."
		return
	var/datum/terminal/remote/new_term = new (user, T, terminal.computer)
	LAZYADD(T.terminals, new_term)
	LAZYADD(terminal.computer.terminals, new_term)
	. += "[name]: Connection established."
	return