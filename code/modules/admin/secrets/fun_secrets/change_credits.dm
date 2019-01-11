GLOBAL_VAR_INIT(end_credits_song, null)
GLOBAL_VAR_INIT(end_credits_title, null)

/datum/admin_secret_item/fun_secret/change_credits_song
	name = "Change End Credits Song"
/datum/admin_secret_item/fun_secret/change_credits_title
	name = "Change End Credits Title"

/datum/admin_secret_item/fun_secret/change_credits_song/do_execute()
	var/list/sounds = file2list("sound/serversound_list.txt");
	sounds += "Cancel"
	sounds += sounds_cache

	GLOB.end_credits_song = input("Select a sound from the server to play", "Server sound list", "Cancel") in sounds

	if(GLOB.end_credits_song == "Cancel")
		GLOB.end_credits_song = null

	SSstatistics.add_field_details("admin_verb","CECS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/datum/admin_secret_item/fun_secret/change_credits_title/do_execute()
	GLOB.end_credits_title = input(usr, "What title would you like for the end credits?") as null|text

	if(!GLOB.end_credits_title)
		return

	SSstatistics.add_field_details("admin_verb","CECT") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!