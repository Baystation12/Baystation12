/datum/computer_file/program/ntnetmonitor
	filename = "ntmonitor"
	filedesc = "NTNet Diagnostics and Monitoring"
	program_icon_state = "comm_monitor"
	program_key_state = "generic_key"
	program_menu_icon = "wrench"
	extended_desc = "This program monitors the local NTNet network, provides access to logging systems, and allows for configuration changes"
	size = 12
	requires_ntnet = TRUE
	required_access = access_network_admin
	network_destination = "NTNet Statistics & Configuration" // This triggers logging when the program is opened and closed
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_ntnetmonitor
	category = PROG_ADMIN

/datum/nano_module/program/computer_ntnetmonitor
	name = "NTNet Diagnostics and Monitoring"
	available_to_ai = TRUE

/datum/nano_module/program/computer_ntnetmonitor/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	if(!ntnet_global)
		return
	var/list/data = host.initial_data()

	data += "skill_fail"
	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		var/datum/extension/fake_data/fake_data = get_or_create_extension(src, /datum/extension/fake_data, 20)
		data["skill_fail"] = fake_data.update_and_return_data()
	data["terminal"] = !!program

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

/datum/nano_module/program/computer_ntnetmonitor/Topic(href, href_list, state)
	var/mob/user = usr
	if(..())
		return TOPIC_HANDLED

	if(!user.skill_check(SKILL_COMPUTER, SKILL_BASIC))
		return TOPIC_HANDLED

	if(href_list["resetIDS"])
		if(ntnet_global)
			ntnet_global.resetIDS()
		return TOPIC_HANDLED
	if(href_list["toggleIDS"])
		if(ntnet_global)
			ntnet_global.toggleIDS()
		return TOPIC_HANDLED
	if(href_list["toggleWireless"])
		if(!ntnet_global)
			return TOPIC_HANDLED

		// NTNet is disabled. Enabling can be done without user prompt
		if(ntnet_global.setting_disabled)
			ntnet_global.setting_disabled = FALSE
			return TOPIC_HANDLED

		// NTNet is enabled and user is about to shut it down. Let's ask them if they really want to do it, as wirelessly connected computers won't connect without NTNet being enabled (which may prevent people from turning it back on)
		if(!user)
			return TOPIC_HANDLED
		var/response = alert(user, "Really disable NTNet wireless? If your computer is connected wirelessly you won't be able to turn it back on! This will affect all connected wireless devices.", "NTNet shutdown", "Yes", "No")
		if(response == "Yes")
			ntnet_global.setting_disabled = TRUE
		return TOPIC_HANDLED
	if(href_list["purgelogs"])
		if(ntnet_global)
			ntnet_global.purge_logs()
		return TOPIC_HANDLED
	if(href_list["updatemaxlogs"])
		var/logcount = text2num(input(user,"Enter amount of logs to keep in memory ([MIN_NTNET_LOGS]-[MAX_NTNET_LOGS]):"))
		if(ntnet_global)
			ntnet_global.update_max_log_count(logcount)
		return TOPIC_HANDLED
	if(href_list["toggle_function"])
		if(!ntnet_global)
			return TOPIC_HANDLED
		ntnet_global.toggle_function(href_list["toggle_function"])
		return TOPIC_HANDLED
	if(href_list["ban_nid"])
		if(!ntnet_global)
			return TOPIC_HANDLED
		var/nid = input(user,"Enter NID of device which you want to block from the network:", "Enter NID") as null|num
		if(nid && CanUseTopic(user, state))
			ntnet_global.banned_nids |= nid
		return TOPIC_HANDLED
	if(href_list["unban_nid"])
		if(!ntnet_global)
			return TOPIC_HANDLED
		var/nid = input(user,"Enter NID of device which you want to unblock from the network:", "Enter NID") as null|num
		if(nid && CanUseTopic(user, state))
			ntnet_global.banned_nids -= nid
		return TOPIC_HANDLED