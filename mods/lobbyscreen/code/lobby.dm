/datum/map
	var/base_lobby_html

/datum/map/proc/update_titlescreens()
	for(var/mob/new_player/player in GLOB.player_list)
		update_titlescreen(player.client)

/datum/map/proc/update_titlescreen(client/C)
	if (isnull(C))
		return

	var/state = Master.current_runlevel || 0
	var/mob/new_player/player = C.mob
	send_output(C, "[state]-[player.ready]", "lobbybrowser:setStatus")
	if (SScharacter_setup.initialized)
		var/char_name = C.prefs.real_name || "Random"
		char_name += C.prefs.job_high ? " ([C.prefs.job_high])" : null
		// We encode it twice becase of special characters and `byond bug id: 2399401`
		send_output(C, url_encode(url_encode(char_name)), "lobbybrowser:setCharacterName")


/mob/new_player/Topic(href, href_list)
	if (href_list["lobby_init"])
		GLOB.using_map.update_titlescreen(client)
		return TOPIC_HANDLED
	if (href_list["lobby_ready"])
		ready = !ready
		GLOB.using_map.update_titlescreen(client)
		return TOPIC_HANDLED
	if (href_list["change_character"])
		client.prefs.open_load_dialog(src, TRUE)
		return TOPIC_HANDLED
	if (href_list["lobby_wiki"])
		client.link_wiki()
		return TOPIC_HANDLED
	if (href_list["lobby_discord"])
		client.link_discord()
		return TOPIC_HANDLED
	if (href_list["lobby_changelog"])
		client.changes()
		return TOPIC_HANDLED
	if (href_list["lobby_github"])
		client.link_source()
		return TOPIC_HANDLED
	. = ..()


/hook/roundstart/proc/update_lobby_browsers()
	GLOB.using_map.update_titlescreens()
	return TRUE
