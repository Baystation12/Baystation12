/datum/computer_file/program/email_client
	filename = "emailc"
	filedesc = "Email Client"
	extended_desc = "This program may be used to log in into your email account."
	program_icon_state = "generic"
	size = 7
	requires_ntnet = 1
	available_on_ntnet = 1
	var/stored_login = ""
	var/stored_password = ""

	nanomodule_path = /datum/nano_module/email_client

// Persistency. Unless you log out, or unless your password changes, this will pre-fill the login data when restarting the program
/datum/computer_file/program/email_client/kill_program()
	if(NM)
		var/datum/nano_module/email_client/NME = NM
		if(NME.current_account)
			stored_login = NME.stored_login
			stored_password = NME.stored_password
		else
			stored_login = ""
			stored_password = ""
	. = ..()

/datum/computer_file/program/email_client/run_program()
	. = ..()
	if(NM)
		var/datum/nano_module/email_client/NME = NM
		NME.stored_login = stored_login
		NME.stored_password = stored_password
		NME.log_in()
		NME.error = ""
		NME.check_for_new_messages(1)

/datum/computer_file/program/email_client/proc/new_mail_notify()
	computer.visible_message("\The [computer] beeps softly, indicating a new email has been received.", 1)

/datum/computer_file/program/email_client/process_tick()
	..()
	var/datum/nano_module/email_client/NME = NM
	if(!istype(NME))
		return
	NME.relayed_process(ntnet_speed)

	var/check_count = NME.check_for_new_messages()
	if(check_count)
		if(check_count == 2)
			new_mail_notify()
		ui_header = "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"

/datum/nano_module/email_client/
	name = "Email Client"
	var/stored_login = ""
	var/stored_password = ""
	var/error = ""

	var/msg_title = ""
	var/msg_body = ""
	var/msg_recipient = ""
	var/datum/computer_file/msg_attachment = null
	var/folder = "Inbox"
	var/addressbook = FALSE
	var/new_message = FALSE

	var/last_message_count = 0	// How many messages were there during last check.
	var/read_message_count = 0	// How many messages were there when user has last accessed the UI.

	var/datum/computer_file/downloading = null
	var/download_progress = 0
	var/download_speed = 0

	var/datum/computer_file/data/email_account/current_account = null
	var/datum/computer_file/data/email_message/current_message = null

/datum/nano_module/email_client/proc/log_in()
	for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
		if(!account.can_login)
			continue
		if(account.login == stored_login)
			if(account.password == stored_password)
				if(account.suspended)
					error = "This account has been suspended. Please contact the system administrator for assistance."
					return 0
				current_account = account
				return 1
			else
				error = "Invalid Password"
				return 0
	error = "Invalid Login"
	return 0

// Returns 0 if no new messages were received, 1 if there is an unread message but notification has already been sent.
// and 2 if there is a new message that appeared in this tick (and therefore notification should be sent by the program).
/datum/nano_module/email_client/proc/check_for_new_messages(var/messages_read = FALSE)
	if(!current_account)
		return 0

	var/list/allmails = current_account.all_emails()

	if(allmails.len > last_message_count)
		. = 2
	else if(allmails.len > read_message_count)
		. = 1
	else
		. = 0

	last_message_count = allmails.len
	if(messages_read)
		read_message_count = allmails.len


/datum/nano_module/email_client/proc/log_out()
	current_account = null
	downloading = null
	download_progress = 0
	last_message_count = 0
	read_message_count = 0

