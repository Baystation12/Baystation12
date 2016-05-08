/mob/Logout()
	nanomanager.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	tgui_process.on_logout(src)
	player_list -= src
	log_access("Logout: [key_name(src)]")
	handle_admin_logout()
	hide_client_images()
	..()

	return 1

/mob/proc/handle_admin_logout()
	if(admin_datums[src.ckey] && ticker && ticker.current_state == GAME_STATE_PLAYING) //Only report this stuff if we are currently playing.
		var/admins_number = admins.len
		message_admins("Admin logout: [key_name(src)]")
		if(admins_number == 0) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
			send2adminirc("[key_name(src)] logged out - no more admins online.")
			if(config.delist_when_no_admins && world.visibility)
				world.visibility = FALSE
				send2adminirc("Toggled hub visibility. The server is now invisible ([world.visibility]).")
