/mob/Logout()
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	GLOB.player_list -= src
	log_access("Logout: [key_name(src)]")
	handle_admin_logout()
	if(my_client)
		my_client.screen -= darksight
	ClearRenderers()

	QDEL_NULL(darksight)
	hide_client_images()
	..()

	my_client = null
	logout_time = world.time
	return 1

/mob/proc/handle_admin_logout()
	if(admin_datums[ckey] && GAME_STATE == RUNLEVEL_GAME) //Only report this stuff if we are currently playing.
		var/datum/admins/holder = admin_datums[ckey]
		message_staff("[holder.rank] logout: [key_name(src)]")
		if(!length(GLOB.admins)) //Apparently the admin logging out is no longer an admin at this point, so we have to check this towards 0 and not towards 1. Awell.
			send_to_admin_discord(EXCOM_MSG_AHELP, "[key_name(src, highlight_special_characters = FALSE)] logged out - no more admins online.")
			if(config.delist_when_no_admins && config.hub_visible)
				world.update_hub_visibility(FALSE)
				send_to_admin_discord(EXCOM_MSG_AHELP, "Updated hub visibility. The server is now invisible.")
