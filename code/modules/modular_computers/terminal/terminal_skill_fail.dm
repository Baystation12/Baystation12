GLOBAL_LIST_INIT(terminal_fails, init_subtypes(/datum/terminal_skill_fail))

/datum/terminal_skill_fail/
	var/weight = 1
	var/message

/datum/terminal_skill_fail/proc/can_run(mob/user, datum/terminal/terminal)
	return 1

/datum/terminal_skill_fail/proc/execute()
	return message

/datum/terminal_skill_fail/no_fail
	weight = 10

/datum/terminal_skill_fail/random_ban
	weight = 5
	message = "Entered id successfully banned!"

/datum/terminal_skill_fail/random_ban/can_run(mob/user, datum/terminal/terminal)
	if(!has_access(list(access_network), user.GetAccess()))
		return
	return ..()

/datum/terminal_skill_fail/random_ban/execute()
	ntnet_global.banned_nids |= rand(1,40)
	return ..()

/datum/terminal_skill_fail/random_ban/unban
	message = "Entered id successfully unbanned!"

/datum/terminal_skill_fail/random_ban/unban/execute()
	var/id = pick_n_take(ntnet_global.banned_nids)
	if(id)
		return ..()

/datum/terminal_skill_fail/random_ban/purge
	message = "Memory reclamation successful! Logs fully purged!"

/datum/terminal_skill_fail/random_ban/purge/execute()
	ntnet_global.purge_logs()
	return ..()

/datum/terminal_skill_fail/random_ban/alarm_reset
	message = "Intrusion detecton system state reset!"

/datum/terminal_skill_fail/random_ban/alarm_reset/execute()
	ntnet_global.resetIDS()
	return ..()

/datum/terminal_skill_fail/random_ban/email_logs
	weight = 2
	message = "System log backup successful. Chosen method: email attachment. Recipients: all."

/datum/terminal_skill_fail/random_ban/email_logs/execute()
	var/datum/computer_file/data/email_account/server = ntnet_global.find_email_by_name(EMAIL_DOCUMENTS)
	for(var/datum/computer_file/data/email_account/email in ntnet_global.email_accounts)
		if(!email.can_login || email.suspended)
			continue
		var/datum/computer_file/data/email_message/message = new()
		message.title = "IMPORTANT NETWORK ALERT!"
		message.stored_data = jointext(ntnet_global.logs, "<br>")
		message.source = server.login
		server.send_mail(email.login, message)
	return ..()