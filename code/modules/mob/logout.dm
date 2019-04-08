/mob/Logout()
	SSnano.user_logout(src) // this is used to clean up (remove) this user's Nano UIs
	GLOB.player_list -= src
	log_access("Logout: [key_name(src)]")
	if(my_client)
		my_client.screen -= l_general
		my_client.screen -= l_plane
	QDEL_NULL(l_general)
	QDEL_NULL(l_plane)
	hide_client_images()
	..()

	my_client = null
	return 1
