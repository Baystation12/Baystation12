/datum/computer_file/program/chatclient
	filename = "ntnrc_client"
	filedesc = "NTNet Relay Chat Client"
	program_icon_state = "command"
	program_key_state = "med_key"
	program_menu_icon = "comment"
	extended_desc = "This program allows communication over NTNRC network"
	size = 8
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	network_destination = "NTNRC server"
	ui_header = "ntnrc_idle.gif"
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_chatclient
	/// Used to generate the toolbar icon
	var/last_message = null
	var/username
	var/datum/ntnet_conversation/channel = null
	/// Channel operator mode
	var/operator_mode = FALSE
	/// Administrator mode (invisible to other users + bypasses passwords)
	var/netadmin_mode = FALSE
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/chatclient/New()
	username = "DefaultUser[rand(100, 999)]"

/datum/computer_file/program/chatclient/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["PRG_speak"])
		. = TOPIC_HANDLED
		if(!channel)
			return TOPIC_HANDLED
		var/mob/living/user = usr
		var/message = sanitize(input(user, "Enter message or leave blank to cancel: "), 512)
		if(!message || !channel)
			return
		channel.add_message(message, username)

	if(href_list["PRG_joinchannel"])
		. = TOPIC_HANDLED
		var/datum/ntnet_conversation/C
		for(var/datum/ntnet_conversation/chan in ntnet_global.chat_channels)
			if(chan.id == text2num(href_list["PRG_joinchannel"]))
				C = chan
				break

		if(!C)
			return TOPIC_HANDLED

		if(netadmin_mode)
			channel = C		// Bypasses normal leave/join and passwords. Technically makes the user invisible to others.
			return TOPIC_HANDLED

		if(C.password)
			var/mob/living/user = usr
			var/password = sanitize(input(user,"Access Denied. Enter password:"))
			if(C && (password == C.password))
				C.add_client(src)
				channel = C
			return TOPIC_HANDLED
		C.add_client(src)
		channel = C
	if(href_list["PRG_leavechannel"])
		. = TOPIC_HANDLED
		if(channel)
			channel.remove_client(src)
		channel = null
	if(href_list["PRG_newchannel"])
		. = TOPIC_HANDLED
		var/mob/living/user = usr
		var/channel_title = sanitizeSafe(input(user,"Enter channel name or leave blank to cancel:"), 64)
		if(!channel_title)
			return
		var/atom/A = computer.get_physical_host()
		var/datum/ntnet_conversation/C = new/datum/ntnet_conversation(A.z)
		C.add_client(src)
		C.operator = src
		channel = C
		C.title = channel_title
	if(href_list["PRG_toggleadmin"])
		. = TOPIC_HANDLED
		if(netadmin_mode)
			netadmin_mode = FALSE
			if(channel)
				channel.remove_client(src) // We shouldn't be in channel's user list, but just in case...
				channel = null
			return TOPIC_HANDLED
		var/mob/living/user = usr
		if(can_run(usr, TRUE, access_network_admin))
			if(channel)
				var/response = alert(user, "Really engage admin-mode? You will be disconnected from your current channel!", "NTNRC Admin mode", "Yes", "No")
				if(response == "Yes")
					if(channel)
						channel.remove_client(src)
						channel = null
				else
					return
			netadmin_mode = TRUE
	if(href_list["PRG_changename"])
		. = TOPIC_HANDLED
		var/mob/living/user = usr
		var/newname = sanitize(input(user,"Enter new nickname or leave blank to cancel:"), 20)
		if(!newname)
			return
		if(channel)
			channel.add_status_message("[username] is now known as [newname].")
		username = newname

	if(href_list["PRG_savelog"])
		. = TOPIC_HANDLED
		if(!channel)
			return
		var/mob/living/user = usr
		var/filename = input(user,"Enter desired logfile name (.LOG) or leave blank to cancel:")
		if(!filename || !channel)
			return

		var/content = "\[b\]Logfile dump from NTNRC channel [channel.title]\[/b\]\[BR\]"
		for(var/logstring in channel.messages)
			content += "[logstring]\[BR\]"
		content += "\[b\]Logfile dump completed.\[/b\]"

		if(!computer.create_data_file(filename, content, /datum/computer_file/data/logfile))
			computer.show_error(user, "I/O Error - Check hard drive and free space.")
	if(href_list["PRG_renamechannel"])
		. = TOPIC_HANDLED
		if(!operator_mode || !channel)
			return
		var/mob/living/user = usr
		var/newname = sanitize(input(user, "Enter new channel name or leave blank to cancel:"), 64)
		if(!newname || !channel)
			return
		channel.add_status_message("Channel renamed from [channel.title] to [newname] by operator.")
		channel.title = newname
	if(href_list["PRG_deletechannel"])
		. = TOPIC_HANDLED
		if(channel && ((channel.operator == src) || netadmin_mode))
			qdel(channel)
			channel = null
	if(href_list["PRG_setpassword"])
		. = TOPIC_HANDLED
		if(!channel || ((channel.operator != src) && !netadmin_mode))
			return

		var/mob/living/user = usr
		var/newpassword = sanitize(input(user, "Enter new password for this channel. Leave blank to cancel, enter 'nopassword' to remove password completely:"))
		if(!channel || !newpassword || ((channel.operator != src) && !netadmin_mode))
			return

		if(newpassword == "nopassword")
			channel.password = ""
		else
			channel.password = newpassword

