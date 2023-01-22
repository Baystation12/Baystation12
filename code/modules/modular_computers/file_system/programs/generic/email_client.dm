/datum/computer_file/program/email_client
	filename = "emailc"
	filedesc = "Email Client"
	extended_desc = "This program may be used to log in into your email account."
	program_icon_state = "generic"
	program_key_state = "generic_key"
	program_menu_icon = "mail-closed"
	size = 7
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	var/stored_login = ""
	var/stored_password = ""
	usage_flags = PROGRAM_ALL
	category = PROG_OFFICE

	nanomodule_path = /datum/nano_module/email_client

/datum/computer_file/program/email_client/on_shutdown()
	// Persistency. Unless you log out, or unless your password changes, this will pre-fill the login data when restarting the program
	if(NM)
		var/datum/nano_module/email_client/NME = NM
		if(NME.current_account)
			stored_login = NME.stored_login
			stored_password = NME.stored_password
			NME.log_out()
		else
			stored_login = ""
			stored_password = ""
	. = ..()

/datum/computer_file/program/email_client/on_startup()
	. = ..()
	if(NM)
		var/datum/nano_module/email_client/NME = NM
		NME.stored_login = stored_login
		NME.stored_password = stored_password
		NME.log_in()
		NME.error = ""
		NME.check_for_new_messages(TRUE)

/datum/computer_file/program/email_client/proc/new_mail_notify(notification_sound)
	computer.visible_notification(notification_sound)
	computer.audible_notification("sound/machines/ping.ogg")

/datum/computer_file/program/email_client/process_tick()
	..()
	var/datum/nano_module/email_client/NME = NM
	if(!istype(NME))
		return
	NME.relayed_process(computer.get_ntnet_speed(computer.get_ntnet_status()))

	var/check_count = NME.check_for_new_messages()
	if(check_count)
		if(check_count == 2 && !NME.current_account.notification_mute)
			new_mail_notify(NME.current_account.notification_sound)
		ui_header = "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"

/datum/nano_module/email_client
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

/datum/nano_module/email_client/proc/get_ntos()
	var/datum/extension/interactive/ntos/os = get_extension(nano_host(), /datum/extension/interactive/ntos)
	if(!istype(os))
		error = "Error accessing system. Are you using a functional and NTOSv2-compliant device?"
		return
	return os

/datum/nano_module/email_client/proc/mail_received(datum/computer_file/data/email_message/received_message)
	var/mob/living/L = get_holder_of_type(host, /mob/living)
	if(L)
		var/list/msg = list()
		msg += "*--*\n"
		msg += "<span class='notice'>New mail received from [received_message.source]:</span>\n"
		msg += "<b>Subject:</b> [received_message.title]\n<b>Message:</b>\n[digitalPencode2html(received_message.stored_data)]\n"
		if(received_message.attachment)
			msg += "<b>Attachment:</b> [received_message.attachment.filename].[received_message.attachment.filetype] ([received_message.attachment.size]GQ)\n"
		msg += "<a href='?src=\ref[src];open;reply=[received_message.uid]'>Reply</a>\n"
		msg += "*--*"
		to_chat(L, jointext(msg, null))

/datum/nano_module/email_client/Destroy()
	log_out()
	. = ..()

/datum/nano_module/email_client/proc/log_in()
	var/list/id_login
	var/atom/movable/A = nano_host()
	var/obj/item/card/id/id = A.GetIdCard()
	if(!id && ismob(A.loc))
		var/mob/M = A.loc
		id = M.GetIdCard()
	if(id)
		id_login = id.associated_email_login.Copy()

	var/datum/computer_file/data/email_account/target
	for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
		if(!account || !account.can_login)
			continue
		if(id_login && id_login["login"] == account.login)
			target = account
			break
		if(stored_login && stored_login == account.login)
			target = account
			break

	if(!target)
		error = "Invalid Login"
		return FALSE

	if(target.suspended)
		error = "This account has been suspended. Please contact the system administrator for assistance."
		return FALSE

	var/use_pass
	if(stored_password)
		use_pass = stored_password
	else if(id_login)
		use_pass = id_login["password"]

	if(use_pass == target.password)
		current_account = target
		current_account.connected_clients |= src
		return TRUE
	else
		error = "Invalid Password"
		return FALSE