/datum/nano_module/email_client/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	// Password has been changed by other client connected to this email account
	if(current_account)
		if(current_account.password != stored_password)
			log_out()
			error = "Invalid Password"
		// Banned.
		if(current_account.suspended)
			log_out()
			error = "This account has been suspended. Please contact the system administrator for assistance."

	if(error)
		data["error"] = error
	else if(downloading)
		data["downloading"] = 1
		data["down_filename"] = "[downloading.filename].[downloading.filetype]"
		data["down_progress"] = download_progress
		data["down_size"] = downloading.size
		data["down_speed"] = download_speed

	else if(istype(current_account))
		data["current_account"] = current_account.login
		if(addressbook)
			var/list/all_accounts = list()
			for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
				if(!account.can_login)
					continue
				all_accounts.Add(list(list(
					"login" = account.login
				)))
			data["addressbook"] = 1
			data["accounts"] = all_accounts
		else if(new_message)
			data["new_message"] = 1
			data["msg_title"] = msg_title
			data["msg_body"] = pencode2html(msg_body)
			data["msg_recipient"] = msg_recipient
			if(msg_attachment)
				data["msg_hasattachment"] = 1
				data["msg_attachment_filename"] = "[msg_attachment.filename].[msg_attachment.filetype]"
				data["msg_attachment_size"] = msg_attachment.size
		else if (current_message)
			data["cur_title"] = current_message.title
			data["cur_body"] = pencode2html(current_message.stored_data)
			data["cur_timestamp"] = current_message.timestamp
			data["cur_source"] = current_message.source
			data["cur_uid"] = current_message.uid
			if(istype(current_message.attachment))
				data["cur_hasattachment"] = 1
				data["cur_attachment_filename"] = "[current_message.attachment.filename].[current_message.attachment.filetype]"
				data["cur_attachment_size"] = current_message.attachment.size
		else
			data["label_inbox"] = "Inbox ([current_account.inbox.len])"
			data["label_spam"] = "Spam ([current_account.spam.len])"
			data["label_deleted"] = "Deleted ([current_account.deleted.len])"
			var/list/message_source
			if(folder == "Inbox")
				message_source = current_account.inbox
			else if(folder == "Spam")
				message_source = current_account.spam
			else if(folder == "Deleted")
				message_source = current_account.deleted

			if(message_source)
				data["folder"] = folder
				var/list/all_messages = list()
				for(var/datum/computer_file/data/email_message/message in message_source)
					all_messages.Add(list(list(
						"title" = message.title,
						"body" = pencode2html(message.stored_data),
						"source" = message.source,
						"timestamp" = message.timestamp,
						"uid" = message.uid
					)))
				data["messages"] = all_messages
				data["messagecount"] = all_messages.len
	else
		data["stored_login"] = stored_login
		data["stored_password"] = stars(stored_password, 0)

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "email_client.tmpl", "Email Client", 600, 450, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/email_client/proc/find_message_by_fuid(var/fuid)
	if(!istype(current_account))
		return

	// href_list works with strings, so this makes it a bit easier for us
	if(istext(fuid))
		fuid = text2num(fuid)

	for(var/datum/computer_file/data/email_message/message in current_account.all_emails())
		if(message.uid == fuid)
			return message

/datum/nano_module/email_client/proc/clear_message()
	new_message = FALSE
	msg_title = ""
	msg_body = ""
	msg_recipient = ""
	msg_attachment = null
	current_message = null

/datum/nano_module/email_client/proc/relayed_process(var/netspeed)
	download_speed = netspeed
	if(!downloading)
		return
	download_progress = min(download_progress + netspeed, downloading.size)
	if(download_progress >= downloading.size)
		var/obj/item/modular_computer/MC = nano_host()
		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error uploading file. Are you using a functional and NTOSv2-compliant device?"
			downloading = null
			download_progress = 0
			return 1

		if(MC.hard_drive.store_file(downloading))
			error = "File successfully downloaded to local device."
		else
			error = "Error saving file: I/O Error: The hard drive may be full or nonfunctional."
		downloading = null
		download_progress = 0
	return 1


