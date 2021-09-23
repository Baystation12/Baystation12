#define NEWSCAST_HOME 1
#define NEWSCAST_VIEW_CHANNEL 2

/datum/computer_file/program/newscast
	filename = "newscast"
	filedesc = "Newscast"
	program_icon_state = "generic"
	program_menu_icon = "image"
	extended_desc = "A newsfeed browser that connects to standard channels, including personalized recommendations that you can't turn off! Requires a connection to NTNet."
	size = 4 // Cloud-based, but requires the software to actually fetch the data
	requires_ntnet = TRUE
	available_on_ntnet = TRUE
	usage_flags = PROGRAM_ALL
	nanomodule_path = /datum/nano_module/program/newscast

/datum/nano_module/program/newscast
	name = "Newscast"
	var/prog_state = NEWSCAST_HOME
	var/notifs_enabled = TRUE
	var/datum/feed_channel/active_channel
	var/datum/feed_network/connected_group

/datum/nano_module/program/newscast/proc/news_alert(announcement)
	if (!notifs_enabled || !announcement)
		return
	program.computer.visible_notification(announcement)
	program.computer.audible_notification("sound/machines/twobeep.ogg")

/datum/nano_module/program/newscast/Destroy()
	if (connected_group)
		LAZYREMOVE(connected_group.news_programs, src)
	. = ..()

/datum/nano_module/program/newscast/Topic(href, href_list)
	if(..())
		return TRUE

	if (href_list["view_channel"])
		// We cache a byond text ref of the selected channel, and use it here to get a proper DM pointer to that channel
		var/datum/feed_channel/new_feed = locate(href_list["view_channel"]) in connected_group.network_channels
		if (istype(new_feed))
			active_channel = new_feed // and then if it's valid, it becomes our new active channel
			prog_state = NEWSCAST_VIEW_CHANNEL
		return TRUE
	
	else if (href_list["view_photo"])
		var/datum/feed_message/story = locate(href_list["view_photo"]) in active_channel.messages
		if (istype(story) && story.img)
			send_rsc(usr, story.img, "tmp_photo.png")
			var/output = "<html><head><title>photo - [story.author]</title></head>"
			output += "<body style='overflow:hidden; margin:0; text-align:center'>"
			output += "<img src='tmp_photo.png' width='192' style='-ms-interpolation-mode:nearest-neighbor' />"
			output += "</body></html>"
			show_browser(usr, output, "window=book; size=192x192]")
		return TRUE
	
	else if (href_list["toggle_notifs"])
		notifs_enabled = !notifs_enabled
		return TRUE

	else if (href_list["return_to_home"])
		active_channel = null
		prog_state = NEWSCAST_HOME
		return TRUE 
		
	return FALSE

/datum/nano_module/program/newscast/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, state = GLOB.default_state)
	var/list/data = host.initial_data()

	var/datum/computer_file/program/newscast/prog = program
	var/turf/T = get_turf(prog.computer.get_physical_host())
	if (!connected_group) // Look for a network connected to these z-levels
		for (var/datum/feed_network/G in news_network)
			if (T.z in G.z_levels)
				connected_group = G
				LAZYADD(G.news_programs, src)
				break
	else if (!(T.z in connected_group.z_levels)) // Lose our tracked group if we leave the network range but still have a connection
		prog.computer.visible_error("Newscaster connection lost. Attempting to re-establish.")
		LAZYREMOVE(connected_group.news_programs, src)
		connected_group = null

	if (!connected_group) // If we still fail to find a network, throw an error with no other data
		data["has_network"] = FALSE
	else // Otherwise, gather the data from the network
		data["has_network"] = TRUE
		data["notifs_enabled"] = notifs_enabled
		data["prog_state"] = prog_state
		data["time_blurb"] = "The date is <b>[stationdate2text()]</b> at <b>[stationtime2text()]</b>."
		data["notifs_blurb"] = "New story notifications are <b>[notifs_enabled ? "enabled" : "disabled"]</b>."
		data["dnotice_blurb"] = "<h2><font color='red'>CHANNEL LOCKED</h2><br>\
		This channel has been deemed as threatening to the welfare of the [station_name()], and marked with a [GLOB.using_map.company_name] D-Notice.<br><br> \
		Stories may not be published or viewed while the D-Notice is in effect. For further information, please contact the network administrator or a security representative.</font>"

		data["channels"] = list()
		data["active_channels"] = list() // There will only ever be one active channel, but we use this for unified handling in nanoUI
		for(var/datum/feed_channel/channel in connected_group.network_channels)
			var/list/channel_data = list()
			channel_data["name"] = channel.channel_name
			channel_data["admin"] = channel.is_admin_channel
			channel_data["censored"] = channel.censored
			channel_data["author"] = channel.author
			channel_data["ref"] = "\ref[channel]"
			
			data["channels"] += list(channel_data)
			if (channel == active_channel)
				data["active_channels"] += list(channel_data)
			
		if (active_channel)
			var/datum/feed_channel/feed = active_channel
			data["active_channel"] = feed
			data["active_stories"] = list()
			for (var/i = 1 to length(feed.messages))
				var/datum/feed_message/message = feed.messages[i]
				var/list/story = list()
				story["author"] = message.author
				story["body"] = message.body
				story["timestamp"] = message.time_stamp
				story["has_photo"] = message.img != null
				if (user && message.img) // user check here to avoid runtimes
					var/resource_name = "newscaster_photo_[sanitize(feed.channel_name)]_[i].png"
					send_asset(user.client, resource_name)
					story["photo_dat"] = "<img src='[resource_name]' width='180'><br>"
				story["story_ref"] = "\ref[message]"
				data["active_stories"] += list(story)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "newscast.tmpl", name, 450, 600, state = state)
		ui.auto_update_layout = 1
		ui.set_auto_update(1)
		ui.set_initial_data(data)
		ui.open()

#undef NEWSCAST_HOME
#undef NEWSCAST_VIEW_CHANNEL