/// Returns 0 if no new messages were received, 1 if there is an unread message but notification has already been sent, and 2 if there is a new message that appeared in this tick (and therefore notification should be sent by the program).
/datum/nano_module/email_client/proc/check_for_new_messages(messages_read = FALSE)
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
	if(current_account)
		current_account.connected_clients -= src
	current_account = null
	downloading = null
	download_progress = 0
	last_message_count = 0
	read_message_count = 0

/datum/nano_module/email_client/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	// Password has been changed by other client connected to this email account
	if(current_account)
		if(current_account.password != stored_password)
			if(!log_in())
				log_out()
				error = "Invalid Password"
		// Banned.
		else if(current_account.suspended)
			log_out()
			error = "This account has been suspended. Please contact the system administrator for assistance."

	if(error)
		data["error"] = error
	else if(downloading)
		data["downloading"] = TRUE
		data["down_filename"] = "[downloading.filename].[downloading.filetype]"
		data["down_progress"] = download_progress
		data["down_size"] = downloading.size
		data["down_speed"] = download_speed

	else if(istype(current_account))
		data["current_account"] = current_account.login
		data["notification_mute"] = current_account.notification_mute
		if(addressbook)
			var/list/all_accounts = list()
			for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
				if(!account.can_login)
					continue
				all_accounts.Add(list(list(
					"name" = account.fullname,
					"job" = account.assignment,
					"login" = account.login
				)))
			data["addressbook"] = TRUE
			data["accounts"] = all_accounts
		else if(new_message)
			data["new_message"] = TRUE
			data["msg_title"] = msg_title
			data["msg_body"] = digitalPencode2html(msg_body)
			data["msg_recipient"] = msg_recipient
			if(msg_attachment)
				data["msg_hasattachment"] = TRUE
				data["msg_attachment_filename"] = "[msg_attachment.filename].[msg_attachment.filetype]"
				data["msg_attachment_size"] = msg_attachment.size
		else if (current_message)
			data["cur_title"] = current_message.title
			data["cur_body"] = digitalPencode2html(current_message.stored_data)
			data["cur_timestamp"] = current_message.timestamp
			data["cur_source"] = current_message.source
			data["cur_uid"] = current_message.uid
			if(istype(current_message.attachment))
				data["cur_hasattachment"] = TRUE
				data["cur_attachment_filename"] = "[current_message.attachment.filename].[current_message.attachment.filetype]"
				data["cur_attachment_size"] = current_message.attachment.size
		else
			data["label_inbox"] = "Inbox ([current_account.inbox.len])"
			data["label_outbox"] = "Sent ([current_account.outbox.len])"
			data["label_spam"] = "Spam ([current_account.spam.len])"
			data["label_deleted"] = "Deleted ([current_account.deleted.len])"
			var/list/message_source
			if(folder == "Inbox")
				message_source = current_account.inbox
			else if(folder == "Sent")
				message_source = current_account.outbox
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
						"body" = digitalPencode2html(message.stored_data),
						"source" = message.source,
						"timestamp" = message.timestamp,
						"uid" = message.uid
					)))
				data["messages"] = all_messages
				data["messagecount"] = all_messages.len
	else
		data["stored_login"] = stored_login
		data["stored_password"] = stars(stored_password, 0)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "email_client.tmpl", "Email Client", 600, 450, state = state)
		if(host?.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

/datum/nano_module/email_client/proc/find_message_by_fuid(fuid)
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

/datum/nano_module/email_client/proc/relayed_process(netspeed)
	download_speed = netspeed
	if(!downloading)
		return
	download_progress = min(download_progress + netspeed, downloading.size)
	if(download_progress >= downloading.size)
		var/datum/extension/interactive/ntos/os = get_ntos()
		if(!os)
			downloading = null
			download_progress = 0
			return

		if(!os.create_file(downloading))
			error = "Internal I/O error when writing file, the hard drive may be full."
		else
			error = "File successfully downloaded to local device."

		downloading = null
		download_progress = 0
	return

/datum/nano_module/email_client/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
	var/mob/living/user = usr

	if(href_list["open"])
		ui_interact()

	check_for_new_messages(TRUE) // Any actual interaction (button pressing) is considered as acknowledging received message, for the purpose of notification icons.
	if(href_list["login"])
		log_in()
		return TOPIC_HANDLED

	if(href_list["logout"])
		log_out()
		return TOPIC_HANDLED

	if(href_list["reset"])
		error = ""
		return TOPIC_HANDLED

	if(href_list["new_message"])
		new_message = TRUE
		return TOPIC_HANDLED

	if(href_list["cancel"])
		if(addressbook)
			addressbook = FALSE
		else
			clear_message()
		return TOPIC_HANDLED

	if(href_list["addressbook"])
		addressbook = TRUE
		return TOPIC_HANDLED

	if(href_list["set_recipient"])
		msg_recipient = sanitize(href_list["set_recipient"])
		addressbook = FALSE
		return TOPIC_HANDLED

	if(href_list["edit_title"])
		var/newtitle = sanitize(input(user,"Enter title for your message:", "Message title", msg_title), 100)
		if(newtitle)
			msg_title = newtitle
		return TOPIC_HANDLED

	// This uses similar editing mechanism as the FileManager program, therefore it supports various paper tags and remembers formatting.
	if(href_list["edit_body"])
		var/oldtext = html_decode(msg_body)
		oldtext = replacetext_char(oldtext, "\[br\]", "\n")

		var/newtext = sanitize(replacetext_char(input(usr, "Enter your message. You may use most tags from paper formatting", "Message Editor", oldtext) as message|null, "\n", "\[br\]"), 20000)
		if(newtext)
			msg_body = newtext
		return TOPIC_HANDLED

	if(href_list["edit_recipient"])
		var/newrecipient = sanitize(input(user,"Enter recipient's email address:", "Recipient", msg_recipient), 100)
		if(newrecipient)
			msg_recipient = newrecipient
			addressbook = FALSE
		return TOPIC_HANDLED

	if(href_list["close_addressbook"])
		addressbook = FALSE
		return TOPIC_HANDLED

	if(href_list["edit_login"])
		var/newlogin = sanitize(input(user,"Enter login", "Login", stored_login), 100)
		if(newlogin)
			stored_login = newlogin
		return TOPIC_HANDLED

	if(href_list["edit_password"])
		var/newpass = sanitize(input(user,"Enter password", "Password"), 100)
		if(newpass)
			stored_password = newpass
		return TOPIC_HANDLED

	if(href_list["delete"])
		if(!istype(current_account))
			return TOPIC_HANDLED
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["delete"])
		if(!istype(M))
			return TOPIC_HANDLED
		if(folder == "Deleted")
			current_account.deleted.Remove(M)
			qdel(M)
		else
			current_account.deleted.Add(M)
			current_account.inbox.Remove(M)
			current_account.spam.Remove(M)
		if(current_message == M)
			current_message = null
		return TOPIC_HANDLED

	if(href_list["send"])
		if(!current_account)
			return TOPIC_HANDLED
		if((msg_body == "") || (msg_recipient == ""))
			error = "Error sending mail: Message body is empty!"
			return TOPIC_HANDLED
		if(!length(msg_title))
			msg_title = "No subject"

		var/datum/computer_file/data/email_message/message = new()
		message.title = msg_title
		message.stored_data = msg_body
		message.source = current_account.login
		message.attachment = msg_attachment
		if(!current_account.send_mail(msg_recipient, message))
			error = "Error sending email: this address doesn't exist."
			return TOPIC_HANDLED
		else
			error = "Email successfully sent."
			clear_message()
			return TOPIC_HANDLED

	if(href_list["set_folder"])
		folder = href_list["set_folder"]
		return TOPIC_HANDLED

	if(href_list["reply"])
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["reply"])
		if(!istype(M))
			return TOPIC_HANDLED
		error = null
		new_message = TRUE
		msg_recipient = M.source
		msg_title = "Re: [M.title]"
		var/atom/movable/AM = host
		if(istype(AM))
			if(ismob(AM.loc))
				ui_interact(AM.loc)
		return TOPIC_HANDLED

	if(href_list["view"])
		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["view"])
		if(istype(M))
			current_message = M
		return TOPIC_HANDLED

	if(href_list["changepassword"])
		var/oldpassword = sanitize(input(user,"Please enter your old password:", "Password Change"), 100)
		if(!oldpassword)
			return TOPIC_HANDLED
		var/newpassword1 = sanitize(input(user,"Please enter your new password:", "Password Change"), 100)
		if(!newpassword1)
			return TOPIC_HANDLED
		var/newpassword2 = sanitize(input(user,"Please re-enter your new password:", "Password Change"), 100)
		if(!newpassword2)
			return TOPIC_HANDLED

		if(!istype(current_account))
			error = "Please log in before proceeding."
			return TOPIC_HANDLED

		if(current_account.password != oldpassword)
			error = "Incorrect original password"
			return TOPIC_HANDLED

		if(newpassword1 != newpassword2)
			error = "The entered passwords do not match."
			return TOPIC_HANDLED

		current_account.password = newpassword1
		stored_password = newpassword1
		error = "Your password has been successfully changed!"
		return TOPIC_HANDLED

	if(href_list["set_notification"])
		var/new_notification = sanitize(input(user, "Enter your desired notification sound:", "Set Notification", current_account.notification_sound) as text|null)
		if(new_notification && current_account)
			current_account.notification_sound = new_notification
		return TOPIC_HANDLED

	if(href_list["mute"])
		current_account.notification_mute = !current_account.notification_mute
		return TOPIC_HANDLED

	// The following entries are Modular Computer framework only, and therefore won't do anything in other cases (like AI View)

	if(href_list["save"])
		// Fully dependant on modular computers here.
		var/datum/extension/interactive/ntos/os = get_ntos()
		if(!os)
			return TOPIC_HANDLED

		var/filename = sanitize(input(user,"Please specify file name:", "Message export"), 100)
		if(!filename)
			return TOPIC_HANDLED

		os = get_ntos()
		if(!os)
			return TOPIC_HANDLED

		var/datum/computer_file/data/email_message/M = find_message_by_fuid(href_list["save"])
		var/datum/computer_file/data/mail = istype(M) ? M.export() : null
		if(!istype(mail))
			return TOPIC_HANDLED
		mail.filename = filename

		if(!os.create_file(mail))
			error = "Internal I/O error when writing file, the hard drive may be full."
		else
			error = "Email exported successfully"
		return TOPIC_HANDLED

	if(href_list["addattachment"])
		var/datum/extension/interactive/ntos/os = get_ntos()
		msg_attachment = null
		if(!os)
			return TOPIC_HANDLED

		var/list/filenames = list()
		var/list/files_on_disk = os.get_all_files()
		for(var/datum/computer_file/CF in files_on_disk)
			if(CF.unsendable)
				continue
			filenames.Add(CF.filename)

		var/picked_file = input(user, "Please pick a file to send as attachment (max 32GQ)") as null|anything in filenames
		if(!picked_file)
			return TOPIC_HANDLED

		os = get_ntos()
		if(!os)
			return TOPIC_HANDLED

		for(var/datum/computer_file/CF in files_on_disk)
			if(CF.unsendable)
				continue
			if(CF.filename == picked_file)
				msg_attachment = CF.clone()
				break

		if(!istype(msg_attachment))
			msg_attachment = null
			error = "Unknown error when uploading attachment."
			return TOPIC_HANDLED

		if(msg_attachment.size > 32)
			error = "Error uploading attachment: File exceeds maximal permitted file size of 32GQ."
			msg_attachment = null
		else
			error = "File [msg_attachment.filename].[msg_attachment.filetype] has been successfully uploaded."
		return TOPIC_HANDLED

	if(href_list["downloadattachment"])
		var/datum/extension/interactive/ntos/os = get_ntos()
		if(!os)
			return TOPIC_HANDLED

		if(!current_account || !current_message || !current_message.attachment)
			return TOPIC_HANDLED

		downloading = current_message.attachment.clone()
		download_progress = 0
		return TOPIC_HANDLED

	if(href_list["canceldownload"])
		downloading = null
		download_progress = 0
		return TOPIC_HANDLED

	if(href_list["remove_attachment"])
		msg_attachment = null
		return TOPIC_HANDLED