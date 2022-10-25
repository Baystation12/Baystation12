/mob/Logout()
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	GLOB.player_list -= src
	log_access("Logout: [key_name(src)]")
	handle_admin_logout()
	if(my_client)
		my_client.screen -= l_general

	RemoveRenderers()

	QDEL_NULL(l_general)
	hide_client_images()
	..()

	my_client = null
	logout_time = world.time
	return 1

/mob/proc/handle_admin_logout()
	if (GAME_STATE != RUNLEVEL_GAME)
		return
	var/datum/admins/holder = admin_datums[ckey]
	if (!holder)
		return
	message_staff("[holder.rank] logout: [key_name(src)]")
	if (length(GLOB.admins))
		return
	if (!config.delist_when_no_admins)
		return
	if (!config.hub_visible)
		return
	world.update_hub_visibility(FALSE)
