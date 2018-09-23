/datum/computer_file/program/ntnetmonitor
	filename = "ntmonitor"
	filedesc = "NTNet Diagnostics and Monitoring"
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "wrench"
	extended_desc = "This program monitors the local NTNet network, provides access to logging systems, and allows for configuration changes"
	size = 12
	requires_ntnet = 1
	required_access = access_network
	available_on_ntnet = 1
	nanomodule_path = /datum/nano_module/computer_ntnetmonitor/

/datum/nano_module/computer_ntnetmonitor
	name = "NTNet Diagnostics and Monitoring"
	available_to_ai = TRUE
	var/list/terminals

/datum/nano_module/computer_ntnetmonitor/Destroy()
	QDEL_NULL_LIST(terminals)
	return ..()

/datum/nano_module/computer_ntnetmonitor/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.default_state)
	if(!ntnet_global)
		return
	var/list/data = host.initial_data()

	data += "skill_fail"
	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		var/datum/extension/fake_data/fake_data = get_or_create_extension(src, /datum/extension/fake_data, /datum/extension/fake_data, 20)
		data["skill_fail"] = fake_data.update_and_return_data()

	data["ntnetstatus"] = ntnet_global.check_function()
	data["ntnetrelays"] = ntnet_global.relays.len
	data["idsstatus"] = ntnet_global.intrusion_detection_enabled
	data["idsalarm"] = ntnet_global.intrusion_detection_alarm

	data["config_softwaredownload"] = ntnet_global.setting_softwaredownload
	data["config_peertopeer"] = ntnet_global.setting_peertopeer
	data["config_communication"] = ntnet_global.setting_communication
	data["config_systemcontrol"] = ntnet_global.setting_systemcontrol

	data["ntnetlogs"] = ntnet_global.logs
	data["ntnetmaxlogs"] = ntnet_global.setting_maxlogcount

	data["banned_nids"] = list(ntnet_global.banned_nids)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_monitor.tmpl", "NTNet Diagnostics and Monitoring Tool", 575, 700, state = state)
		if(host.update_layout())
			ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/datum/nano_module/computer_ntnetmonitor/Topic(href, href_list, state)
	var/mob/user = usr
	if(..())
		return 1

	if(href_list["terminal"])
		for(var/datum/terminal/terminal in terminals)
			if(terminal.get_user() == user)
				return 1
		LAZYADD(terminals, new /datum/terminal/ntnet_monitor(user, src))
		return 1

	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		return 1

	if(href_list["resetIDS"])
		if(ntnet_global)
			ntnet_global.resetIDS()
		return 1
	if(href_list["toggleIDS"])
		if(ntnet_global)
			ntnet_global.toggleIDS()
		return 1
	if(href_list["toggleWireless"])
		if(!ntnet_global)
			return 1

		// NTNet is disabled. Enabling can be done without user prompt
		if(ntnet_global.setting_disabled)
			ntnet_global.setting_disabled = 0
			return 1

		// NTNet is enabled and user is about to shut it down. Let's ask them if they really want to do it, as wirelessly connected computers won't connect without NTNet being enabled (which may prevent people from turning it back on)
		if(!user)
			return 1
		var/response = alert(user, "Really disable NTNet wireless? If your computer is connected wirelessly you won't be able to turn it back on! This will affect all connected wireless devices.", "NTNet shutdown", "Yes", "No")
		if(response == "Yes")
			ntnet_global.setting_disabled = 1
		return 1
	if(href_list["purgelogs"])
		if(ntnet_global)
			ntnet_global.purge_logs()
		return 1
	if(href_list["updatemaxlogs"])
		var/logcount = text2num(input(user,"Enter amount of logs to keep in memory ([MIN_NTNET_LOGS]-[MAX_NTNET_LOGS]):"))
		if(ntnet_global)
			ntnet_global.update_max_log_count(logcount)
		return 1
	if(href_list["toggle_function"])
		if(!ntnet_global)
			return 1
		ntnet_global.toggle_function(href_list["toggle_function"])
		return 1
	if(href_list["ban_nid"])
		if(!ntnet_global)
			return 1
		var/nid = input(user,"Enter NID of device which you want to block from the network:", "Enter NID") as null|num
		if(nid && CanUseTopic(user, state))
			ntnet_global.banned_nids |= nid
		return 1
	if(href_list["unban_nid"])
		if(!ntnet_global)
			return 1
		var/nid = input(user,"Enter NID of device which you want to unblock from the network:", "Enter NID") as null|num
		if(nid && CanUseTopic(user, state))
			ntnet_global.banned_nids -= nid
		return 1

/datum/nano_module/computer_ntnetmonitor/proc/skill_fail(mob/user)
	switch(rand(1,30))
		if(1 to 5)
			ntnet_global.banned_nids |= rand(1,40)
			. = "Entered id successfully banned!"
		if(6 to 10)
			var/id = pick_n_take(ntnet_global.banned_nids)
			if(id)
				. = "Entered id successfully unbanned!"
		if(11 to 15)
			ntnet_global.purge_logs()
			. = "Memory reclamation successful! Logs fully purged!"
		if(16 to 20)
			ntnet_global.resetIDS()
			. = "Intrusion detecton system state reset!"
		if(21 to 22)
			var/datum/computer_file/data/email_account/server = ntnet_global.find_email_by_name(EMAIL_DOCUMENTS)
			for(var/datum/computer_file/data/email_account/email in ntnet_global.email_accounts)
				if(!email.can_login || email.suspended)
					continue
				var/datum/computer_file/data/email_message/message = new()
				message.title = "IMPORTANT NETWORK ALERT!"
				message.stored_data = jointext(ntnet_global.logs, "<br>")
				message.source = server.login
				server.send_mail(email.login, message)
			. = "System log backup successful. Chosen method: email attachment. Recipients: all."

// Terminal datum and commands.
/datum/terminal/ntnet_monitor
	commands = list(
		"^exit" = .proc/exit,
		"^man" = .proc/man,
		"^relays" = .proc/relays,
		"^banned" = .proc/banned,
		"^status" = .proc/status
	)
	var/datum/nano_module/computer_ntnetmonitor/NM

/datum/terminal/ntnet_monitor/New(mob/user, datum/nano_module/computer_ntnetmonitor/NM)
	..()
	src.NM = NM

/datum/terminal/ntnet_monitor/Destroy()
	if(NM)
		LAZYREMOVE(NM.terminals, src)
	NM = null
	return ..()

/datum/terminal/ntnet_monitor/parse(text, mob/user)
	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		if((. = NM.skill_fail(user)))
			return
	if(!user.skill_check(SKILL_COMPUTER, SKILL_EXPERT))
		commands.Cut()
	return ..()

/datum/terminal/ntnet_monitor/proc/relays()
	return "Number of relays found: [ntnet_global.relays.len]"

/datum/terminal/ntnet_monitor/proc/banned()
	. = list()
	. += "The following ids are banned:"
	. += jointext(ntnet_global.banned_nids, ", ") || "No ids banned."

/datum/terminal/ntnet_monitor/proc/status()
	. = list()
	. += "NTnet status: [ntnet_global.check_function() ? "ENABLED" : "DISABLED"]"
	. += "Alarm status: [ntnet_global.intrusion_detection_enabled ? "ENABLED" : "DISABLED"]"
	if(ntnet_global.intrusion_detection_alarm)
		. += "NETWORK INCURSION DETECTED"