/datum/nano_module/email_client/Topic(href, href_list)
	if(..())
		return 1
	var/mob/living/user = usr
	check_for_new_messages(1)		// Any actual interaction (button pressing) is considered as acknowledging received message, for the purpose of notification icons.
	if(href_list["login"])
		log_in()
		return 1

	if(href_list["logout"])
		log_out()
		return 1

	if(href_list["reset"])
		error = ""
		return 1

	if(href_list["new_message"])
		new_message = TRUE
		return 1

	if(href_list["cancel"])
		if(addressbook)
			addressbook = FALSE
		else
			clear_message()
		return 1

	if(href_list["addressbook"])
		addressbook = TRUE
		return 1

	if(href_list["set_recipient"])
		msg_recipient = sanitize(href_list["set_recipient"])
		addressbook = FALSE
		return 1

	if(href_list["edit_title"])
		var/newtitle = sanitize(input(user,"Enter title for your message:", "Message title", msg_title), 100)
		if(newtitle)
			msg_title = newtitle
		return 1

	// This uses similar editing mechanism as the FileManager program, therefore it supports various paper tags and remembers formatting.
	if(href_list["edit_body"])
		var/oldtext = html_decode(msg_body)
		oldtext = replacetext(oldtext, "\[editorbr\]", "\n")

		var/newtext = sanitize(replacetext(input(usr, "Enter your message. You may use most tags from paper formatting", "Message Editor", oldtext) as message|null, "\n", "\[editorbr\]"), 20000)
		if(newtext)
			msg_body = newtext
		return 1

	if(href_list["edit_recipient"])
		var/newrecipient = sanitize(input(user,"Enter recipient's email address:", "Recipient", msg_recipient), 100)
		if(newrecipient)
			msg_recipient = newrecipient
		return 1

	if(href_list["edit_login"])
		var/newlogin = sanitize(input(user,"Enter login", "Login", stored_login), 100)
		if(newlogin)
			stored_login = newlogin
		return 1

	if(href_list["edit_password"])
		var/newpass = sanitize(input(user,"Enter password", "Password"), 100)
		if(newpass)
			stored_password = newpass
		return 1

	if(href_list["delete"])
		if(!istype(current_account))
			return 1
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["delete"])
		if(!istype(M))
			return 1
		if(folder == "Deleted")
			current_account.deleted.Remove(M)
			qdel(M)
		else
			current_account.deleted.Add(M)
			current_account.inbox.Remove(M)
			current_account.spam.Remove(M)
		if(current_message == M)
			current_message = null
		return 1

	if(href_list["send"])
		if(!current_account)
			return 1
		if((msg_title == "") || (msg_body == "") || (msg_recipient == ""))
			error = "Error sending mail: Title or message body is empty!"
			return 1

		var/datum/computer_file/data/email_message/message = new()
		message.title = msg_title
		message.stored_data = msg_body
		message.source = current_account.login
		message.attachment = msg_attachment
		if(!current_account.send_mail(msg_recipient, message))
			error = "Error sending email: this address doesn't exist."
			return 1
		else
			error = "Email successfully sent."
			clear_message()
			return 1

	if(href_list["set_folder"])
		folder = href_list["set_folder"]
		return 1

	if(href_list["reply"])
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["reply"])
		if(!istype(M))
			return 1

		new_message = TRUE
		msg_recipient = M.source
		msg_title = "Re: [M.title]"
		msg_body = "\[editorbr\]\[editorbr\]\[editorbr\]\[br\]==============================\[br\]\[editorbr\]"
		msg_body += "Received by [current_account.login] at [M.timestamp]\[br\]\[editorbr\][M.stored_data]"
		return 1

	if(href_list["view"])
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["view"])
		if(istype(M))
			current_message = M
		return 1

	if(href_list["changepassword"])
		var/oldpassword = sanitize(input(user,"Please enter your old password:", "Password Change"), 100)
		if(!oldpassword)
			return 1
		var/newpassword1 = sanitize(input(user,"Please enter your new password:", "Password Change"), 100)
		if(!newpassword1)
			return 1
		var/newpassword2 = sanitize(input(user,"Please re-enter your new password:", "Password Change"), 100)
		if(!newpassword2)
			return 1

		if(!istype(current_account))
			error = "Please log in before proceeding."
			return 1

		if(current_account.password != oldpassword)
			error = "Incorrect original password"
			return 1

		if(newpassword1 != newpassword2)
			error = "The entered passwords do not match."
			return 1

		current_account.password = newpassword1
		stored_password = newpassword1
		error = "Your password has been successfully changed!"
		return 1

	// The following entries are Modular Computer framework only, and therefore won't do anything in other cases (like AI View)

	if(href_list["save"])
		// Fully dependant on modular computers here.
		var/obj/item/modular_computer/MC = nano_host()

		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error exporting file. Are you using a functional and NTOS-compliant device?"
			return 1

		var/filename = sanitize(input(user,"Please specify file name:", "Message export"), 100)
		if(!filename)
			return 1

		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["save"])
		var/datum/computer_file/data/mail = istype(M) ? M.export() : null
		if(!istype(mail))
			return 1
		mail.filename = filename
		if(!MC.hard_drive || !MC.hard_drive.store_file(mail))
			error = "Internal I/O error when writing file, the hard drive may be full."
		else
			error = "Email exported successfully"
		return 1

	if(href_list["addattachment"])
		var/obj/item/modular_computer/MC = nano_host()
		msg_attachment = null

		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error uploading file. Are you using a functional and NTOSv2-compliant device?"
			return 1

		var/list/filenames = list()
		for(var/datum/computer_file/CF in MC.hard_drive.stored_files)
			if(CF.unsendable)
				continue
			filenames.Add(CF.filename)
		var/picked_file = input(user, "Please pick a file to send as attachment (max 32GQ)") as null|anything in filenames

		if(!picked_file)
			return 1

		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error uploading file. Are you using a functional and NTOSv2-compliant device?"
			return 1

		for(var/datum/computer_file/CF in MC.hard_drive.stored_files)
			if(CF.unsendable)
				continue
			if(CF.filename == picked_file)
				msg_attachment = CF.clone()
				break
		if(!istype(msg_attachment))
			msg_attachment = null
			error = "Unknown error when uploading attachment."
			return 1

		if(msg_attachment.size > 32)
			error = "Error uploading attachment: File exceeds maximal permitted file size of 32GQ."
			msg_attachment = null
		else
			error = "File [msg_attachment.filename].[msg_attachment.filetype] has been successfully uploaded."
		return 1

	if(href_list["downloadattachment"])
		if(!current_account || !current_message || !current_message.attachment)
			return 1
		var/obj/item/modular_computer/MC = nano_host()
		if(!istype(MC) || !MC.hard_drive || !MC.hard_drive.check_functionality())
			error = "Error downloading file. Are you using a functional and NTOSv2-compliant device?"
			return 1

		downloading = current_message.attachment.clone()
		download_progress = 0
		return 1

	if(href_list["canceldownload"])
		downloading = null
		download_progress = 0
		return 1

	if(href_list["remove_attachment"])
		msg_attachment = null
		return 1