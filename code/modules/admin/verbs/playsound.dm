/client/proc/play_sound(S as sound)
	set category = "Fun"
	set name = "Play Global Sound"

	if(!src.holder)
		src << "Only administrators may use this command."
		return

	var/sound/uploaded_sound = sound(S, repeat = 0, wait = 1, channel = 777)
	uploaded_sound.priority = 250

	if(src.holder.rank == "Game Master" || src.holder.rank == "Game Admin" || src.holder.rank == "Badmin")
		log_admin("[key_name(src)] played sound [S]")
		message_admins("[key_name_admin(src)] played sound [S]", 1)
		for(var/mob/M in player_list)
			if(M.client.midis)
				M << uploaded_sound
	else
		if(usr.client.canplaysound)
			usr.client.canplaysound = 0
			log_admin("[key_name(src)] played sound [S]")
			message_admins("[key_name_admin(src)] played sound [S]", 1)
			for(var/mob/M in player_list)
				if(M.client.midis)
					M << uploaded_sound
		else
			usr << "You already used up your jukebox monies this round!"
			del(uploaded_sound)
	feedback_add_details("admin_verb","PGS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"

	if(!src.holder)
		src << "Only administrators may use this command."
		return

	if(src.holder.rank == "Game Master" || src.holder.rank == "Game Admin")
		log_admin("[key_name(src)] played a local sound [S]")
		message_admins("[key_name_admin(src)] played a local sound [S]", 1)
		playsound(get_turf_loc(src.mob), S, 50, 0, 0)
		return
	feedback_add_details("admin_verb","PLS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/*
/client/proc/cuban_pete()
	set category = "Fun"
	set name = "Cuban Pete Time"

	message_admins("[key_name_admin(usr)] has declared Cuban Pete Time!", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'cubanpetetime.ogg'

	for(var/mob/living/carbon/human/CP in world)
		if(CP.real_name=="Cuban Pete" && CP.key!="Rosham")
			CP << "Your body can't contain the rhumba beat"
			CP.gib()


/client/proc/bananaphone()
	set category = "Fun"
	set name = "Banana Phone"

	message_admins("[key_name_admin(usr)] has activated Banana Phone!", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'bananaphone.ogg'


client/proc/space_asshole()
	set category = "Fun"
	set name = "Space Asshole"

	message_admins("[key_name_admin(usr)] has played the Space Asshole Hymn.", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'space_asshole.ogg'


client/proc/honk_theme()
	set category = "Fun"
	set name = "Honk"

	message_admins("[key_name_admin(usr)] has creeped everyone out with Blackest Honks.", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'honk_theme.ogg'*/
