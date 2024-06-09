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

	AddDefaultRenderers()

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
		if(client.get_preference_value(/datum/client_preference/goonchat) == GLOB.PREF_YES)
			client.chatOutput.start()

	var/singleton/security_state/security_state = GET_SINGLETON(GLOB.using_map.security_state)
	var/singleton/security_level/SL = security_state.current_security_level
	var/alert_desc = ""
	if(SL.up_description)
		alert_desc = SL.up_description
	to_chat(src, SPAN_NOTICE("The alert level on the [station_name()] is currently: [SPAN_COLOR(SL.light_color_alarm, "<B>[SL.name]</B>")]. [alert_desc]"))
