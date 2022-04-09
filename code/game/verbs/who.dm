
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	if(check_rights(R_INVESTIGATE, 0))
		for(var/client/C in GLOB.clients)
			var/entry = "\t[C.key]"
			if(!C.mob) //If mob is null, print error and skip rest of info for client.
				entry += " - <font color='red'><i>HAS NO MOB</i></font>"
				Lines += entry
				continue

			entry += " - Playing as [C.mob.real_name]"
			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='darkgray'><b>Unconscious</b></font>"
				if(DEAD)
					if(isghost(C.mob))
						var/mob/observer/ghost/O = C.mob
						if(O.started_as_observer)
							entry += " - <span class=\"who_observing\">Observing</span>"
						else
							entry += " - <span class=\"who_dead\"><b>DEAD</b></span>"
					else
						entry += " - <span class=\"who_dead\"><b>DEAD</b></span>"

			var/age
			if(isnum(C.player_age))
				age = C.player_age
			else
				age = 0

			if(age <= 1)
				age = "<span class=\"who_new_account\"><b>[age]</b></span>"
			else if(age < 10)
				age = "<span class=\"who_newish_account\"><b>[age]</b></span>"

			entry += " - [age]"

			if(is_special_character(C.mob))
				entry += " - <b><span class=\"who_antagonist\">[C.mob.mind.special_role]</span></b>"
			if(C.is_afk())
				entry += " (AFK - [C.inactivity2text()])"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			if(!C.is_stealthed())
				Lines += C.key

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	msg += "<b>Total Players: [length(Lines)]</b>"
	to_chat(src, msg)

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/list/msg = list()
	var/active_staff = 0
	var/total_staff = 0
	var/can_investigate = check_rights(R_INVESTIGATE, 0)

	for(var/client/C as anything in GLOB.admins)
		var/line = list()
		if(!can_investigate && C.is_stealthed())
			continue
		total_staff++
		if(check_rights(R_ADMIN,0,C))
			line += "\t[C] is \an <b>["\improper[C.holder.rank]"]</b>"
		else
			line += "\t[C] is \an ["\improper[C.holder.rank]"]"
		if(!C.is_afk())
			active_staff++
		if(can_investigate)
			if(C.is_afk())
				line += " (AFK - [C.inactivity2text()])"
			if(isghost(C.mob))
				line += " - Observing"
			else if(istype(C.mob,/mob/new_player))
				line += " - Lobby"
			else
				line += " - Playing"
			if(C.is_stealthed())
				line += " (Stealthed)"
			if(C.get_preference_value(/datum/client_preference/show_ooc) == GLOB.PREF_HIDE)
				line += " <font color='#002eb8'><b><s>(OOC)</s></b></font>"
			if(C.get_preference_value(/datum/client_preference/show_looc) == GLOB.PREF_HIDE)
				line += " <font color='#3a7496'><b><s>(LOOC)</s></b></font>"
			if(C.get_preference_value(/datum/client_preference/show_aooc) == GLOB.PREF_HIDE)
				line += " <font color='#960018'><b><s>(AOOC)</s></b></font>"
			if(C.get_preference_value(/datum/client_preference/show_dsay) == GLOB.PREF_HIDE)
				line += " <font color='#530fad'><b><s>(DSAY)</s></b></font>"
		line = jointext(line,null)
		if(check_rights(R_ADMIN,0,C))
			msg.Insert(1, line)
		else
			msg += line

	if(config.admin_irc)
		to_chat(src, "<span class='info'>Adminhelps are also sent to IRC. If no admins are available in game try anyway and an admin on IRC may see it and respond.</span>")
	to_chat(src, "<b>Current Staff ([active_staff]/[total_staff]):</b>")
	to_chat(src, jointext(msg,"\n"))
