/datum/computer_file/program/chatclient
	filename = "ntnrc_client"
	filedesc = "NTNet Relay Chat Client"
	program_icon_state = "command"
	program_key_state = "med_key"
	program_menu_icon = "comment"
	extended_desc = "This program allows communication over NTNRC network"
	size = 2
	processing_size = 0
	requires_ntnet = TRUE
	requires_ntnet_feature = NTNET_COMMUNICATION
	network_destination = "NTNRC server"
	ui_header = "ntnrc_idle.gif"
	available_on_ntnet = TRUE
	nanomodule_path = /datum/nano_module/program/computer_chatclient
	var/username
	/// Every conversation this client is in
	var/list/datum/ntnet_conversation/conversations = list()
	/// The conversation currently on screen, or null for the channel list
	var/datum/ntnet_conversation/active_channel = null
	/// Conversation -> its message_count when last read
	var/list/last_read = list()
	/// Channel operator mode
	var/operator_mode = FALSE
	/// Administrator mode (invisible to other users + bypasses passwords)
	var/netadmin_mode = FALSE
	/// Mutes notifications
	var/muted = FALSE
	usage_flags = PROGRAM_ALL

/datum/computer_file/program/chatclient/New()
	username = "DefaultUser[rand(100, 999)]"

/datum/computer_file/program/chatclient/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["PRG_speak"])
		. = TOPIC_HANDLED
		if(!active_channel)
			return TOPIC_HANDLED
		var/message = sanitize(href_list["message"], 512)
		if(!message)
			return
		active_channel.add_message(message, username)
		log_say("[key_name(usr.client)] : ([username] in [active_channel.title]) sent NTNRC message: [message]")
		ntnrc_alert(active_channel, "[username] sent an NTNRC message in [active_channel.title]: [message]")

	if(href_list["PRG_joinchannel"])
		. = TOPIC_HANDLED
		var/datum/ntnet_conversation/C
		for(var/datum/ntnet_conversation/chan in ntnet_global.chat_channels)
			if(chan.id == text2num(href_list["PRG_joinchannel"]))
				C = chan
				break

		if(!C)
			return TOPIC_HANDLED

		try_join_channel(C, usr)
	if(href_list["PRG_channellist"])
		. = TOPIC_HANDLED
		active_channel = null
	if(href_list["PRG_leavechannel"])
		. = TOPIC_HANDLED
		if(active_channel)
			leave_conversation(active_channel)
	if(href_list["PRG_newchannel"])
		. = TOPIC_HANDLED
		var/mob/living/user = usr
		var/channel_title = ntnrc_channel_name(input(user, "Enter channel name or leave blank to cancel:", "New channel") as text|null)
		if(!channel_title)
			return
		var/turf/turf = get_turf(computer.get_physical_host())
		var/datum/ntnet_conversation/existing = ntnrc_find_channel(channel_title, turf.z)
		if(existing)
			try_join_channel(existing, user)
			return
		var/datum/ntnet_conversation/conversation = new/datum/ntnet_conversation(turf.z)
		conversation.add_client(src)
		conversation.operator = src
		join_conversation(conversation)
		conversation.title = channel_title
	if(href_list["PRG_toggleadmin"])
		. = TOPIC_HANDLED
		if(netadmin_mode)
			netadmin_mode = FALSE
			leave_all_conversations()
			return TOPIC_HANDLED
		var/mob/living/user = usr
		if(can_run(usr, TRUE, access_network_admin))
			if(length(conversations))
				var/response = alert(user, "Really engage admin-mode? You will be disconnected from your current channel!", "NTNRC Admin mode", "Yes", "No")
				if(response == "Yes")
					leave_all_conversations()
				else
					return
			netadmin_mode = TRUE
	if(href_list["PRG_changename"])
		. = TOPIC_HANDLED
		var/mob/living/user = usr
		var/newname = sanitize(input(user, "Enter new nickname or leave blank to cancel:", "Change nickname", html_decode(username)), 20)
		if(!newname || newname == username)
			return
		if(active_channel)
			active_channel.add_status_message("[username] is now known as [newname].")
		username = newname

	if (href_list["PRG_mutenotif"])
		. = TOPIC_HANDLED
		muted = !muted
		if (muted)
			computer.visible_notification(SPAN_NOTICE("Channel notifications have been disabled."))
			return
		computer.visible_notification(SPAN_NOTICE("Channel notifications have been enabled."))

	if(href_list["PRG_savelog"])
		. = TOPIC_HANDLED
		if(!active_channel)
			return
		var/mob/living/user = usr
		var/filename = input(user,"Enter desired logfile name (.LOG) or leave blank to cancel:")
		if(!filename || !active_channel)
			return

		var/content = "\[b\]Logfile dump from NTNRC channel [active_channel.title]\[/b\]\[BR\]"
		for(var/logstring in active_channel.messages)
			content += "[logstring]\[BR\]"
		content += "\[b\]Logfile dump completed.\[/b\]"

		if(!computer.create_data_file(filename, content, /datum/computer_file/data/logfile))
			computer.show_error(user, "I/O Error - Check hard drive and free space.")
	if(href_list["PRG_renamechannel"])
		. = TOPIC_HANDLED
		if(!operator_mode || !active_channel)
			return
		var/mob/living/user = usr
		var/newname = ntnrc_channel_name(input(user, "Enter new channel name or leave blank to cancel:", "Rename channel", active_channel.title) as text|null)
		if(!newname || !active_channel || newname == active_channel.title)
			return
		var/datum/ntnet_conversation/existing = ntnrc_find_channel(newname, active_channel.source_z)
		if(existing && existing != active_channel)
			return
		active_channel.add_status_message("Channel renamed from [active_channel.title] to [newname] by operator.")
		active_channel.title = newname
	if(href_list["PRG_deletechannel"])
		. = TOPIC_HANDLED
		if(active_channel && ((active_channel.operator == src) || netadmin_mode))
			var/datum/ntnet_conversation/deleted = active_channel
			qdel(deleted)
			forget_conversation(deleted)
	if(href_list["PRG_setpassword"])
		. = TOPIC_HANDLED
		if(!active_channel || ((active_channel.operator != src) && !netadmin_mode))
			return

		var/newpassword = sanitize(input(usr, "Enter new password for this channel. Leave blank to cancel, enter 'nopassword' to remove password completely:"))
		if(!active_channel || !newpassword || ((active_channel.operator != src) && !netadmin_mode))
			return

		active_channel.password = newpassword == "nopassword" ? "" : newpassword

