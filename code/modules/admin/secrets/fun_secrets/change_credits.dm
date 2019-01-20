GLOBAL_VAR_INIT(end_credits_song, null)
GLOBAL_VAR_INIT(end_credits_title, null)

/datum/admin_secret_item/fun_secret/change_credits_song
	name = "Change End Credits Song"
/datum/admin_secret_item/fun_secret/change_credits_title
	name = "Change End Credits Title"

/datum/admin_secret_item/fun_secret/change_credits_song/do_execute()
	GLOB.end_credits_song = input(usr, "What song would you like for the end credits? (Please specify path to file)") as null|text
	if(!GLOB.end_credits_song)
		return

/datum/admin_secret_item/fun_secret/change_credits_title/do_execute()
	GLOB.end_credits_title = input(usr, "What title would you like for the end credits?") as null|text

	if(!GLOB.end_credits_title)
		return

