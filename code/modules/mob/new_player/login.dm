/mob/new_player/Login()
	update_Login_details()	//handles setting lastKnownIP and computer_id for use by the ban systems as well as checking for multikeying
	if(join_motd)
		to_chat(src, "<div class=\"motd\">[join_motd]</div>")
	to_chat(src, "<div class='info'>Game ID: <div class='danger'>[game_id]</div></div>")

	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	loc = null
	GLOB.using_map.show_titlescreen(client)
	my_client = client
	set_sight(sight|SEE_TURFS)
	GLOB.player_list |= src

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
		handle_privacy_poll()
		client.playtitlemusic()
		maybe_send_staffwarns("connected as new player")

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	var/decl/security_level/SL = security_state.current_security_level
	var/alert_desc = ""
	if(SL.up_description)
		alert_desc = SL.up_description
	to_chat(src, "<span class='notice'>The alert level on the [station_name()] is currently: <font color=[SL.light_color_alarm]><B>[SL.name]</B></font>. [alert_desc]</span>")