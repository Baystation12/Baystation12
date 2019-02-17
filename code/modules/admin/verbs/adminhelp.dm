
//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

/proc/generate_ahelp_key_words(var/mob/mob, var/msg)
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	for(var/mob/M in SSmobs.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
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
				if(word == "ai" && !ai_found)
					ai_found = 1
					msg += "<b>[original_word] <A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A></b> "
					continue
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							msg += "<b>[original_word] <A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>(?)</A>"
							if(!ai_found && isAI(found))
								ai_found = 1
								msg += " <A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A>"
							msg += "</b> "
							continue
			msg += "[original_word] "

	return msg

/client/verb/adminhelp()
	set category = "Admin"
	set name = "Adminhelp"

// Select a category
	var/msg
	var/list/type = list ("Gameplay and Rules", "Development and Bugs", "Other")
	var/selected_type = input("Pick a category. (If no staff are present other than developers, please choose Other)", "Admin Help", null, null) as null|anything in type
	if(selected_type)
		msg = input("Please enter your message:", "Admin Help", null, null) as text

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>")
		return

	adminhelped = 1 //Determines if they get the message to reply by clicking the name.


	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return
	var/original_msg = msg


	if(!mob) //this doesn't happen
		return

	//generate keywords lookup
	msg = generate_ahelp_key_words(mob, msg)

	// handle ticket
	var/datum/client_lite/client_lite = client_repository.get_lite_client(src)
	var/datum/ticket/ticket = get_open_ticket_by_client(client_lite)
	if(!ticket)
		ticket = new /datum/ticket(client_lite)
	else if(ticket.status == TICKET_ASSIGNED)
		// manually check that the target client exists here as to not spam the usr for each logged out admin on the ticket
		var/admin_found = 0
		for(var/datum/client_lite/admin in ticket.assigned_admins)
			var/client/admin_client = client_by_ckey(admin.ckey)
			if(admin_client)
				admin_found = 1
				src.cmd_admin_pm(admin_client, original_msg, ticket)
				break
		if(!admin_found)
			to_chat(src, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so please be patient!</span>")
		return

	ticket.msgs += new /datum/ticket_msg(src.ckey, null, original_msg)
	update_ticket_panels()


	//Options bar:  mob, details ( admin = 2, dev = 3, mentor = 4, character name (0 = just ckey, 1 = ckey and character name), link? (0 no don't make it a link, 1 do so),
	//		highlight special roles (0 = everyone has same looking name, 1 = antags / special roles get a golden name)

	var/mentor_msg = "<span class='notice'><b><font color=red>[selected_type]: </font>[get_options_bar(mob, 4, 1, 1, 0, ticket)] (<a href='?_src_=holder;take_ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>) (<a href='?_src_=holder;autoresponse=\ref[mob]'>AutoResponse...</a>):</b> [msg]</span>"
	msg = "<span class='notice'><b><font color=red>[selected_type]: </font>[get_options_bar(mob, 2, 1, 1, 1, ticket)] (<a href='?_src_=holder;take_ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>) (<a href='?_src_=holder;autoresponse=\ref[mob]'>AutoResponse...</a>):</b> [msg]</span>"

	var/admin_number_afk = 0

	var/list/mentorholders = list()
	var/list/debugholders = list()
	var/list/modholders = list()
	var/list/adminholders = list()
	for(var/client/X in GLOB.admins)
		if(R_MENTOR & X.holder.rights && !(R_MENTOR & X.holder.rights)) // we don't want to count admins twice. This list should be JUST mentors
			mentorholders += X
			if(X.is_afk())
				admin_number_afk++
		if(R_DEBUG & X.holder.rights || R_DEBUG & X.holder.rights) // Looking for anyone with +Debug which will be admins, developers, and developer mentors
			debugholders += X
			if(!(R_ADMIN & X.holder.rights))
				if(X.is_afk())
					admin_number_afk++

		if(R_MOD & X.holder.rights || R_MOD & X.holder.rights) // Looking for anyone with +Ban which will be full mods and admins.
			if(!(R_ADMIN & X.holder.rights))
				modholders += X
				if(X.is_afk())
					admin_number_afk++
		if(R_ADMIN & X.holder.rights || R_ADMIN & X.holder.rights) // just admins here please
			adminholders += X
			if(X.is_afk())
				admin_number_afk++


	switch(selected_type)
		if("Gameplay and Rules")
			if(adminholders.len)
				for(var/client/X in adminholders) // Mentors get a message without buttons and no character name
					if(X.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping))
						X << 'sound/effects/adminhelp_new.ogg'
					X << msg
			if(modholders.len)
				for(var/client/X in modholders) // Mentors get a message without buttons and no character name
					if(X.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping))
						X << 'sound/effects/adminhelp_new.ogg'
					X << mentor_msg
		if("Development and Bugs")
			if(debugholders.len)
				for(var/client/X in debugholders) // Devs
					if(X.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping))
						X << 'sound/effects/adminhelp_new.ogg'
					X << mentor_msg
		if("Other")
			if(adminholders.len)
				for(var/client/X in adminholders) // Mentors get a message without buttons and no character name
					if(X.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping))
						X << 'sound/effects/adminhelp_new.ogg'
					X << msg
			if(modholders.len)
				for(var/client/X in modholders) // This adminhelp category won't automatically display the person's stuff, to avoid accidental peeks.
					if(X.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping))
						X << 'sound/effects/adminhelp_new.ogg'
					X << mentor_msg




