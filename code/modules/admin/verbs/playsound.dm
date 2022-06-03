var/global/list/sounds_cache = list()

/client/proc/play_sound(S as sound)
	set category = "Fun"
	set name = "Play Global Sound"
	if(!check_rights(R_SOUNDS))	return

	var/sound/uploaded_sound = sound(S, repeat = 0, wait = 1, channel = GLOB.admin_sound_channel)
	uploaded_sound.priority = 250

	sounds_cache += S
	var/volume = 100

	while (TRUE)
		volume = input(src, "Sound volume (0 - 100)", "Volume", volume) as null|num
		if (isnull(volume))
			return

		volume =  round(clamp(volume, 0, 100))
		to_chat(src, "Sound volume set to [volume]%")
		uploaded_sound.volume =volume
		var/choice = alert("Song: [S]", "Play Sound" , "Play", "Preview", "Cancel")

		if (choice == "Cancel")
			return

		if (choice == "Preview")
			sound_to(src, uploaded_sound)

		if (choice == "Play")
			break


	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]", 1)
	for(var/mob/M in GLOB.player_list)
		if(M.get_preference_value(/datum/client_preference/play_admin_midis) == GLOB.PREF_YES)
			sound_to(M, uploaded_sound)

/client/proc/play_local_sound(S as sound)
	set category = "Fun"
	set name = "Play Local Sound"
	if(!check_rights(R_SOUNDS))	return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]", 1)
	playsound(get_turf(src.mob), S, 50, 0, 0)


/client/proc/play_server_sound()
	set category = "Fun"
	set name = "Play Server Sound"
	if(!check_rights(R_SOUNDS))	return

	var/list/sounds = list("sound/items/bikehorn.ogg","sound/effects/siren.ogg")
	sounds += sounds_cache

	var/melody = input("Select a sound from the server to play", "Server sound list") as null|anything in sounds

	if(!melody)
		return

	play_sound(melody)
