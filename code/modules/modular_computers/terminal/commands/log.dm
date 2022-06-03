/// Emails the NTNet log to an email account
/datum/terminal_command/log
	name = "log"
	man_entry = list(
		"Format: log email",
		"Sends the content of the network log to the specified email address.",
		"NOTICE: Requires network operator or admin access. Use by non-admins is logged."
	)
	pattern = "^log"
	req_access = list(list(access_network, access_network_admin))
	skill_needed = SKILL_EXPERT

/datum/terminal_command/log/proper_input_entered(text, mob/user, datum/terminal/terminal)
	var/argument = copytext(text, length(name) + 2, 0)
	if(copytext(text, 1, length(name) + 2) != "[name] " || !argument)
		return syntax_error()
	if(!terminal.computer.get_ntnet_status())
		return network_error()
	var/datum/computer_file/data/email_account/S = ntnet_global.find_email_by_name(EMAIL_SYSADMIN)
	if(!istype(S))
		return "[name]: Error; unable to send email. [EMAIL_SYSADMIN] unavailable or missing."
	var/datum/computer_file/data/email_message/M = new()
	M.title = "!SENSITIVE! - NTNet System log backup"
	M.stored_data = jointext(ntnet_global.logs, "<br>")
	M.source = S.login
	if(!S.send_mail(argument, M))
		return "[name]: Error; could not send email to '[argument]'."
	if(!has_access(list(access_network_admin), user.GetAccess()))
		terminal.computer.add_log("Network log sent to: [argument]")
	return "[name]: Network log sent to [argument]."
