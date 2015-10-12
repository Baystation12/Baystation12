//This stuff was originally intended to be integrated into the ban-system I was working on
//but it's safe to say that'll never be finished. So I've merged it into the current player panel.
//enjoy				~Carn
/*
#define NOTESFILE "data/player_notes.sav"	//where the player notes are saved

datum/admins/proc/notes_show(var/ckey)
	usr << browse("<head><title>Player Notes</title></head><body>[notes_gethtml(ckey)]</body>","window=player_notes;size=700x400")


datum/admins/proc/notes_gethtml(var/ckey)
	var/savefile/notesfile = new(NOTESFILE)
	if(!notesfile)	return "<font color='red'>Error: Cannot access [NOTESFILE]</font>"
	if(ckey)
		. = "<b>Notes for <a href='?src=\ref[src];notes=show'>[ckey]</a>:</b> <a href='?src=\ref[src];notes=add;ckey=[ckey]'>\[+\]</a> <a href='?src=\ref[src];notes=remove;ckey=[ckey]'>\[-\]</a><br>"
		notesfile.cd = "/[ckey]"
		var/index = 1
		while( !notesfile.eof )
			var/note
			notesfile >> note
			. += "[note] <a href='?src=\ref[src];notes=remove;ckey=[ckey];from=[index]'>\[-\]</a><br>"
			index++
	else
		. = "<b>All Notes:</b> <a href='?src=\ref[src];notes=add'>\[+\]</a> <a href='?src=\ref[src];notes=remove'>\[-\]</a><br>"
		notesfile.cd = "/"
		for(var/dir in notesfile.dir)
			. += "<a href='?src=\ref[src];notes=show;ckey=[dir]'>[dir]</a><br>"
	return

//handles removing entries from the buffer, or removing the entire directory if no start_index is given
/proc/notes_remove(var/ckey, var/start_index, var/end_index)
	var/savefile/notesfile = new(NOTESFILE)
	if(!notesfile)	return

	if(!ckey)
		notesfile.cd = "/"
		ckey = ckey(input(usr,"Who would you like to remove notes for?","Enter a ckey",null) as null|anything in notesfile.dir)
		if(!ckey)	return

	if(start_index)
		notesfile.cd = "/[ckey]"
		var/list/noteslist = list()
		if(!end_index)	end_index = start_index
		var/index = 0
		while( !notesfile.eof )
			index++
			var/temp
			notesfile >> temp
			if( (start_index <= index) && (index <= end_index) )
				continue
			noteslist += temp

		notesfile.eof = -2		//Move to the start of the buffer and then erase.

		for( var/note in noteslist )
			notesfile << note
	else
		notesfile.cd = "/"
		if(alert(usr,"Are you sure you want to remove all their notes?","Confirmation","No","Yes - Remove all notes") == "Yes - Remove all notes")
			notesfile.dir.Remove(ckey)
	return

#undef NOTESFILE
*/

//Hijacking this file for BS12 playernotes functions. I like this ^ one systemm alright, but converting sounds too bothersome~ Chinsky.

/proc/notes_add(var/key, var/note, var/mob/user)
	if (!key || !note)
		return

	//Loading list of notes for this key
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
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
	if (user)
		P.author = user.key
		P.rank = user.client.holder.rank
	else
		P.author = "Adminbot"
		P.rank = "Friendly Robot"
	P.content = note
	P.timestamp = "[copytext(full_date,1,day_loc)][day_string][copytext(full_date,day_loc+2)]"

	infos += P
	info << infos

	message_admins("\blue [key_name_admin(user)] has edited [key]'s notes.")
	log_admin("[key_name(user)] has edited [key]'s notes.")

	del(info) // savefile, so NOT qdel

	//Updating list of keys with notes on them
	var/savefile/note_list = new("data/player_notes.sav")
	var/list/note_keys
	note_list >> note_keys
	if(!note_keys) note_keys = list()
	if(!note_keys.Find(key)) note_keys += key
	note_list << note_keys
	del(note_list) // savefile, so NOT qdel


/proc/notes_del(var/key, var/index)
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos || infos.len < index) return

	var/datum/player_info/item = infos[index]
	infos.Remove(item)
	info << infos

	message_admins("\blue [key_name_admin(usr)] deleted one of [key]'s notes.")
	log_admin("[key_name(usr)] deleted one of [key]'s notes.")

	qdel(info)

/proc/show_player_info_irc(var/key as text)
	var/dat = "          Info on [key]\n"
	var/savefile/info = new("data/player_saves/[copytext(key, 1, 2)]/[key]/info.sav")
	var/list/infos
	info >> infos
	if(!infos)
		dat = "No information found on the given key."
	else
		for(var/datum/player_info/I in infos)
			dat += "[I.content]\nby [I.author] ([I.rank]) on [I.timestamp]\n\n"

	return list2params(list(dat))