/datum/computer_file/program/chatclient/process_tick()
	..()
	var/turf/turf = get_turf(computer.get_physical_host())
	var/list/connected_zs = GetConnectedZlevels(turf.z)
	var/unread = FALSE
	for (var/datum/ntnet_conversation/conversation as anything in conversations)
		if (QDELETED(conversation))
			forget_conversation(conversation)
			continue
		if (!(conversation.source_z in connected_zs))
			leave_conversation(conversation)
			continue
		if (conversation == active_channel && program_state == PROGRAM_STATE_ACTIVE)
			last_read[conversation] = conversation.message_count
		if (last_read[conversation] != conversation.message_count)
			unread = TRUE
	ui_header = unread ? "ntnrc_new.gif" : "ntnrc_idle.gif"

/datum/computer_file/program/chatclient/on_shutdown(forced = FALSE)
	leave_all_conversations()
	..(forced)

/datum/computer_file/program/chatclient/proc/join_conversation(datum/ntnet_conversation/conversation)
	if (!(conversation in conversations))
		if (!netadmin_mode && !(src in conversation.clients))
			conversation.add_client(src)
			ntnrc_alert(conversation, "A user has joined your channel.")
		conversations += conversation
		last_read[conversation] = conversation.message_count
	active_channel = conversation

/datum/computer_file/program/chatclient/proc/try_join_channel(datum/ntnet_conversation/channel, mob/user)
	if(channel.password && !netadmin_mode && !(channel in conversations))
		var/password = sanitize(input(user,"Access Denied. Enter password:"))
		if(QDELETED(channel) || password != channel.password)
			return
	join_conversation(channel)

/datum/computer_file/program/chatclient/proc/leave_conversation(datum/ntnet_conversation/conversation)
	if (src in conversation.clients)
		conversation.remove_client(src)
		ntnrc_alert(conversation, "A user has left your channel.")
	forget_conversation(conversation)

/datum/computer_file/program/chatclient/proc/leave_all_conversations()
	for (var/datum/ntnet_conversation/conversation as anything in conversations)
		leave_conversation(conversation)

/datum/computer_file/program/chatclient/proc/forget_conversation(datum/ntnet_conversation/conversation)
	conversations -= conversation
	last_read -= conversation
	if (active_channel == conversation)
		active_channel = null

/datum/computer_file/program/chatclient/proc/ntnrc_alert(datum/ntnet_conversation/conversation, message)
	for (var/datum/computer_file/program/chatclient/client in conversation.clients)
		if (client == src || client.muted)
			continue
		client.computer.visible_notification(SPAN_NOTICE(message))
		client.computer.audible_notification("sound/machines/ping.ogg")

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
	data["username"] = C.username
	var/datum/ntnet_conversation/channel = C.active_channel
	if(channel)
		data["title"] = channel.title
		var/list/messages = list()
		for(var/M in channel.messages)
			messages.Add(list(list(
				"msg" = M
			)))
		data["messages"] = messages
		var/list/clients = list()
		for(var/datum/computer_file/program/chatclient/cl in channel.clients)
			clients.Add(list(list(
				"name" = cl.username
			)))
		data["clients"] = clients
		C.operator_mode = (channel.operator == C) ? TRUE : FALSE
		data["is_operator"] = C.operator_mode || C.netadmin_mode

	else // Channel selection screen
		var/list/all_channels = list()
		var/turf/turf = get_turf(C.computer.get_physical_host())
		var/list/connected_zs = GetConnectedZlevels(turf.z)
		for(var/datum/ntnet_conversation/conv in ntnet_global.chat_channels)
			if(conv && conv.title && (conv.source_z in connected_zs))
				all_channels.Add(list(list(
					"chan" = conv.title,
					"id" = conv.id,
					"joined" = (conv in C.conversations)
				)))
		data["all_channels"] = all_channels

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "ntnet_chat.tmpl", "NTNet Relay Chat Client", 575, 700, state = state)
		ui.auto_update_layout = 1
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)
