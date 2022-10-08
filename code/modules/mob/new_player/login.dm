/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if (config.motd)
		to_chat(src, "<div class=\"motd\">[config.motd]</div>", handle_whitespace=FALSE)
	to_chat(src, "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	GLOB.using_map.show_titlescreen(client)
	my_client = client
	set_sight(sight|SEE_TURFS)

	// Add to player list if missing
	if (!GLOB.player_list.Find(src))
		ADD_SORTED(GLOB.player_list, src, /proc/cmp_mob_key)

	new_player_panel()

	if(!SScharacter_setup.initialized)
		SScharacter_setup.newplayers_requiring_init += src
	else
		deferred_login()

// This is called when the charcter setup system has been sufficiently initialized and prefs are available.
// Do not make any calls in mob/Login which may require prefs having been loaded.
// It is safe to assume that any UI or sound related calls will fall into that category.
/mob/new_player/proc/deferred_login()
	if(client)
		client.playtitlemusic()
		maybe_send_staffwarns("connected as new player")
		if(client.get_preference_value(/datum/client_preference/goonchat) == GLOB.PREF_YES)
			client.chatOutput.start()
		if (client.byond_version < DM_VERSION)
			to_chat(src, SPAN_DANGER("You are running an older version of BYOND than the server and may experience issues."))
			to_chat(src, SPAN_DANGER("It is recommended that you update to at least [DM_VERSION] at http://www.byond.com/download/."))

	to_chat(src, SPAN_WARNING("If the title screen is black, resources are still downloading. Please be patient until the title screen appears."))

	if (config.event)
		to_chat(src, "<h1 class='alert'>Event</h1>")
		to_chat(src, "<h2 class='alert'>An event is taking place. OOC Info:</h2>")
		to_chat(src, "<span class='alert'>[config.event]</span>")
		to_chat(src, "<br>")

	if (client.holder)
		client.admin_memo_show()

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	var/decl/security_level/SL = security_state.current_security_level
	var/alert_desc = ""
	if(SL.up_description)
		alert_desc = SL.up_description
	to_chat(src, SPAN_NOTICE("The alert level on the [station_name()] is currently: <font color=[SL.light_color_alarm]><B>[SL.name]</B></font>. [alert_desc]"))

	if (client && GLOB.changelog_hash && client.prefs.lastchangelog != GLOB.changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		to_chat(src, SPAN_INFO("You have unread updates in the changelog."))
		winset(client, "rpane.changelog", "background-color=#eaeaea;font-style=bold")
		if(config.aggressive_changelog)
			client.changes()

	if (!winexists(client, "asset_cache_browser")) // The client is using a custom skin, tell them.
		to_chat(src, SPAN_WARNING("Unable to access asset cache browser, if you are using a custom skin file, please allow DS to download the updated version, if you are not, then make a bug report. This is not a critical issue but can cause issues with resource downloading, as it is impossible to know when extra resources arrived to you."))
