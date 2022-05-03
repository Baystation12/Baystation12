GLOBAL_VAR_INIT(end_credits_song, null)
GLOBAL_VAR_INIT(end_credits_title, null)

/datum/admin_secret_item/fun_secret/change_credits_song
	name = "Change End Credits Song"


/datum/admin_secret_item/fun_secret/change_credits_song/do_execute()
	set waitfor = FALSE
	var/list/available = decls_repository.get_decls_of_subtype(/decl/audio/track)
	var/list/tracks = list()
	for (var/key in available)
		var/decl/audio/track/track = available[key]
		tracks[track.title] = track
	available = null
	var/data = input(usr, "Select Credits Track", "Credits Track") as null | anything in tracks
	if (isnull(data))
		return
	var/decl/audio/track/track = tracks[tracks]
	if (!track)
		return
	GLOB.end_credits_song = track.source



/datum/admin_secret_item/fun_secret/change_credits_title
	name = "Change End Credits Title"


/datum/admin_secret_item/fun_secret/change_credits_title/do_execute()
	set waitfor = FALSE
	var/data = input(usr, "Enter Credits Title", "Credits Title") as null | text
	if (isnull(data))
		return
	if (data == "")
		data = null
	GLOB.end_credits_title = data
