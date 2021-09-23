
//Hijacking this file for BS12 playernotes functions. ~ Chinsky.

/proc/notes_add(var/key, var/note, var/mob/user)
	if (!key || !note)
		return

	//Loading list of notes for this key
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	from_save(info, infos)
	if(!infos) infos = list()

	//Overly complex timestamp creation
	var/modifyer = "th"
	switch(time2text(world.timeofday, "DD"))
		if("01","21","31")
			modifyer = "st"
		if("02","22",)
			modifyer = "nd"
		if("03","23")
			modifyer = "rd"
	var/day_string = "[time2text(world.timeofday, "DD")][modifyer]"
	if(copytext(day_string,1,2) == "0")
		day_string = copytext(day_string,2)
	var/full_date = time2text(world.timeofday, "DDD, Month DD of YYYY")
	var/day_loc = findtext(full_date, time2text(world.timeofday, "DD"))

	var/datum/player_info/P = new
	if (ismob(user))
		P.author = user.key
		P.rank = user.client.holder.rank
	else if (istext(user))
		P.author = user
		P.rank = "Bot"
	else
		P.author = "Adminbot"
		P.rank = "Friendly Robot"
	P.content = note
	P.timestamp = "[copytext(full_date,1,day_loc)][day_string][copytext(full_date,day_loc+2)]"

	infos += P
	to_save(info, infos)

	message_staff("<span class='notice'>[P.author] has edited [key]'s notes.</span>")
	log_admin("[P.author] has edited [key]'s notes.")
	SSwebhooks.send(WEBHOOK_NOTES, list("admin" = P.author, "player" = key, "info" = note))

	del(info) // savefile, so NOT qdel

	//Updating list of keys with notes on them
	var/savefile/note_list = new("data/player_notes.sav")
	var/list/note_keys
	from_save(note_list, note_keys)
	if(!note_keys) note_keys = list()
	if(!list_find(note_keys, key)) note_keys += key
	to_save(note_list, note_keys)
	del(note_list) // savefile, so NOT qdel


/proc/notes_del(var/key, var/index)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	from_save(info, infos)
	if(!infos || infos.len < index) return

	var/datum/player_info/item = infos[index]
	infos.Remove(item)
	to_save(info, infos)

	message_staff("<span class='notice'>[key_name_admin(usr)] deleted one of [key]'s notes.</span>")
	log_admin("[key_name(usr)] deleted one of [key]'s notes.")

	del(info) // savefile, so NOT qdel

/proc/show_player_info_irc(var/key as text)
	var/dat = "          Info on [key]\n"
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	from_save(info, infos)
	if(!infos)
		dat = "No information found on the given key."
	else
		for(var/datum/player_info/I in infos)
			dat += "[I.content]\nby [I.author] ([I.rank]) on [I.timestamp]\n\n"

	return list2params(list(dat))
