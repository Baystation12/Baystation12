/datum/computer_file/program/email_administration
	filename = "emailadmin"
	filedesc = "Email Administration Utility"
	extended_desc = "This program may be used to administrate NTNet's emailing service."
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "mail-open"
	size = 12
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/email_administration
	required_access = access_network_admin
	category = PROG_ADMIN

/datum/nano_module/program/email_administration
	name = "Email Administration"
	available_to_ai = TRUE
	var/datum/computer_file/data/email_account/current_account = null
	var/datum/computer_file/data/email_message/current_message = null
	var/error = ""

/datum/nano_module/program/email_administration/proc/get_ntos()
	var/datum/extension/interactive/ntos/os = get_extension(nano_host(), /datum/extension/interactive/ntos)
	if(!istype(os))
		error = "Error accessing system. Are you using a functional and NTOSv2-compliant device?"
		return
	return os

/datum/nano_module/program/email_administration/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()

	data += "skill_fail"
	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		var/datum/extension/fake_data/fake_data = get_or_create_extension(src, /datum/extension/fake_data, 15)
		data["skill_fail"] = fake_data.update_and_return_data()
	data["terminal"] = !!program

	if(error)
		data["error"] = error
	else if(istype(current_message))
		data["msg_title"] = current_message.title
		data["msg_body"] = digitalPencode2html(current_message.stored_data)
		data["msg_timestamp"] = current_message.timestamp
		data["msg_source"] = current_message.source
	else if(istype(current_account))
		data["current_account"] = current_account.login
		data["cur_suspended"] = current_account.suspended
		var/list/all_messages = list()
		for(var/datum/computer_file/data/email_message/message in (current_account.inbox | current_account.spam | current_account.deleted))
			all_messages.Add(list(list(
				"title" = message.title,
				"source" = message.source,
				"timestamp" = message.timestamp,
				"uid" = message.uid
			)))
		data["messages"] = all_messages
		data["messagecount"] = all_messages.len
	else
		var/list/all_accounts = list()
		for(var/datum/computer_file/data/email_account/account in ntnet_global.email_accounts)
			if(!account.can_login)
				continue
			all_accounts.Add(list(list(
				"login" = account.login,
				"uid" = account.uid
			)))
		data["accounts"] = all_accounts
		data["accountcount"] = all_accounts.len

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "email_administration.tmpl", "Email Administration Utility", 600, 450, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()


/datum/nano_module/program/email_administration/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	var/mob/user = usr
	if(!istype(user))
		return TOPIC_HANDLED

	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		return TOPIC_HANDLED

	var/datum/extension/interactive/ntos/os = get_ntos()
	if(!os)
		return TOPIC_HANDLED

	// High security - can only be operated when the user has an ID with access on them.
	var/obj/item/card/id/I = user.GetIdCard()
	if(!istype(I) || !(access_network_admin in I.access))
		return TOPIC_HANDLED

	if(href_list["back"])
		if(error)
			error = ""
		else if(current_message)
			current_message = null
		else
			current_account = null
		return TOPIC_HANDLED

	if(href_list["ban"])
		if(!current_account)
			return TOPIC_HANDLED

		current_account.suspended = !current_account.suspended
		os.add_log("EMAIL LOG: SA-EDIT Account [current_account.login] has been [current_account.suspended ? "" : "un" ]suspended by SA [I.registered_name] ([I.assignment]).")
		error = "Account [current_account.login] has been [current_account.suspended ? "" : "un" ]suspended."
		return TOPIC_HANDLED

	if(href_list["changepass"])
		if(!current_account)
			return TOPIC_HANDLED

		var/newpass = sanitize(input(user,"Enter new password for account [current_account.login]", "Password"), 100)
		if(!newpass)
			return TOPIC_HANDLED
		current_account.password = newpass
		os.add_log("EMAIL LOG: SA-EDIT Password for account [current_account.login] has been changed by SA [I.registered_name] ([I.assignment]).")
		return TOPIC_HANDLED

	if(href_list["viewmail"])
		if(!current_account)
			return TOPIC_HANDLED

		for(var/datum/computer_file/data/email_message/received_message in (current_account.inbox | current_account.spam | current_account.deleted))
			if(received_message.uid == text2num(href_list["viewmail"]))
				current_message = received_message
				break
		return TOPIC_HANDLED

	if(href_list["viewaccount"])
		for(var/datum/computer_file/data/email_account/email_account in ntnet_global.email_accounts)
			if(email_account.uid == text2num(href_list["viewaccount"]))
				current_account = email_account
				break
		return TOPIC_HANDLED

	if(href_list["newaccount"])
		var/newdomain = sanitize(input(user,"Pick domain:", "Domain name") as null|anything in GLOB.using_map.usable_email_tlds)
		if(!newdomain)
			return TOPIC_HANDLED
		var/newlogin = sanitize(input(user,"Pick account name (@[newdomain]):", "Account name"), 100)
		if(!newlogin)
			return TOPIC_HANDLED

		var/complete_login = "[newlogin]@[newdomain]"
		if(ntnet_global.find_email_by_name(complete_login))
			error = "Error creating account: An account with same address already exists."
			return TOPIC_HANDLED

		var/datum/computer_file/data/email_account/new_account = new/datum/computer_file/data/email_account()
		new_account.login = complete_login
		new_account.password = GenerateKey()
		error = "Email [new_account.login] has been created, with generated password [new_account.password]"
		return TOPIC_HANDLED
