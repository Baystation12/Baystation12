/datum/computer_file/data/email_account/
	var/list/inbox = list()
	var/list/spam = list()
	var/list/deleted = list()

	var/login = ""
	var/password = ""
	var/can_login = TRUE	// Whether you can log in with this account. Set to false for system accounts
	var/suspended = FALSE	// Whether the account is banned by the SA.

/datum/computer_file/data/email_account/calculate_size()
	size = 1
	for(var/datum/computer_file/data/email_message/stored_message in (inbox | spam | deleted))
		stored_message.calculate_size()
		size += stored_message.size

/datum/computer_file/data/email_account/New()
	ntnet_global.email_accounts.Add(src)
	..()

/datum/computer_file/data/email_account/Destroy()
	ntnet_global.email_accounts.Remove(src)
	. = ..()

/datum/computer_file/data/email_account/proc/send_mail(var/recipient_address, var/datum/computer_file/data/email_message/message, var/relayed = 0)
	var/datum/computer_file/data/email_account/recipient
	for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
		if(account.login == recipient_address)
			recipient = account
			break

	if(!istype(recipient))
		return 0

	if(!recipient.receive_mail(message, relayed))
		return

	ntnet_global.add_log_with_ids_check("EMAIL LOG: [login] -> [recipient.login] title: [message.title].")
	return 1

/datum/computer_file/data/email_account/proc/receive_mail(var/datum/computer_file/data/email_message/received_message, var/relayed)
	received_message.set_timestamp()
	if(!ntnet_global.intrusion_detection_enabled)
		inbox.Add(received_message)
		return 1
	// Spam filters may occassionally let something through, or mark something as spam that isn't spam.
	if(received_message.spam)
		if(prob(98))
			spam.Add(received_message)
		else
			inbox.Add(received_message)
	else
		if(prob(1))
			spam.Add(received_message)
		else
			inbox.Add(received_message)
	return 1

// Address namespace (@internal-services.nt) for email addresses with special purpose only!.
/datum/computer_file/data/email_account/service/
	can_login = FALSE

/datum/computer_file/data/email_account/service/broadcaster/
	login = "broadcast@internal-services.nt"

/datum/computer_file/data/email_account/service/broadcaster/receive_mail(var/datum/computer_file/data/email_message/received_message, var/relayed)
	if(!istype(received_message) || relayed)
		return 0
	// Possibly exploitable for user spamming so keep admins informed.
	if(!received_message.spam)
		log_and_message_admins("Broadcast email address used by [usr]. Message title: [received_message.title].")

	spawn(0)
		for(var/datum/computer_file/data/email_account/email_account in ntnet_global.email_accounts)
			var/datum/computer_file/data/email_message/new_message = received_message.clone()
			send_mail(email_account.login, new_message, 1)
			sleep(2)

	return 1