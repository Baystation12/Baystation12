/datum/email_account/
	var/list/inbox = list()
	var/list/spam = list()
	var/list/deleted = list()

	var/login = ""
	var/password = ""
	var/can_login = TRUE	// Whether you can log in with this account. Set to false for system accounts
	var/suspended = FALSE	// Whether the account is banned by the SA.

/datum/email_account/New()
	ntnet_global.email_accounts.Add(src)
	..()

/datum/email_account/Destroy()
	ntnet_global.email_accounts.Remove(src)
	. = ..()

/datum/email_account/proc/send_mail(var/recipient_address, var/datum/computer_file/data/email_message/message, var/relayed = 0)
	var/datum/email_account/recipient
	for(var/datum/email_account/account in ntnet_global.email_accounts)
		if(account.login == recipient_address)
			recipient = account
			break

	if(!istype(recipient))
		return 0

	if(!recipient.receive_mail(message, relayed))
		return
	if(ntnet_global.intrusion_detection_enabled)
		ntnet_global.add_log("EMAIL LOG: [login] -> [recipient.login] title: [message.title].")
	return 1

/datum/email_account/proc/receive_mail(var/datum/computer_file/data/email_message/message, var/relayed)
	if(!ntnet_global.intrusion_detection_enabled)
		inbox.Add(message)
		return 1

	// Spam filters may occassionally let something through, or mark something as spam that isn't spam.
	if(message.spam)
		if(prob(98))
			spam.Add(message)
		else
			inbox.Add(message)
	else
		if(prob(1))
			spam.Add(message)
		else
			inbox.Add(message)
	return 1

// Address namespace (@internal-services.nt) for email addresses with special purpose only!.
/datum/email_account/service/
	can_login = FALSE

/datum/email_account/service/broadcaster/
	login = "broadcast@internal-services.nt"

/datum/email_account/service/broadcaster/receive_mail(var/datum/computer_file/data/email_message/message, var/relayed)
	if(!istype(message) || relayed)
		return 0
	// Possibly exploitable for user spamming so keep admins informed.
	if(!message.spam)
		log_and_message_admins("Broadcast email address used by [usr]. Message title: [message.title].")

	// Workaround for what seems to be a BYOND issue to me, can't use message directly in the following loop, otherwise
	// compiler will begin complaining. Do note that it's not related to spawn(), didn't work without it either.
	var/datum/computer_file/data/email_message/received_message = message

	spawn(0)
		for(var/datum/email_account/email_account in ntnet_global.email_accounts)
			var/datum/computer_file/data/email_message/new_message = received_message.clone()
			send_mail(email_account.login, new_message, 1)
			sleep(2)

	return 1