/mob/proc/update_login_details()
	last_address = client.address
	last_cid = client.computer_id
	last_ckey = ckey
	if (config.log_access)
		var/log_addr = last_address ? last_address : "localhost"
		log_access("Login: [key_name(src)] from [log_addr]-[last_cid] || BYOND v[client.byond_version]")
	if (ckey in config.skip_conn_warn_ckey_list)
		return
	var/warn_cid = !config.skip_conn_warn_cid_all && !(last_cid in config.skip_conn_warn_cid_list)
	var/warn_address = !config.skip_conn_warn_address_all && !(last_address in config.skip_conn_warn_address_list)
	var/skip_ckey = islist(config.skip_conn_warn_ckey_list)
	if (!warn_cid && !warn_address)
		return
	var/list/warn = list()
	for (var/mob/other as anything in GLOB.player_list)
		if (other == src)
			continue
		if (other.key == key)
			continue
		if (skip_ckey && (ckey(other.key) in config.skip_conn_warn_ckey_list))
			continue
		if (warn_address && other.last_address == last_address)
			warn[other] += list("ADDR")
		if (warn_cid && other.last_cid == last_cid)
			warn[other] += list("CID")
	if (!length(warn))
		return
	for (var/i = 1 to length(warn))
		var/mob/other = warn[i]
		warn[i] = "[key_name(other, TRUE)] \[[jointext(warn[other], ", ")]\]"
	message_admins("Notice: [key_name(src, TRUE)] shares connection details:\n•  [jointext(warn, "\n•  ")]")
	if (config.skip_conn_warn_client)
		return
	if (client.warned_about_multikeying)
		return
	client.warned_about_multikeying = TRUE
	spawn (2 SECONDS)
		to_chat(src, SPAN_WARNING(config.conn_warn_client_message))


/mob/proc/maybe_send_staffwarns(action)
	if(client?.staffwarn)
		for(var/client/C as anything in GLOB.admins)
			send_staffwarn(C, action)

/mob/proc/send_staffwarn(client/C, action, noise = 1)
	if(check_rights((R_ADMIN|R_MOD),0,C))
		to_chat(C,"[SPAN_CLASS("staffwarn", "StaffWarn: [client.ckey] [action]")]<br>[SPAN_NOTICE("[client.staffwarn]")]")
		if(noise && C.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR)
			sound_to(C, sound('sound/ui/pm-notify.ogg', volume = 25))

/mob
	var/client/my_client // Need to keep track of this ourselves, since by the time Logout() is called the client has already been nulled
	/// Integer or null. Stores the `world.time` value at the time of `Logout()`. If `null`, the mob is either considered logged in or has never logged out.
	var/logout_time = null

/mob/Login()

	// Add to player list if missing
	if (!GLOB.player_list.Find(src))
		ADD_SORTED(GLOB.player_list, src, GLOBAL_PROC_REF(cmp_mob_key))

	update_login_details()
	world.update_status()

	maybe_send_staffwarns("joined the round")

	client.images = null				//remove the images such as AIs being unable to see runes
	client.screen = list()				//remove hud items just in case
	InitializeHud()

	next_move = 1
	set_sight(sight|SEE_SELF)

	client.statobj = src

	my_client = client
	logout_time = null

	if(loc && !isturf(loc))
		client.eye = loc
		client.perspective = EYE_PERSPECTIVE
	else
		client.eye = src
		client.perspective = MOB_PERSPECTIVE

	if(eyeobj)
		eyeobj.possess(src)

	darksight = new()
	client.screen += darksight

	AddDefaultRenderers()

	refresh_client_images()
	reload_fullscreen() // Reload any fullscreen overlays this mob has.
	add_click_catcher()
	update_action_buttons()
	update_mouse_pointer()

	if(machine)
		machine.on_user_login(src)

	if (SScharacter_setup.initialized && SSchat.initialized && !isnull(client.chatOutput))
		if(client.get_preference_value(/datum/client_preference/goonchat) == GLOB.PREF_YES)
			client.chatOutput.start()

	if(ability_master)
		ability_master.update_abilities(1, src)
		ability_master.toggle_open(1)

	//set macro to normal incase it was overriden (like cyborg currently does)
	winset(src, null, "mainwindow.macro=macro hotkey_toggle.is-checked=false input.focus=true input.background-color=[client.input_mode_color()]")

	if(mind)
		if(!mind.learned_spells)
			mind.learned_spells = list()
		if(ability_master && ability_master.spell_objects)
			for(var/obj/screen/ability/spell/screen in ability_master.spell_objects)
				var/spell/S = screen.spell
				mind.learned_spells |= S

	client.update_skybox(1)
	GLOB.logged_in_event.raise_event(src)


/mob/living/carbon/Login()
	..()
	if(internals && internal)
		internals.icon_state = "internal1"

/mob/observer/ghost/Login()
	..()
	if(darksight)
		darksight.icon_state = "ghost"
		darksight.alpha = 127
		darksight.SetTransform(2) //Max darksight
