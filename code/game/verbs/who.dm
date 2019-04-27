
/client/verb/who()
	set name = "Who"
	set category = "OOC"

	var/msg = "<b>Current Players:</b>\n"

	var/list/Lines = list()

	var/living = 0
	var/dead = 0
	var/observers = 0
	var/lobby = 0
	var/living_antags = 0
	var/dead_antags = 0

	if(check_rights(R_INVESTIGATE, 0))
		log_admin("[key_name(usr)] checked advanced who in-round.")
		for(var/client/C in GLOB.clients)
			var/entry = "\t[C.key]"
			if(!C.mob) //If mob is null, print error and skip rest of info for client.
				entry += " - <font color='red'><i>HAS NO MOB</i></font>"
				Lines += entry
				continue

			if(!isnewplayer(C.mob) && !isghost(C.mob))
				entry += " - <font color='green'><b>Playing</b></font> as [C.mob.real_name]"

			switch(C.mob.stat)
				if(UNCONSCIOUS)
					entry += " - <font color='#404040'><b>Unconscious</b></font>"
					living++
				if(DEAD)
					if(isghost(C.mob))
						var/mob/observer/ghost/O = C.mob
						if(O.started_as_observer)
							entry += " - <font color='gray'><b>Observing</b></font>"
							observers++
						else
							entry += " - <b>DEAD</b>"
							dead++
					else if(isnewplayer(C.mob))
						entry += " - <font color='#006400'><b>In lobby</b></font>"
						lobby++
					else
						entry += " - <b>DEAD</b>"
						dead++
				else
					living++

			if(isnum(C.player_age))
				var/age = C.player_age

				if(age <= 1)
					age = "<font color='#ff0000'><b>[age]</b></font>"
				else if(age < 10)
					age = "<font color='#ff8c00'><b>[age]</b></font>"

				entry += " - [age]"

			if(is_special_character(C.mob))
				entry += " - <b><font color='red'>Antagonist</font></b>"
				if(C.mob.mind.current.stat == DEAD)
					dead_antags++
				else
					living_antags++

			if(C.is_afk())
				entry += " - <b>AFK: [C.inactivity2text()]</b>"
			entry += " (<A HREF='?_src_=holder;adminmoreinfo=\ref[C.mob]'>?</A>)"
			Lines += entry
	else
		for(var/client/C in GLOB.clients)
			if(!C.is_stealthed())
				var/entry = "[C.key]"
				switch(C.mob.stat)
					if(DEAD)
						if(isghost(C.mob))
							var/mob/observer/ghost/O = C.mob
							if(O.started_as_observer)
								entry += " - <font color='gray'><b>Observing</b></font>"
							else
								entry += " - <font color='green'><b>Playing</b></font>"
						else if(isnewplayer(C.mob))
							entry += " - <font color='#006400'><b>In Lobby</b></font>"
					else
						entry += " - <font color='green'><b>Playing</b></font>"

				if(C.is_afk())
					entry += " - <b>AFK: [C.inactivity2text()]</b>"

				Lines += entry

	for(var/line in sortList(Lines))
		msg += "[line]\n"

	if(check_rights(R_INVESTIGATE, 0))
		msg += "<b><font color='green'>Total Living: [living]</font> | Total Dead: [dead] | <font color='gray'>Observing: [observers]</font> | <font color='#006400'>In Lobby: [lobby]</font> | <font color='#8100aa'>Living Antags: [living_antags]</font> | <font color='#9b0000'>Dead Antags: [dead_antags]</font></b>\n"
		msg += "<b>Total Players: [length(Lines)]</b>"
		to_chat(src, msg)
	else
		msg += "<b>Total Players: [length(Lines)]</b>"
		to_chat(src, msg)

/client/verb/staffwho()
	set category = "Admin"
	set name = "Staffwho"

	var/list/msg = list()
	var/active_staff = 0
	var/total_staff = 0
	var/can_investigate = check_rights(R_INVESTIGATE, 0)

	for(var/client/C in GLOB.admins)
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
				line += " <font color='#3a9696'><b><s>(LOOC)</s></b></font>"
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
