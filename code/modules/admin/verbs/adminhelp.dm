

//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an", "monkey", "alien", "as")

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>"
		return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	/**src.verbs -= /client/verb/adminhelp
	spawn(1200)
		src.verbs += /client/verb/adminhelp	// 2 minute cool-down for adminhelps//Go to hell
	**/

	if(!msg)	return
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if (!msg)	return

	var/original_msg = msg

	//The symbol � (fancy multiplication sign) will be used to mark where to put replacements, so the original message must not contain it.
	msg = dd_replacetext(msg, "�", "")
	msg = dd_replacetext(msg, "HOLDERREF", "HOLDER-REF") //HOLDERREF is a key word which gets replaced with the admin's holder ref later on, so it mustn't be in the original message
	msg = dd_replacetext(msg, "ADMINREF", "ADMIN-REF") //ADMINREF is a key word which gets replaced with the admin's client's ref. So it mustn't be in the original message.

	var/list/msglist = dd_text2list(msg, " ")

	var/list/mob/mobs = list()

	for(var/mob/M in mob_list)
		mobs += M

	var/list/replacement_value = list()		//When a word match is found, the word matched will get replaced with an � (fancy multiplication symbol).
											//This list will contain a list of values which the � will be replaced with in the same order as indexes in this list.
											//So if this list has the value list("John","Jane") and msg is, at the end, "This is � and he griffed �" the text to
											//display will be "This is John and he griffe Jane". The strings in this list are a bit more complex than 'John' and 'Jane' tho.

	var/ai_found = 0 //If an AI name or 'ai' word is found in the text, the additional (CL) = Check Laws button gets added. Not added every time so it doesn't spam.

	//we will try to locate each word of the message in our lists of names and clients
	//for each mob that we have found
	//split the mob's info into a list. "John Arnolds" becomes list("John","Arnolds") so we can iterate through this
	//for each of the name parts IE. "John", "Arnolds", etc. in the current name.
	for(var/i = 1; i <= msglist.len; i++)
		var/word = msglist[i]
		var/original_word = word
		word = dd_replacetext(word, ".", "")
		word = dd_replacetext(word, ",", "")
		word = dd_replacetext(word, "!", "")
		word = dd_replacetext(word, "?", "")	//Strips some common punctuation characters so the actual word can be better compared.
		word = dd_replacetext(word, ";", "")
		word = dd_replacetext(word, ":", "")
		word = dd_replacetext(word, "(", "")
		word = dd_replacetext(word, ")", "")
		if(lowertext(word) in adminhelp_ignored_words)
			continue
		if(lowertext(word) == "ai")
			ai_found = 1
			continue
		for(var/mob/M in mobs)
			var/list/namelist = dd_text2list("[M.name] [M.real_name] [(M.mind)?"[M.mind.name]":""] [M.ckey] [M.key]", " ")
			var/word_is_match = 0 //Used to break from this mob for loop if a match is found
			for(var/namepart in namelist)
				if( lowertext(word) == lowertext(namepart) )
					msglist[i] = "�"
					var/description_string = "<b><font color='black'>[original_word] (<A HREF='?src=HOLDERREF;adminmoreinfo=\ref[M]'>?</A>)</font></b>"
					replacement_value += description_string
					mobs -= M //If a mob is found then remove it from the list of mobs, so we don't get the same mob reported a million times.
					word_is_match = 1
					break
			if(word_is_match)
				if(isAI(M))
					ai_found = 1
				break //Breaks execution of the mob loop, since a match was already found.

	var/j = 1 //index to the next element in the replacement_value list
	for(var/i = 1; i <= msglist.len; i++)
		var/word = msglist[i]
		if(word == "�")
			msglist[i] = replacement_value[j]
			j++

	msg = dd_list2text(msglist, " ")
	var/admin_number = 0
	var/admin_number_afk = 0

	if(mob)
		var/ref_mob = "\ref[src.mob]"
		for (var/client/X)
			if (X.holder)
				admin_number++
				if( X.inactivity > AFK_THRESHOLD ) //When I made this, the AFK_THRESHOLD was 3000ds = 300s = 5m, see setup.dm for the new one.
					admin_number_afk++
				if(X.holder.sound_adminhelp)
					X << 'sound/effects/adminhelp.ogg'
				var/check_laws_text = ""
				if(ai_found)
					check_laws_text = (" (<A HREF='?src=\ref[X.holder];adminchecklaws=[ref_mob]'>CL</A>)")

				var/msg_to_send = "\blue <b><font color=red>HELP: </font>[key_name(src, X)] (<A HREF='?src=\ref[X.holder];adminmoreinfo=[ref_mob]'>?</A>) (<A HREF='?src=\ref[X.holder];adminplayeropts=[ref_mob]'>PP</A>) (<A HREF='?src=\ref[X.holder];adminplayervars=[ref_mob]'>VV</A>) (<A HREF='?src=\ref[X.holder];adminplayersubtlemessage=[ref_mob]'>SM</A>) (<A HREF='?src=\ref[X.holder];adminplayerobservejump=[ref_mob]'>JMP</A>) (<A HREF='?src=\ref[X.holder];secretsadmin=check_antagonist'>CA</A>) [check_laws_text]:</b> [msg]"
				msg_to_send = dd_replacetext(msg_to_send, "HOLDERREF", "\ref[X.holder]")
				msg_to_send = dd_replacetext(msg_to_send, "ADMINREF", "\ref[X]")
				X << msg_to_send
	else
		var/ref_client = "\ref[src]"
		for (var/client/X)
			if (X.holder)
				admin_number++
				if( X.inactivity > AFK_THRESHOLD ) //When I made this, the AFK_THRESHOLD was 3000ds = 300s = 5m, see setup.dm for the new one.
					admin_number_afk++
				if(X.holder.sound_adminhelp)
					X << 'sound/effects/adminhelp.ogg'
				var/msg_to_send = "\blue <b><font color=red>HELP: </font>[key_name(src, X)] (<A HREF='?src=\ref[X.holder];adminplayervars=[ref_client]'>VV</A>) (<A HREF='?src=\ref[X.holder];secretsadmin=check_antagonist'>CA</A>):</b> [msg]"
				msg_to_send = dd_replacetext(msg_to_send, "HOLDERREF", "\ref[X.holder]")
				msg_to_send = dd_replacetext(msg_to_send, "ADMINREF", "\ref[X]")
				X << msg_to_send

	src << "<font color='blue'>PM to-<b>Admins</b>: [original_msg]</font>"
	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admin_number] non-AFK admins.")
	if((admin_number - admin_number_afk) <= 0)
		if(!admin_number_afk)
			send2irc(ckey, "[original_msg] - No admins online")
		else
			send2irc(ckey, "[original_msg] - All admins AFK ([admin_number_afk])")
	feedback_add_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

proc/send2irc(msg,msg2)
	if(config.useircbot)
		shell("python [config.nudge_script_path] [msg] [msg2]")
	return