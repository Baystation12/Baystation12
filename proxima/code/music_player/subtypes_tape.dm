//from infinity
/obj/item/music_tape/custom
	name = "dusty tape"
	desc = "A dusty tape, which can hold anything. Only thing you need to do is to blow the dust off and insert it into a compatible player."

/obj/item/music_tape/custom/attack_self(mob/user)
	if(!ruined && !track)
		if(setup_tape(user))
			log_and_message_admins("uploaded new sound <a href='?_src_=holder;listen_tape_sound=\ref[track.source]'>(preview)</a> in <a href='?_src_=holder;adminplayerobservefollow=\ref[src]'>\the [src]</a> with track name \"[track.title]\".")
		return
	..()

/obj/item/music_tape/custom/proc/setup_tape(mob/user)
	var/new_sound = input(user, "Select a track to upload. You should use only those audio formats which BYOND can accept. Ogg files are a good choice.", "Song Reminiscence: File") as null|sound
	if(isnull(new_sound))
		return FALSE

	var/new_name = input(user, "Name \the [src]:", "Song Reminiscence: Name", "Untitled") as null|text
	if(isnull(new_name))
		return FALSE

	new_name = sanitizeSafe(new_name)

	SetName("tape - \"[new_name]\"")

	if(new_sound && new_name && !track)
		track = new /jukebox_track(new_name, new_sound)
		return TRUE
	return FALSE