/datum/computer_file/program/chatclient/process_tick()
	..()
	var/atom/A = computer.get_physical_host()
	if(channel && !(channel.source_z in GetConnectedZlevels(A.z)))
		channel.remove_client(src)
		channel = null

	if(program_state != PROGRAM_STATE_KILLED)
		ui_header = "ntnrc_idle.gif"
		if(channel)
			// Remember the last message. If there is no message in the channel remember null.
			last_message = channel.messages.len ? channel.messages[channel.messages.len - 1] : null
		else
			last_message = null
		return

	if(channel && channel.messages && channel.messages.len)
		ui_header = last_message == channel.messages[channel.messages.len - 1] ? "ntnrc_idle.gif" : "ntnrc_new.gif"
	else
		ui_header = "ntnrc_idle.gif"

/datum/computer_file/program/chatclient/on_shutdown(forced = FALSE)
	if(channel)
		channel.remove_client(src)
		channel = null
	..(forced)

/datum/nano_module/program/computer_chatclient
	name = "NTNet Relay Chat Client"

/datum/nano_module/program/computer_chatclient/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.default_state)
	if(!ntnet_global || !ntnet_global.chat_channels)
		return

	var/list/data = list()
	if(program)
		data = program.get_header_data()

	var/datum/computer_file/program/chatclient/C = program
	if(!istype(C))
		return

	data["adminmode"] = C.netadmin_mode
	if(C.channel)
		data["title"] = C.channel.title
		var/list/messages[0]
		for(var/M in C.channel.messages)
			messages.Add(list(list(
				"msg" = M
			)))
		data["messages"] = messages
		var/list/clients[0]
		for(var/datum/computer_file/program/chatclient/cl in C.channel.clients)
			clients.Add(list(list(
				"name" = cl.username
			)))
		data["clients"] = clients
		C.operator_mode = (C.channel.operator == C) ? TRUE : FALSE
		data["is_operator"] = C.operator_mode || C.netadmin_mode

	else // Channel selection screen
		var/list/all_channels[0]
		var/atom/A = C.computer.get_physical_host()
		var/list/connected_zs = GetConnectedZlevels(A.z)
		for(var/datum/ntnet_conversation/conv in ntnet_global.chat_channels)
			if(conv && conv.title && (conv.source_z in connected_zs))
				all_channels.Add(list(list(
					"chan" = conv.title,
					"id" = conv.id
				)))
		data["all_channels"] = all_channels

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_chat.tmpl", "NTNet Relay Chat Client", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
