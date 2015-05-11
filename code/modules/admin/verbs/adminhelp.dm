
//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	if(say_disabled)	//This is here to try to identify lag problems
		usr << "\red Speech is currently admin-disabled."
		return

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		src << "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>"
		return

	adminhelped = 1 //Determines if they get the message to reply by clicking the name.

	src.verbs -= /client/verb/adminhelp

	spawn(300) // 30 Seconds
		src.verbs += /client/verb/adminhelp	// 2 minute cool-down for adminhelps//Go to hell

	var/msg
	var/list/type = list ("Gameplay/Roleplay", "Rule Issue", "Bug Report")
	var/selected_type = input("Pick a category.", "Admin Help", null, null) as null|anything in type
	if(selected_type)
		msg = input("Please enter your message:", "Admin Help", null, null) as text

	var/selected_upper = uppertext(selected_type)

	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the input msg
	if(!msg)
		return
	msg = sanitize(copytext(msg,1,MAX_MESSAGE_LEN))
	if(!msg)
		return
	var/original_msg = msg

	//explode the input msg into a list
	var/list/msglist = text2list(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	for(var/mob/M in mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = text2list(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isAI(found))
								ai_found = 1
							msg += "<b><font color='black'>[original_word] (<A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>?</A>)</font></b> "
							continue
			msg += "[original_word] "

	if(!mob) //this doesn't happen
		return

	var/ref_mob = "\ref[mob]"
	var/mentor_msg = "\blue <b><font color=red>[selected_upper]: </font>[get_options_bar(mob, 2, 0, 1, 0)][ai_found ? " (<A HREF='?_src_=holder;adminchecklaws=[ref_mob]'>CL</A>)" : ""]:</b> [msg]"
	var/dev_msg = "\blue <b><font color=red>[selected_upper]: </font>[get_options_bar(mob, 3, 0, 1, 0)][ai_found ? " (<A HREF='?_src_=holder;adminchecklaws=[ref_mob]'>CL</A>)" : ""]:</b> [msg]"
	msg = "\blue <b><font color=red>[selected_upper]: </font>[get_options_bar(mob, 2, 1, 1)][ai_found ? " (<A HREF='?_src_=holder;adminchecklaws=[ref_mob]'>CL</A>)" : ""]:</b> [msg]"

	var/admin_number_afk = 0

	var/list/mentorholders = list()
	var/list/debugholders = list()
	var/list/adminholders = list()
	for(var/client/X in admins)
		if(R_MENTOR & X.holder.rights && !(R_ADMIN & X.holder.rights)) // we don't want to count admins twice. This list should be JUST mentors
			mentorholders += X
			if(X.is_afk())
				admin_number_afk++
		if(R_DEV & X.holder.rights || R_DEBUG & X.holder.rights) // Looking for anyone with +Debug which will be admins, developers, and developer mentors
			debugholders += X
			if(!(R_ADMIN & X.holder.rights))
				if(X.is_afk())
					admin_number_afk++
		if(R_ADMIN & X.holder.rights) // just admins here please
			adminholders += X
			if(X.is_afk())
				admin_number_afk++

	switch(selected_type)
		if("Gameplay/Roleplay")
			if(mentorholders.len)
				for(var/client/X in mentorholders) // Mentors get a message without buttons and no character name
					if(X.prefs.toggles & SOUND_ADMINHELP)
						X << 'sound/effects/adminhelp.ogg'
					X << mentor_msg
			if(adminholders.len)
				for(var/client/X in adminholders) // Admins get the full monty
					if(X.prefs.toggles & SOUND_ADMINHELP)
						X << 'sound/effects/adminhelp.ogg'
					X << msg
		if("Rule Issue")
			if(mentorholders.len)
				for(var/client/X in mentorholders) // Mentors get a message without buttons and no character name
					if(X.prefs.toggles & SOUND_ADMINHELP)
						X << 'sound/effects/adminhelp.ogg'
					X << mentor_msg
			if(adminholders.len)
				for(var/client/X in adminholders) // Admins of course get everything in their helps
					if(X.prefs.toggles & SOUND_ADMINHELP)
						X << 'sound/effects/adminhelp.ogg'
					X << msg
		if("Bug Report")
			if(debugholders.len)
				for(var/client/X in debugholders)
					if(R_ADMIN | R_MOD & X.holder.rights) // Admins get every button & special highlights in theirs
						if(X.prefs.toggles & SOUND_ADMINHELP)
							X << 'sound/effects/adminhelp.ogg'
						X << msg
					else
						if (R_DEBUG & X.holder.rights) // Just devs or devmentors get non-highlighted names, but they do get JMP and VV for their bug reports.
							if(X.prefs.toggles & SOUND_ADMINHELP)
								X << 'sound/effects/adminhelp.ogg'
						X << dev_msg





	/*for(var/client/X in admins)
		if(R_MENTOR & X.holder.rights && !(R_ADMIN & X.holder.rights)) // we don't want to count admins twice. This list should be JUST mentors
			mentorholders += X
			if(X.is_afk())
				admin_number_afk++
		if(R_DEBUG & X.holder.rights) // Looking for anyone with +Debug which will be admins, developers, and developer mentors
			debugholders += X
			if(!(R_ADMIN & X.holder.rights))
				if(X.is_afk())
					admin_number_afk++
		if(R_ADMIN | R_MOD & X.holder.rights) // just admins here please
			adminholders += X
			if(X.is_afk())
				admin_number_afk++

	switch(selected_type)
		if("Gameplay/Roleplay question")
			if(mentorholders.len)
				for(var/client/X in mentorholders) // Mentors get a message without buttons and no character name
					if(X.prefs.toggles & SOUND_ADMINHELP)
						X << 'sound/effects/adminhelp.ogg'
					X << mentor_msg
			if(adminholders.len)
				for(var/client/X in adminholders) // Admins get the full monty
					if(X.prefs.toggles & SOUND_ADMINHELP)
						X << 'sound/effects/adminhelp.ogg'
					X << msg
		if("Rule/Gameplay issue")
			if(adminholders.len)
				for(var/client/X in adminholders) // Admins of course get everything in their helps
					if(X.prefs.toggles & SOUND_ADMINHELP)
						X << 'sound/effects/adminhelp.ogg'
					X << msg
		if("Bug report")
			if(debugholders.len)
				for(var/client/X in debugholders)
					if(R_ADMIN | R_MOD & X.holder.rights) // Admins get every button & special highlights in theirs
						if(X.prefs.toggles & SOUND_ADMINHELP)
							X << 'sound/effects/adminhelp.ogg'
						X << msg
					else
						if (R_DEBUG & X.holder.rights) // Just devs or devmentors get non-highlighted names, but they do get JMP and VV for their bug reports.
							if(X.prefs.toggles & SOUND_ADMINHELP)
								X << 'sound/effects/adminhelp.ogg'
						X << dev_msg
	for(var/client/X in admins)
		if((R_ADMIN|R_MOD|R_MENTOR) & X.holder.rights)
			if(X.is_afk())
				admin_number_afk++
			if(X.prefs.toggles & SOUND_ADMINHELP)
				X << 'sound/effects/adminhelp.ogg'
			if(X.holder.rights == R_MENTOR)
				X << mentor_msg		// Mentors won't see coloring of names on people with special_roles (Antags, etc.)
			else
				X << msg

	//show it to the person adminhelping too
	src << "<font color='blue'>PM to-<b>Staff </b>: [original_msg]</font>"

	var/admin_number_present = admins.len - admin_number_afk
	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admin_number_present] non-AFK admins.")
	if(admin_number_present <= 0)
		send2adminirc("Request for Help from [key_name(src)]: [html_decode(original_msg)] - !![admin_number_afk ? "All admins AFK ([admin_number_afk])" : "No admins online"]!!")
	else
		send2adminirc("Request for Help from [key_name(src)]: [html_decode(original_msg)]")
	feedback_add_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