/*	for(var/client/X in GLOB.admins)
		if((R_ADMIN|R_MOD|R_MENTOR) & X.holder.rights)
			if(X.is_afk())
				admin_number_afk++
			if(X.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR)
				sound_to(X, 'sound/effects/adminhelp.ogg')
			if(X.holder.rights == R_MENTOR)
				to_chat(X, mentor_msg)// Mentors won't see coloring of names on people with special_roles (Antags, etc.)
			else
				to_chat(X, msg)*/
	//show it to the person adminhelping too
	to_chat(src, "<font color='blue'>PM to-<b>Staff</b> (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>): [original_msg]</font>")
	var/admin_number_present = GLOB.admins.len - admin_number_afk
	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admin_number_present] non-AFK admins.")
	if(admin_number_present <= 0)
		adminmsg2adminirc(src, null, "[html_decode(original_msg)] - !![admin_number_afk ? "All admins AFK ([admin_number_afk])" : "No admins online"]!!")
	else
		adminmsg2adminirc(src, null, "[html_decode(original_msg)]")

	SSstatistics.add_field_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

client/verb/bugreport()
	set category = "Admin"
	set name ="Submit Bug Report/Suggestions"
	var url = "https://discord.gg/jXWSaV8"
	if(url)
		if(alert("This will open the Sandros Discord Invite in your Browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(url)

client/verb/reportplayer()
	set category = "Admin"
	set name ="Report Player / Staff"
	var url = "https://discord.gg/jXWSaV8"
	if(url)
		if(alert("This will open the Sandros Discord Invite in your Browser. Are you sure?",,"Yes","No")=="No")
			return
		src << link(url)


/*
//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

/proc/generate_ahelp_key_words(var/mob/mob, var/msg)
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()

	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	for(var/mob/M in SSmobs.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
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
				if(word == "ai" && !ai_found)
					ai_found = 1
					msg += "<b>[original_word] <A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A></b> "
					continue
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							msg += "<b>[original_word] <A HREF='?_src_=holder;adminmoreinfo=\ref[found]'>(?)</A>"
							if(!ai_found && isAI(found))
								ai_found = 1
								msg += " <A HREF='?_src_=holder;adminchecklaws=\ref[mob]'>(CL)</A>"
							msg += "</b> "
							continue
		msg += "[original_word] "

	return msg

/client/verb/adminhelp(msg as text)
	set category = "Admin"
	set name = "Adminhelp"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>")
		return

	adminhelped = 1 //Determines if they get the message to reply by clicking the name.


	//clean the input msg
	if(!msg)
		return
	msg = sanitize(msg)
	if(!msg)
		return
	var/original_msg = msg


	if(!mob) //this doesn't happen
		return

	//generate keywords lookup
	msg = generate_ahelp_key_words(mob, msg)

	// handle ticket
	var/datum/client_lite/client_lite = client_repository.get_lite_client(src)
	var/datum/ticket/ticket = get_open_ticket_by_client(client_lite)
	if(!ticket)
		ticket = new /datum/ticket(client_lite)
	else if(ticket.status == TICKET_ASSIGNED)
		// manually check that the target client exists here as to not spam the usr for each logged out admin on the ticket
		var/admin_found = 0
		for(var/datum/client_lite/admin in ticket.assigned_admins)
			var/client/admin_client = client_by_ckey(admin.ckey)
			if(admin_client)
				admin_found = 1
				src.cmd_admin_pm(admin_client, original_msg, ticket)
				break
		if(!admin_found)
			to_chat(src, "<span class='warning'>Error: Private-Message: Client not found. They may have lost connection, so please be patient!</span>")
		return

	ticket.msgs += new /datum/ticket_msg(src.ckey, null, original_msg)
	update_ticket_panels()


	//Options bar:  mob, details ( admin = 2, dev = 3, mentor = 4, character name (0 = just ckey, 1 = ckey and character name), link? (0 no don't make it a link, 1 do so),
	//		highlight special roles (0 = everyone has same looking name, 1 = antags / special roles get a golden name)

	var/mentor_msg = "<span class='notice'><b><font color=red>HELP: </font>[get_options_bar(mob, 4, 1, 1, 0, ticket)] (<a href='?_src_=holder;take_ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>):</b> [msg]</span>"
	msg = "<span class='notice'><b><font color=red>HELP: </font>[get_options_bar(mob, 2, 1, 1, 1, ticket)] (<a href='?_src_=holder;take_ticket=\ref[ticket]'>[(ticket.status == TICKET_OPEN) ? "TAKE" : "JOIN"]</a>) (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>):</b> [msg]</span>"

	var/admin_number_afk = 0

	for(var/client/X in GLOB.admins)
		if((R_ADMIN|R_MOD|R_MENTOR) & X.holder.rights)
			if(X.is_afk())
				admin_number_afk++
			if(X.get_preference_value(/datum/client_preference/staff/play_adminhelp_ping) == GLOB.PREF_HEAR)
				sound_to(X, 'sound/effects/adminhelp.ogg')
			if(X.holder.rights == R_MENTOR)
				to_chat(X, mentor_msg)// Mentors won't see coloring of names on people with special_roles (Antags, etc.)
			else
				to_chat(X, msg)
	//show it to the person adminhelping too
	to_chat(src, "<font color='blue'>PM to-<b>Staff</b> (<a href='?src=\ref[usr];close_ticket=\ref[ticket]'>CLOSE</a>): [original_msg]</font>")
	var/admin_number_present = GLOB.admins.len - admin_number_afk
	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admin_number_present] non-AFK admins.")
	if(admin_number_present <= 0)
		adminmsg2adminirc(src, null, "[html_decode(original_msg)] - !![admin_number_afk ? "All admins AFK ([admin_number_afk])" : "No admins online"]!!")
	else
		adminmsg2adminirc(src, null, "[html_decode(original_msg)]")

	SSstatistics.add_field_details("admin_verb","AH") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

*/