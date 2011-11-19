
////////////////////////////////
/proc/message_admins(var/text, var/admin_ref = 0)
	var/rendered = "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message\">[text]</span></span>"
	for (var/mob/M in world)
		if (M && M.client && M.client.holder && M.client.authenticated)
			if (admin_ref)
				M << dd_replaceText(rendered, "%admin_ref%", "\ref[M]")
			else
				M << rendered

/obj/admins/Topic(href, href_list)
	..()

	if (usr.client != src.owner)
		world << "\blue [usr.key] has attempted to override the admin panel!"
		log_admin("[key_name(usr)] tried to use the admin panel without authorization.")
		return

	if(href_list["call_shuttle"])
		if (src.rank in list("Trial Admin", "Badmin", "Game Admin", "Game Master"))
			if( ticker.mode.name == "blob" )
				alert("You can't call the shuttle during blob!")
				return
			switch(href_list["call_shuttle"])
				if("1")
					if ((!( ticker ) || emergency_shuttle.location))
						return
					emergency_shuttle.incall()
					world << "\blue <B>Alert: The emergency shuttle has been called. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.</B>"
					log_admin("[key_name(usr)] called the Emergency Shuttle")
					message_admins("\blue [key_name_admin(usr)] called the Emergency Shuttle to the station", 1)

				if("2")
					if ((!( ticker ) || emergency_shuttle.location || emergency_shuttle.direction == 0))
						return
					switch(emergency_shuttle.direction)
						if(-1)
							emergency_shuttle.incall()
							world << "\blue <B>Alert: The emergency shuttle has been called. It will arrive in [round(emergency_shuttle.timeleft()/60)] minutes.</B>"
							log_admin("[key_name(usr)] called the Emergency Shuttle")
							message_admins("\blue [key_name_admin(usr)] called the Emergency Shuttle to the station", 1)
						if(1)
							emergency_shuttle.recall()
							world << "\blue <B>Alert: The shuttle is going back!</B>"
							log_admin("[key_name(usr)] sent the Emergency Shuttle back")
							message_admins("\blue [key_name_admin(usr)] sent the Emergency Shuttle back", 1)

			href_list["secretsadmin"] = "check_antagonist"
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!")
			return

	if(href_list["edit_shuttle_time"])
		if (src.rank in list("Badmin", "Game Admin", "Game Master"))
			emergency_shuttle.settimeleft( input("Enter new shuttle duration (seconds):","Edit Shuttle Timeleft", emergency_shuttle.timeleft() ) as num )
			log_admin("[key_name(usr)] edited the Emergency Shuttle's timeleft to [emergency_shuttle.timeleft()]")
			message_admins("\blue [key_name_admin(usr)] edited the Emergency Shuttle's timeleft to [emergency_shuttle.timeleft()]", 1)
			href_list["secretsadmin"] = "check_antagonist"
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!")
			return

	/////////////////////////////////////new ban stuff
	if(href_list["unbanf"])
		var/banfolder = href_list["unbanf"]
		Banlist.cd = "/base/[banfolder]"
		var/key = Banlist["key"]
		if(alert(usr, "Are you sure you want to unban [key]?", "Confirmation", "Yes", "No") == "Yes")
			if (RemoveBan(banfolder))
				unbanpanel()
			else
				alert(usr,"This ban has already been lifted / does not exist.","Error","Ok")
				unbanpanel()

	if(href_list["unbane"])
		UpdateTime()
		var/reason
		var/mins = 0
		var/banfolder = href_list["unbane"]
		Banlist.cd = "/base/[banfolder]"
		var/reason2 = Banlist["reason"]
		var/temp = Banlist["temp"]
		var/minutes = (Banlist["minutes"] - CMinutes)
		if(!minutes || minutes < 0) minutes = 0
		var/banned_key = Banlist["key"]
		Banlist.cd = "/base"

		switch(alert("Temporary Ban?",,"Yes","No"))
			if("Yes")
				temp = 1
				mins = input(usr,"How long (in minutes)? (Default: 1440)","Ban time",minutes ? minutes : 1440) as num
				if(!mins)
					return
				if(mins >= 525600) mins = 525599
				reason = input(usr,"Reason?","reason",reason2) as text
				if(!reason)
					return
			if("No")
				temp = 0
				reason = input(usr,"Reason?","reason",reason2) as text
				if(!reason)
					return

		log_admin("[key_name(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [GetExp(mins)]")

		ban_unban_log_save("[key_name(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [GetExp(mins)]")
		message_admins("\blue [key_name_admin(usr)] edited [banned_key]'s ban. Reason: [reason] Duration: [GetExp(mins)]", 1)
		Banlist.cd = "/base/[banfolder]"
		Banlist["reason"] << reason
		Banlist["temp"] << temp
		Banlist["minutes"] << (mins + CMinutes)
		Banlist["bannedby"] << usr.ckey
		Banlist.cd = "/base"
		feedback_inc("ban_edit",1)
		unbanpanel()

	/////////////////////////////////////new ban stuff

	if(href_list["jobban2"])
		var/mob/M = locate(href_list["jobban2"])
		var/dat = ""
		var/header = "<b>Pick Job to ban this guy from.<br>"
		var/body
		var/jobs = ""
		if(!job_master)
			usr << "Job Master has not been setup!"
			return
		for(var/datum/job/job in job_master.occupations)
			if(job.title == "Tourist")
				continue
			if(jobban_isbanned(M, job.title))
				jobs += "<a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[dd_replacetext(job.title, " ", "&nbsp")]</font></a> "
			else
				jobs += "<a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[dd_replacetext(job.title, " ", "&nbsp")]</a> "

/*		if(jobban_isbanned(M, "Captain")) These two are now jobs in the datums and should show up in the above code
			jobs += "<a href='?src=\ref[src];jobban3=Captain;jobban4=\ref[M]'><font color=red>Captain</font></a> "
		else
			jobs += "<a href='?src=\ref[src];jobban3=Captain;jobban4=\ref[M]'>Captain</a> "

		if(jobban_isbanned(M, "AI"))
			jobs += "<a href='?src=\ref[src];jobban3=AI;jobban4=\ref[M]'><font color=red>AI</font></a> "
		else
			jobs += "<a href='?src=\ref[src];jobban3=AI;jobban4=\ref[M]'>AI</a> "
*/
		if(jobban_isbanned(M, "Syndicate"))
			jobs += "<BR><a href='?src=\ref[src];jobban3=Syndicate;jobban4=\ref[M]'><font color=red>[dd_replacetext("Syndicate", " ", "&nbsp")]</font></a> "
		else
			jobs += "<BR><a href='?src=\ref[src];jobban3=Syndicate;jobban4=\ref[M]'>[dd_replacetext("Syndicate", " ", "&nbsp")]</a> "

		if(jobban_isbanned(M, "pAI"))
			jobs += "<BR><a href='?src=\ref[src];jobban3=pAI;jobban4=\ref[M]'><font color=red>pAI</font></a> "
		else
			jobs += "<BR><a href='?src=\ref[src];jobban3=pAI;jobban4=\ref[M]'>pAI</a> "

		body = "<br>[jobs]<br><br>"
		dat = "<tt>[header][body]</tt>"
		usr << browse(dat, "window=jobban2;size=600x180")
		return

	if(href_list["jobban3"])
		if (src.rank in list( "Admin Candidate", "Temporary Admin", "Trial Admin", "Badmin", "Game Admin", "Game Master"  ))
			var/mob/M = locate(href_list["jobban4"])
			var/job = href_list["jobban3"]
			if ((M.client && M.client.holder && (M.client.holder.level > src.level)))
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return
			if (jobban_isbanned(M, job))
				log_admin("[key_name(usr)] unbanned [key_name(M)] from [job]")
				ban_unban_log_save("[key_name(usr)] unjobbanned [key_name(M)] from [job]")
				M << "\red<BIG><B>You have been un-jobbanned by [usr.client.ckey] from [job].</B></BIG>"
				feedback_inc("ban_job_unban",1)
				message_admins("\blue [key_name_admin(usr)] unbanned [key_name_admin(M)] from [job]", 1)
				jobban_unban(M, job)
				href_list["jobban2"] = 1
			else
				ban_unban_log_save("[key_name(usr)] jobbanned [key_name(M)] from [job]")
				log_admin("[key_name(usr)] banned [key_name(M)] from [job]")
				feedback_inc("ban_job",1)
				M << "\red<BIG><B>You have been jobbanned by [usr.client.ckey] from [job].</B></BIG>"
				M << "\red Jooban can be lifted only on demand."
				message_admins("\blue [key_name_admin(usr)] banned [key_name_admin(M)] from [job]", 1)
				jobban_fullban(M, job)
				href_list["jobban2"] = 1 // lets it fall through and refresh


	if (href_list["boot2"])
		if ((src.rank in list( "Moderator", "Temporary Admin", "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["boot2"])
			if (ismob(M))
				if ((M.client && M.client.holder && (M.client.holder.level >= src.level)))
					alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
					return
				M << "\red You have been kicked from the server"
				log_admin("[key_name(usr)] booted [key_name(M)].")
				message_admins("\blue [key_name_admin(usr)] booted [key_name_admin(M)].", 1)
				//M.client = null
				del(M.client)

	if (href_list["removejobban"])
		if ((src.rank in list("Game Admin", "Game Master"  )))
			var/t = href_list["removejobban"]
			if(t)
				log_admin("[key_name(usr)] removed [t]")
				message_admins("\blue [key_name_admin(usr)] removed [t]", 1)
				jobban_remove(t)
				href_list["ban"] = 1 // lets it fall through and refresh

	if (href_list["newban"])
		if ((src.rank in list( "Temporary Admin", "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["newban"])
			if(!ismob(M)) return
			if ((M.client && M.client.holder && (M.client.holder.level >= src.level)))
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return
			switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
				if("Yes")
					var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num|null
					if(!mins)
						return
					if(mins >= 525600) mins = 525599
					var/reason = input(usr,"Reason?","reason","Griefer") as text|null
					if(!reason)
						return
					AddBan(M.ckey, M.computer_id, reason, usr.ckey, 1, mins)
					ban_unban_log_save("[usr.client.ckey] has banned [M.ckey]. - Reason: [reason] - This will be removed in [mins] minutes.")
					M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
					M << "\red This is a temporary ban, it will be removed in [mins] minutes."
					feedback_inc("ban_tmp",1)
					if(config.banappeals)
						M << "\red To try to resolve this matter head to [config.banappeals]"
					else
						M << "\red No ban appeals URL has been set."
					log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
					message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")

					del(M.client)
					//del(M)	// See no reason why to delete mob. Important stuff can be lost. And ban can be lifted before round ends.
				if("No")
					var/reason = input(usr,"Reason?","reason","Griefer") as text|null
					if(!reason)
						return
					AddBan(M.ckey, M.computer_id, reason, usr.ckey, 0, 0)
					M << "\red<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"
					M << "\red This is a permanent ban."
					if(config.banappeals)
						M << "\red To try to resolve this matter head to [config.banappeals]"
					else
						M << "\red No ban appeals URL has been set."
					ban_unban_log_save("[usr.client.ckey] has permabanned [M.ckey]. - Reason: [reason] - This is a permanent ban.")
					log_admin("[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
					message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis is a permanent ban.")
					feedback_inc("ban_perma",1)

					del(M.client)
					//del(M)
				if("Cancel")
					return
	if (href_list["newjobban1"])
		var/mob/M = locate(href_list["newjobban1"])
		var/dat = ""
		var/header = "<b>Pick Job to ban this guy from.<br>"
		var/body
//		var/list/alljobs = get_all_jobs()
		var/jobs = ""
		jobs += "<a href='?src=\ref[src];newjobban2=Heads;jobban4=\ref[M]'>Heads</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=Security;jobban4=\ref[M]'>Security</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=Engineering;jobban4=\ref[M]'>Engineering</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=Research;jobban4=\ref[M]'>Research</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=Medical;jobban4=\ref[M]'>Medical</a> <br><br>"

		jobs += "<a href='?src=\ref[src];newjobban2=CE_Station_Engineer;jobban4=\ref[M]'>CE+Station Engineer</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=CE_Atmospheric_Tech;jobban4=\ref[M]'>CE+Atmospheric Tech</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=CE_Shaft_Miner;jobban4=\ref[M]'>CE+Shaft Miner</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=Chemist_RD_CMO;jobban4=\ref[M]'>Chemist+RD+CMO</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=Geneticist_RD_CMO;jobban4=\ref[M]'>Geneticist+RD+CMO</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=MD_CMO;jobban4=\ref[M]'>MD+CMO</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=Virologist_RD_CMO;jobban4=\ref[M]'>Virologist+RD+CMO</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=Scientist_RD;jobban4=\ref[M]'>Scientist+RD</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=AI_Cyborg;jobban4=\ref[M]'>AI+Cyborg</a> <br>"
		jobs += "<a href='?src=\ref[src];newjobban2=Detective_HoS;jobban4=\ref[M]'>Detective+HoS</a> <br><br>"
		for(var/datum/job/job in job_master.occupations)
			if(job.title == "Tourist")
				continue
			if(jobban_isbanned(M, job.title))
				jobs += "<a href='?src=\ref[src];newjobban2=[job.title];jobban4=\ref[M]'><font color=red>[dd_replacetext(job.title, " ", "&nbsp")]</font></a> "
			else
				jobs += "<a href='?src=\ref[src];newjobban2=[job.title];jobban4=\ref[M]'>[dd_replacetext(job.title, " ", "&nbsp")]</a> " //why doesn't this work the stupid cunt

/*		if(jobban_isbanned(M, "Captain"))
			jobs += "<a href='?src=\ref[src];newjobban2=Captain;jobban4=\ref[M]'><font color=red>Captain</font></a> "
		else
			jobs += "<a href='?src=\ref[src];newjobban2=Captain;jobban4=\ref[M]'>Captain</a> " //why doesn't this work the stupid cunt
*/
		if(jobban_isbanned(M, "Syndicate"))
			jobs += "<BR><a href='?src=\ref[src];newjobban2=Syndicate;jobban4=\ref[M]'><font color=red>[dd_replacetext("Syndicate", " ", "&nbsp")]</font></a> "
		else
			jobs += "<BR><a href='?src=\ref[src];newjobban2=Syndicate;jobban4=\ref[M]'>[dd_replacetext("Syndicate", " ", "&nbsp")]</a> " //why doesn't this work the stupid cunt

		body = "<br>[jobs]<br><br>"
		dat = "<tt>[header][body]</tt>"
		usr << browse(dat, "window=jobban2;size=600x250")
		return
	if(href_list["newjobban2"])
		if ((src.rank in list("Moderator", "Administrator", "Badmin", "Tyrant"  )))
			var/mob/M = locate(href_list["jobban4"])
			var/job = href_list["newjobban2"]
			if(!ismob(M)) return
			//if ((M.client && M.client.holder && (M.client.holder.level >= src.level)))
			//	alert("You cannot perform this action. You must be of a higher administrative rank!")
			//	return
			switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
				if("Yes")
					var/mins = input(usr,"How long (in days)?","Ban time",7) as num
					mins = mins * 24 * 60
					if(!mins)
						return
					if(mins >= 525600) mins = 525599
					var/reason = input(usr,"Reason?","reason","Griefer") as text
					if(!reason)
						return
					if(AddBanjob(M.ckey, M.computer_id, reason, usr.ckey, 1, mins, job))
						M << "\red<BIG><B>You have been jobbanned from [job] by [usr.client.ckey].\nReason: [reason].</B></BIG>"
						M << "\red This is a temporary ban, it will be removed in [mins] minutes."
						if(config.banappeals)
							M << "\red To try to resolve this matter head to [config.banappeals]"
						else
							M << "\red No ban appeals URL has been set."
						ban_unban_log_save("[usr.client.ckey] has jobbanned [M.ckey] from [job]. - Reason: [reason] - This will be removed in [mins] minutes.")
						feedback_inc("ban_job",1)
						log_admin("[usr.client.ckey] has banned [M.ckey] from [job].\nReason: [reason]\nThis will be removed in [mins] minutes.")
						message_admins("\blue[usr.client.ckey] has banned [M.ckey] from [job].\nReason: [reason]\nThis will be removed in [mins] minutes.")

					//del(M.client)
					//del(M)	// See no reason why to delete mob. Important stuff can be lost. And ban can be lifted before round ends.
				if("No")
					var/reason = input(usr,"Reason?","reason","Griefer") as text
					if(!reason)
						return
					if(AddBanjob(M.ckey, M.computer_id, reason, usr.ckey, 0, 0, job))
						M << "\red<BIG><B>You have been banned from [job] by [usr.client.ckey].\nReason: [reason].</B></BIG>"
						M << "\red This is a permanent ban."
						if(config.banappeals)
							M << "\red To try to resolve this matter head to [config.banappeals]"
						else
							M << "\red No ban appeals URL has been set."
						ban_unban_log_save("[usr.client.ckey] has banned [M.ckey] from [job]. - Reason: [reason] - This is a permanent ban.")
						feedback_inc("ban_job_tmp",1)
						log_admin("[usr.client.ckey] has banned [M.ckey] from [job].\nReason: [reason]\nThis is a permanent ban.")
						message_admins("\blue[usr.client.ckey] has banned [M.ckey] from [job].\nReason: [reason]\nThis is a permanent ban.")

					//del(M.client)
					//del(M)
				if("Cancel")
					return

	if(href_list["unjobbanf"])
		var/banfolder = href_list["unjobbanf"]
		Banlist.cd = "/base/[banfolder]"
		var/key = Banlist["key"]
		if(alert(usr, "Are you sure you want to unban [key]?", "Confirmation", "Yes", "No") == "Yes")
			if (RemoveBanjob(banfolder))
				unjobbanpanel()
			else
				alert(usr,"This ban has already been lifted / does not exist.","Error","Ok")
				unjobbanpanel()

	if(href_list["unjobbane"])
		return
/*
	if (href_list["remove"])
		if ((src.rank in list( "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/t = href_list["remove"]
			if(t && isgoon(t))
				log_admin("[key_name(usr)] removed [t] from the goonlist.")
				message_admins("\blue [key_name_admin(usr)] removed [t] from the goonlist.")
				remove_goon(t)
*/
	if (href_list["mute2"])
		if ((src.rank in list( "Moderator", "Temporary Admin", "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["mute2"])
			if (ismob(M))
				if ((M.client && M.client.holder && (M.client.holder.level >= src.level)))
					alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
					return
				if(!M.client)
					src << "This mob doesn't have a client tied to it."
					return
				M.client.muted = !M.client.muted
				log_admin("[key_name(usr)] has [(M.client.muted ? "muted" : "voiced")] [key_name(M)].")
				message_admins("\blue [key_name_admin(usr)] has [(M.client.muted ? "muted" : "voiced")] [key_name_admin(M)].", 1)
				M << "You have been [(M.client.muted ? "muted" : "voiced")]. Please resolve this in adminhelp."
	if (href_list["mute_complete"])
		if ((src.rank in list( "Moderator", "Temporary Admin", "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["mute_complete"])
			if (ismob(M))
				if ((M.client && M.client.holder && (M.client.holder.level >= src.level)))
					alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
					return
				if(!M.client)
					src << "This mob doesn't have a client tied to it."
					return
				M.client.muted_complete = !M.client.muted_complete
				log_admin("[key_name(usr)] has [(M.client.muted_complete ? "completely muted" : "voiced (complete)")] [key_name(M)].")
				message_admins("\blue [key_name_admin(usr)] has [(M.client.muted_complete ? "completely muted" : "voiced (complete)")] [key_name_admin(M)].", 1)
				M << "You have been [(M.client.muted_complete ? "completely muted" : "voiced (complete)")]. You are unable to speak or even adminhelp"

	if (href_list["c_mode"])
		if ((src.rank in list( "Temporary Admin", "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			if (ticker && ticker.mode)
				return alert(usr, "The game has already started.", null, null, null, null)
			var/dat = {"<B>What mode do you wish to play?</B><HR>"}
			for (var/mode in config.modes)
				dat += {"<A href='?src=\ref[src];c_mode2=[mode]'>[config.mode_names[mode]]</A><br>"}
			dat += {"<A href='?src=\ref[src];c_mode2=secret'>Secret</A><br>"}
			dat += {"<A href='?src=\ref[src];c_mode2=random'>Random</A><br>"}
			dat += {"Now: [master_mode]"}
			usr << browse(dat, "window=c_mode")

	if (href_list["f_secret"])
		if ((src.rank in list( "Temporary Admin", "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			if (ticker && ticker.mode)
				return alert(usr, "The game has already started.", null, null, null, null)
			if (master_mode != "secret")
				return alert(usr, "The game mode has to be secret!", null, null, null, null)
			var/dat = {"<B>What game mode do you want to force secret to be? Use this if you want to change the game mode, but want the players to believe it's secret. This will only work if the current game mode is secret.</B><HR>"}
			for (var/mode in config.modes)
				dat += {"<A href='?src=\ref[src];f_secret2=[mode]'>[config.mode_names[mode]]</A><br>"}
			dat += {"<A href='?src=\ref[src];f_secret2=secret'>Random (default)</A><br>"}
			dat += {"Now: [secret_force_mode]"}
			usr << browse(dat, "window=f_secret")

	if (href_list["c_mode2"])
		if ((src.rank in list( "Temporary Admin", "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			if (ticker && ticker.mode)
				return alert(usr, "The game has already started.", null, null, null, null)
			master_mode = href_list["c_mode2"]
			log_admin("[key_name(usr)] set the mode as [master_mode].")
			message_admins("\blue [key_name_admin(usr)] set the mode as [master_mode].", 1)
			world << "\blue <b>The mode is now: [master_mode]</b>"
			Game() // updates the main game menu
			world.save_mode(master_mode)
			.(href, list("c_mode"=1))

	if (href_list["f_secret2"])
		if ((src.rank in list( "Temporary Admin", "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			if (ticker && ticker.mode)
				return alert(usr, "The game has already started.", null, null, null, null)
			if (master_mode != "secret")
				return alert(usr, "The game mode has to be secret!", null, null, null, null)
			secret_force_mode = href_list["f_secret2"]
			log_admin("[key_name(usr)] set the forced secret mode as [secret_force_mode].")
			message_admins("\blue [key_name_admin(usr)] set the forced secret mode as [secret_force_mode].", 1)
			Game() // updates the main game menu
			.(href, list("f_secret"=1))

	if (href_list["monkeyone"])
		if ((src.rank in list( "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["monkeyone"])
			if(!ismob(M))
				return
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/N = M
				log_admin("[key_name(usr)] attempting to monkeyize [key_name(M)]")
				message_admins("\blue [key_name_admin(usr)] attempting to monkeyize [key_name_admin(M)]", 1)
				N.monkeyize()
			if(istype(M, /mob/living/silicon))
				alert("The AI can't be monkeyized!", null, null, null, null, null)
				return

	if (href_list["forcespeech"])
		if ((src.rank in list( "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["forcespeech"])
			if (ismob(M))
				var/speech = input("What will [key_name(M)] say?.", "Force speech", "")
				if(!speech)
					return
				M.say(speech)
				speech = copytext(sanitize(speech), 1, MAX_MESSAGE_LEN)
				log_admin("[key_name(usr)] forced [key_name(M)] to say: [speech]")
				message_admins("\blue [key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]")
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

	if (href_list["sendtoprison"])
		if ((src.rank in list( "Moderator", "Admin Candidate", "Temporary Admin", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["sendtoprison"])
			if (ismob(M))
				if(istype(M, /mob/living/silicon/ai))
					alert("The AI can't be sent to prison you jerk!", null, null, null, null, null)
					return
				//strip their stuff before they teleport into a cell :downs:
				for(var/obj/item/weapon/W in M)
					if(istype(W, /datum/organ/external))
						continue
	//don't strip organs
					M.u_equip(W)
					if (M.client)
						M.client.screen -= W
					if (W)
						W.loc = M.loc
						W.dropped(M)
						W.layer = initial(W.layer)
				//teleport person to cell
				M.paralysis += 5
				sleep(5) //so they black out before warping
				M.loc = pick(prisonwarp)
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/prisoner = M
					prisoner.equip_if_possible(new /obj/item/clothing/under/color/orange(prisoner), prisoner.slot_w_uniform)
					prisoner.equip_if_possible(new /obj/item/clothing/shoes/orange(prisoner), prisoner.slot_shoes)
				spawn(50)
					M << "\red You have been sent to the prison station!"
				log_admin("[key_name(usr)] sent [key_name(M)] to the prison station.")
				message_admins("\blue [key_name_admin(usr)] sent [key_name_admin(M)] to the prison station.", 1)
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

/*
	if (href_list["sendtomaze"])
		if ((src.rank in list( "Admin Candidate", "Temporary Admin", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["sendtomaze"])
			if (ismob(M))
				if(istype(M, /mob/living/silicon/ai))
					alert("The AI can't be sent to the maze you jerk!", null, null, null, null, null)
					return
				//strip their stuff before they teleport into a cell :downs:
				for(var/obj/item/weapon/W in M)
					if(istype(W, /datum/organ/external))
						continue
	//don't strip organs
					M.u_equip(W)
					if (M.client)
						M.client.screen -= W
					if (W)
						W.loc = M.loc
						W.dropped(M)
						W.layer = initial(W.layer)
				//teleport person to cell
				M.paralysis += 5
				sleep(5)
	//so they black out before warping
				M.loc = pick(mazewarp)
				spawn(50)
					M << "\red You have been sent to the maze! Try and get out alive. In the maze everyone is free game. Kill or be killed."
				log_admin("[key_name(usr)] sent [key_name(M)] to the maze.")
				message_admins("\blue [key_name_admin(usr)] sent [key_name_admin(M)] to the maze.", 1)
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return
*/

	if (href_list["tdome1"])
		if ((src.rank in list( "Admin Candidate", "Temporary Admin", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["tdome1"])
			if (ismob(M))
				if(istype(M, /mob/living/silicon/ai))
					alert("The AI can't be sent to the thunderdome you jerk!", null, null, null, null, null)
					return
				for(var/obj/item/W in M)
					if (istype(W,/obj/item))
						if(istype(W, /datum/organ/external))
							continue
						M.u_equip(W)
						if (M.client)
							M.client.screen -= W
						if (W)
							W.loc = M.loc
							W.dropped(M)
							W.layer = initial(W.layer)
				M.paralysis += 5
				sleep(5)
				M.loc = pick(tdome1)
				spawn(50)
					M << "\blue You have been sent to the Thunderdome."
				log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Team 1)")
				message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 1)", 1)

	if (href_list["tdome2"])
		if ((src.rank in list( "Admin Candidate", "Temporary Admin", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["tdome2"])
			if (ismob(M))
				if(istype(M, /mob/living/silicon/ai))
					alert("The AI can't be sent to the thunderdome you jerk!", null, null, null, null, null)
					return
				for(var/obj/item/W in M)
					if (istype(W,/obj/item))
						if(istype(W, /datum/organ/external))
							continue
						M.u_equip(W)
						if (M.client)
							M.client.screen -= W
						if (W)
							W.loc = M.loc
							W.dropped(M)
							W.layer = initial(W.layer)
				M.paralysis += 5
				sleep(5)
				M.loc = pick(tdome2)
				spawn(50)
					M << "\blue You have been sent to the Thunderdome."
				log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Team 2)")
				message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 2)", 1)

	if (href_list["tdomeadmin"])
		if ((src.rank in list( "Admin Candidate", "Temporary Admin", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["tdomeadmin"])
			if (ismob(M))
				if(istype(M, /mob/living/silicon/ai))
					alert("The AI can't be sent to the thunderdome you jerk!", null, null, null, null, null)
					return
				M.paralysis += 5
				sleep(5)
				M.loc = pick(tdomeadmin)
				spawn(50)
					M << "\blue You have been sent to the Thunderdome."
				log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Admin.)")
				message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Admin.)", 1)

	if (href_list["tdomeobserve"])
		if ((src.rank in list( "Admin Candidate", "Temporary Admin", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["tdomeobserve"])
			if (ismob(M))
				if(istype(M, /mob/living/silicon/ai))
					alert("The AI can't be sent to the thunderdome you jerk!", null, null, null, null, null)
					return
				for(var/obj/item/W in M)
					if (istype(W,/obj/item))
						if(istype(W, /datum/organ/external))
							continue
						M.u_equip(W)
						if (M.client)
							M.client.screen -= W
						if (W)
							W.loc = M.loc
							W.dropped(M)
							W.layer = initial(W.layer)
				if(istype(M, /mob/living/carbon/human))
					var/mob/living/carbon/human/observer = M
					observer.equip_if_possible(new /obj/item/clothing/under/suit_jacket(observer), observer.slot_w_uniform)
					observer.equip_if_possible(new /obj/item/clothing/shoes/black(observer), observer.slot_shoes)
				M.paralysis += 5
				sleep(5)
				M.loc = pick(tdomeobserve)
				spawn(50)
					M << "\blue You have been sent to the Thunderdome."
				log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Observer.)")
				message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Observer.)", 1)

	if (href_list["adminauth"])
		if ((src.rank in list( "Admin Candidate", "Temporary Admin", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/M = locate(href_list["adminauth"])
			if (ismob(M) && !M.client.authenticated && !M.client.authenticating)
				M.client.verbs -= /client/proc/authorize
				M.client.authenticated = text("admin/[]", usr.client.authenticated)
				log_admin("[key_name(usr)] authorized [key_name(M)]")
				message_admins("\blue [key_name_admin(usr)] authorized [key_name_admin(M)]", 1)
				M.client << text("You have been authorized by []", usr.key)

	if (href_list["revive"])
		if ((src.rank in list( "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/mob/living/M = locate(href_list["revive"])
			if (isliving(M))
				if(config.allow_admin_rev)
					M.revive()
					message_admins("\red Admin [key_name_admin(usr)] healed / revived [key_name_admin(M)]!", 1)
					log_admin("[key_name(usr)] healed / Rrvived [key_name(M)]")
					return
				else
					alert("Admin revive disabled")
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

	if (href_list["makeai"]) //Yes, im fucking lazy, so what? it works ... hopefully
		if (src.level>=3)
			var/mob/M = locate(href_list["makeai"])
			if(istype(M, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				message_admins("\red Admin [key_name_admin(usr)] AIized [key_name_admin(M)]!", 1)
//				if (ticker.mode.name  == "AI malfunction")
//					var/obj/O = locate("landmark*ai")
//					M << "\blue <B>You have been teleported to your new starting location!</B>"
//					M.loc = O.loc
//					M.buckled = null
//				else
//					var/obj/S = locate(text("start*AI"))
//					if ((istype(S, /obj/effect/landmark/start) && istype(S.loc, /turf)))
//						M << "\blue <B>You have been teleported to your new starting location!</B>"
//						M.loc = S.loc
//						M.buckled = null
				//	world << "<b>[M.real_name] is the AI!</b>"
				log_admin("[key_name(usr)] AIized [key_name(M)]")
				H.AIize()
			else
				alert("I cannot allow this.")
				return
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
			return

	if (href_list["makealien"])
		if (src.level>=3)
			var/mob/M = locate(href_list["makealien"])
			if(istype(M, /mob/living/carbon/human))
				usr.client.cmd_admin_alienize(M)
			else
				alert("Wrong mob. Must be human.")
				return
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!")
			return

	if (href_list["makemetroid"])
		if (src.level>=3)
			var/mob/M = locate(href_list["makemetroid"])
			if(istype(M, /mob/living/carbon/human))
				usr.client.cmd_admin_metroidize(M)
			else
				alert("Wrong mob. Must be human.")
				return
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!")
			return

	if (href_list["makerobot"])
		if (src.level>=3)
			var/mob/M = locate(href_list["makerobot"])
			if(istype(M, /mob/living/carbon/human))
				usr.client.cmd_admin_robotize(M)
			else
				alert("Wrong mob. Must be human.")
				return
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!")
			return
/***************** BEFORE**************

	if (href_list["l_players"])
		var/dat = "<B>Name/Real Name/Key/IP:</B><HR>"
		for(var/mob/M in world)
			var/foo = ""
			if (ismob(M) && M.client)
				if(!M.client.authenticated && !M.client.authenticating)
					foo += text("\[ <A HREF='?src=\ref[];adminauth=\ref[]'>Authorize</A> | ", src, M)
				else
					foo += text("\[ <B>Authorized</B> | ")
				if(M.start)
					if(!istype(M, /mob/living/carbon/monkey))
						foo += text("<A HREF='?src=\ref[];monkeyone=\ref[]'>Monkeyize</A> | ", src, M)
					else
						foo += text("<B>Monkeyized</B> | ")
					if(istype(M, /mob/living/silicon/ai))
						foo += text("<B>Is an AI</B> | ")
					else
						foo += text("<A HREF='?src=\ref[];makeai=\ref[]'>Make AI</A> | ", src, M)
					if(M.z != 2)
						foo += text("<A HREF='?src=\ref[];sendtoprison=\ref[]'>Prison</A> | ", src, M)
						foo += text("<A HREF='?src=\ref[];sendtomaze=\ref[]'>Maze</A> | ", src, M)
					else
						foo += text("<B>On Z = 2</B> | ")
				else
					foo += text("<B>Hasn't Entered Game</B> | ")
				foo += text("<A HREF='?src=\ref[];revive=\ref[]'>Heal/Revive</A> | ", src, M)

				foo += text("<A HREF='?src=\ref[];forcespeech=\ref[]'>Say</A> \]", src, M)
			dat += text("N: [] R: [] (K: []) (IP: []) []<BR>", M.name, M.real_name, (M.client ? M.client : "No client"), M.lastKnownIP, foo)

		usr << browse(dat, "window=players;size=900x480")

*****************AFTER******************/

// Now isn't that much better? IT IS NOW A PROC, i.e. kinda like a big panel like unstable

	if (href_list["adminplayeropts"])
		var/mob/M = locate(href_list["adminplayeropts"])
		show_player_panel(M)

	if (href_list["adminplayervars"])
		var/mob/M = locate(href_list["adminplayervars"])
		if(src && src.owner)
			if(istype(src.owner,/client))
				var/client/cl = src.owner
				cl.debug_variables(M)
			else if(ismob(src.owner))
				var/mob/MO = src.owner
				if(MO.client)
					var/client/cl = MO.client
					cl.debug_variables(M)

	if (href_list["adminplayersubtlemessage"])
		var/mob/M = locate(href_list["adminplayersubtlemessage"])
		if(src && src.owner)
			if(istype(src.owner,/client))
				var/client/cl = src.owner
				cl.cmd_admin_subtle_message(M)
			else if(ismob(src.owner))
				var/mob/MO = src.owner
				if(MO.client)
					var/client/cl = MO.client
					cl.cmd_admin_subtle_message(M)

	if (href_list["adminplayerobservejump"])
		var/mob/M = locate(href_list["adminplayerobservejump"])
		if(src && src.owner)
			if(istype(src.owner,/client))
				var/client/cl = src.owner
				cl.admin_observe()
				sleep(2)
				cl.jumptomob(M)
			else if(ismob(src.owner))
				var/mob/MO = src.owner
				if(MO.client)
					var/client/cl = MO.client
					cl.admin_observe()
					sleep(2)
					cl.jumptomob(M)


	if (href_list["jumpto"])
		if(rank in list("Badmin", "Game Admin", "Game Master"))
			var/mob/M = locate(href_list["jumpto"])
			usr.client.jumptomob(M)
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!")
			return

	if (href_list["getmob"])
		if(rank in list( "Trial Admin", "Badmin", "Game Admin", "Game Master"))
			var/mob/M = locate(href_list["getmob"])
			usr.client.Getmob(M)
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!")
			return

	if (href_list["sendmob"])
		if(rank in list( "Trial Admin", "Badmin", "Game Admin", "Game Master"))
			var/mob/M = locate(href_list["sendmob"])
			usr.client.sendmob(M)
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!")
			return

	if (href_list["narrateto"])
		if(rank in list("Game Admin", "Game Master"))
			var/mob/M = locate(href_list["narrateto"])
			usr.client.cmd_admin_direct_narrate(M)
		else
			alert("You cannot perform this action. You must be of a higher administrative rank!")
			return

	if (href_list["subtlemessage"])
		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	if (href_list["traitor"])
		if(!ticker || !ticker.mode)
			alert("The game hasn't started yet!")
			return
		var/mob/M = locate(href_list["traitor"])
		if (!istype(M))
			player()
			return
		if(isalien(M))
			alert("Is an [M.mind ? M.mind.special_role : "Alien"]!", "[M.key]")
			return
		if (M:mind)
			M:mind.edit_memory()
			return
		alert("Cannot make this mob a traitor! It has no mind!")

	if (href_list["create_object"])
		if (src.rank in list("Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"))
			return create_object(usr)
		else
			alert("You are not a high enough administrator! Sorry!!!!")

	if (href_list["create_turf"])
		if (src.rank in list("Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"))
			return create_turf(usr)
		else
			alert("You are not a high enough administrator! Sorry!!!!")
	if (href_list["create_mob"])
		if (src.rank in list("Badmin", "Game Admin", "Game Master"))
			return create_mob(usr)
		else
			alert("You are not a high enough administrator! Sorry!!!!")
	if (href_list["vmode"])
		vmode()

	if (href_list["votekill"])
		votekill()

	if (href_list["voteres"])
		voteres()

	if (href_list["prom_demot"])
		if ((src.rank in list("Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/client/C = locate(href_list["prom_demot"])
			if(C.holder && (C.holder.level >= src.level))
				alert("This cannot be done as [C] is a [C.holder.rank]")
				return
			var/dat = "[C] is a [C.holder ? "[C.holder.rank]" : "non-admin"]<br><br>Change [C]'s rank?<br>"
			if(src.level == 6)
			//host
				dat += {"
				<A href='?src=\ref[src];chgadlvl=Game Admin;client4ad=\ref[C]'>Game Admin</A> //coder<BR>
				<A href='?src=\ref[src];chgadlvl=Badmin;client4ad=\ref[C]'>Badmin</A> // Shit Guy<BR>
				<A href='?src=\ref[src];chgadlvl=Trial Admin;client4ad=\ref[C]'>Trial Admin</A> // Primary Administrator<BR>
				<A href='?src=\ref[src];chgadlvl=Admin Candidate;client4ad=\ref[C]'>Admin Candidate</A> // // Administrator<BR>
				<A href='?src=\ref[src];chgadlvl=Temporary Admin;client4ad=\ref[C]'>Temporary Admin</A> // Secondary Admin<BR>
				<A href='?src=\ref[src];chgadlvl=Moderator;client4ad=\ref[C]'>Moderator</A> // Moderator<BR>
				<A href='?src=\ref[src];chgadlvl=Admin Observer;client4ad=\ref[C]'>Admin Observer</A> // Filthy Xeno<BR>
				<A href='?src=\ref[src];chgadlvl=Remove;client4ad=\ref[C]'>Remove Admin</A><BR>"}
			else if(src.level == 5)
			//coder
				dat += {"
				<A href='?src=\ref[src];chgadlvl=Badmin;client4ad=\ref[C]'>Badmin</A> // Shit Guy<BR>
				<A href='?src=\ref[src];chgadlvl=Trial Admin;client4ad=\ref[C]'>Trial Admin</A> // Primary Administrator<BR>
				<A href='?src=\ref[src];chgadlvl=Admin Candidate;client4ad=\ref[C]'>Admin Candidate</A> // // Administrator<BR>
				<A href='?src=\ref[src];chgadlvl=Temporary Admin;client4ad=\ref[C]'>Temporary Admin</A> // Secondary Admin<BR>
				<A href='?src=\ref[src];chgadlvl=Moderator;client4ad=\ref[C]'>Moderator</A> // Moderator<BR>
				<A href='?src=\ref[src];chgadlvl=Admin Observer;client4ad=\ref[C]'>Admin Observer</A> // Filthy Xeno<BR>
				<A href='?src=\ref[src];chgadlvl=Remove;client4ad=\ref[C]'>Remove Admin</A><BR>"}
			else
				alert("Not a high enough level admin, sorry.")
				return
			usr << browse(dat, "window=prom_demot;size=480x300")

	if (href_list["chgadlvl"])
	//change admin level
		var/rank = href_list["chgadlvl"]
		var/client/C = locate(href_list["client4ad"])
		if(rank == "Remove")
			C.clear_admin_verbs()
			C.update_admins(null)
			log_admin("[key_name(usr)] has removed [C]'s adminship")
			message_admins("[key_name_admin(usr)] has removed [C]'s adminship", 1)
			admins.Remove(C.ckey)
		else
			C.clear_admin_verbs()
			C.update_admins(rank)
			log_admin("[key_name(usr)] has made [C] a [rank]")
			message_admins("[key_name_admin(usr)] has made [C] a [rank]", 1)
			admins[C.ckey] = rank


	if (href_list["object_list"])
		if (src.rank in list("Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"))
			if (config.allow_admin_spawning && ((src.state == 2) || (src.rank in list("Badmin", "Game Admin", "Game Master"))))
				var/atom/loc = usr.loc

				var/dirty_paths
				if (istext(href_list["object_list"]))
					dirty_paths = list(href_list["object_list"])
				else if (istype(href_list["object_list"], /list))
					dirty_paths = href_list["object_list"]

				var/paths = list()
				var/removed_paths = list()
				for (var/dirty_path in dirty_paths)
					var/path = text2path(dirty_path)
					if (!path)
						removed_paths += dirty_path
					else if (!ispath(path, /obj) && !ispath(path, /turf) && !ispath(path, /mob))
						removed_paths += dirty_path
					else if (ispath(path, /obj/item/weapon/gun/energy/pulse_rifle) && !(src.rank in list("Game Admin", "Game Master")))
						removed_paths += dirty_path
					else if (ispath(path, /obj/item/weapon/melee/energy/blade))//Not an item one should be able to spawn./N
						removed_paths += dirty_path
					else if (ispath(path, /obj/effect/bhole) && !(src.rank in list("Game Admin", "Game Master")))
						removed_paths += dirty_path
					else if (ispath(path, /mob) && !(src.rank in list("Badmin", "Game Admin", "Game Master")))
						removed_paths += dirty_path

					else
						paths += path

				if (!paths)
					return
				else if (length(paths) > 5)
					alert("Select less object types, (max 5)")
					return
				else if (length(removed_paths))
					alert("Removed:\n" + dd_list2text(removed_paths, "\n"))

				var/list/offset = dd_text2list(href_list["offset"],",")
				var/number = dd_range(1, 100, text2num(href_list["object_count"]))
				var/X = offset.len > 0 ? text2num(offset[1]) : 0
				var/Y = offset.len > 1 ? text2num(offset[2]) : 0
				var/Z = offset.len > 2 ? text2num(offset[3]) : 0
				var/tmp_dir = href_list["object_dir"]
				var/obj_dir = tmp_dir ? text2num(tmp_dir) : 2
				if(!obj_dir || !(obj_dir in list(1,2,4,8,5,6,9,10)))
					obj_dir = 2
				var/obj_name = sanitize(href_list["object_name"])
				var/where = href_list["object_where"]
				if (!( where in list("onfloor","inhand","inmarked") ))
					where = "onfloor"

				//TODO ERRORAGE
				if( where == "inhand" )
					usr << "Support for inhand not available yet. Will spawn on floor."
					where = "onfloor"
				//END TODO ERRORAGE

				if ( where == "inhand" )	//Can only give when human or monkey
					if ( !( ishuman(usr) || ismonkey(usr) ) )
						usr << "Can only spawn in hand when you're a human or a monkey."
						where = "onfloor"
					else if ( usr.get_active_hand() )
						usr << "Your active hand is full. Spawning on floor."
						where = "onfloor"
				if ( where == "inmarked" )
					if ( !marked_datum )
						usr << "You don't have any object marked. Abandoning spawn."
						return
					else
						if ( !istype(marked_datum,/atom) )
							usr << "The object you have marked cannot be used as a target. Target must be of type /atom. Abandoning spawn."
							return

				var/atom/target //Where the object will be spawned
				switch ( where )
					if ( "onfloor" )
						switch (href_list["offset_type"])
							if ("absolute")
								target = locate(0 + X,0 + Y,0 + Z)
							if ("relative")
								target = locate(loc.x + X,loc.y + Y,loc.z + Z)
					if ( "inmarked" )
						target = marked_datum


				//TODO ERRORAGE - Give support for "inhand"

				if(target)
					for (var/path in paths)
						for (var/i = 0; i < number; i++)
							var/atom/O = new path(target)
							if(O)
								O.dir = obj_dir
								if(obj_name)
									O.name = obj_name
									if(istype(O,/mob))
										var/mob/M = O
										M.real_name = obj_name



				if (number == 1)
					log_admin("[key_name(usr)] created a [english_list(paths)]")
					for(var/path in paths)
						if(ispath(path, /mob))
							message_admins("[key_name_admin(usr)] created a [english_list(paths)]", 1)
							break
				else
					log_admin("[key_name(usr)] created [number]ea [english_list(paths)]")
					for(var/path in paths)
						if(ispath(path, /mob))
							message_admins("[key_name_admin(usr)] created [number]ea [english_list(paths)]", 1)
							break
				return
			else
				alert("You cannot spawn items right now.")
				return

	if (href_list["secretsfun"])
		if ((src.rank in list( "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/ok = 0
			switch(href_list["secretsfun"])
				if("sec_clothes")
					for(var/obj/item/clothing/under/O in world)
						del(O)
					ok = 1
				if("sec_all_clothes")
					for(var/obj/item/clothing/O in world)
						del(O)
					ok = 1
				if("sec_classic1")
					for(var/obj/item/clothing/suit/fire/O in world)
						del(O)
					for(var/obj/structure/grille/O in world)
						del(O)
/*					for(var/obj/machinery/vehicle/pod/O in world)
						for(var/mob/M in src)
							M.loc = src.loc
							if (M.client)
								M.client.perspective = MOB_PERSPECTIVE
								M.client.eye = M
						del(O)
					ok = 1*/
				if("toxic")
				/*					for(var/obj/machinery/atmoalter/siphs/fullairsiphon/O in world)
						O.t_status = 3
					for(var/obj/machinery/atmoalter/siphs/scrubbers/O in world)
						O.t_status = 1
						O.t_per = 1000000.0
					for(var/obj/machinery/atmoalter/canister/O in world)
						if (!( istype(O, /obj/machinery/atmoalter/canister/oxygencanister) ))
							O.t_status = 1
							O.t_per = 1000000.0
						else
							O.t_status = 3
				*/
					usr << "HEH"
				if("monkey")
					for(var/mob/living/carbon/human/H in world)
						spawn(0)
							H.monkeyize()
					ok = 1
				if("power")
					log_admin("[key_name(usr)] made all areas powered", 1)
					message_admins("\blue [key_name_admin(usr)] made all areas powered", 1)
					power_restore()
				if("unpower")
					log_admin("[key_name(usr)] made all areas unpowered", 1)
					message_admins("\blue [key_name_admin(usr)] made all areas unpowered", 1)
					power_failure()
				if("activateprison")
					world << "\blue <B>Transit signature detected.</B>"
					world << "\blue <B>Incoming shuttle.</B>"
					/*
					var/A = locate(/area/shuttle_prison)
					for(var/atom/movable/AM as mob|obj in A)
						AM.z = 1
						AM.Move()
					*/
					message_admins("\blue [key_name_admin(usr)] sent the prison shuttle to the station.", 1)
				if("deactivateprison")
					/*
					var/A = locate(/area/shuttle_prison)
					for(var/atom/movable/AM as mob|obj in A)
						AM.z = 2
						AM.Move()
					*/
					message_admins("\blue [key_name_admin(usr)] sent the prison shuttle back.", 1)
				if("toggleprisonstatus")
					for(var/obj/machinery/computer/prison_shuttle/PS in world)
						PS.allowedtocall = !(PS.allowedtocall)
						message_admins("\blue [key_name_admin(usr)] toggled status of prison shuttle to [PS.allowedtocall].", 1)
				if("prisonwarp")
					if(!ticker)
						alert("The game hasn't started yet!", null, null, null, null, null)
						return
					message_admins("\blue [key_name_admin(usr)] teleported all players to the prison station.", 1)
					for(var/mob/living/carbon/human/H in world)
						var/turf/loc = find_loc(H)
						var/security = 0
						if(loc.z > 1 || prisonwarped.Find(H))
	//don't warp them if they aren't ready or are already there
							continue
						H.paralysis += 5
						if(H.wear_id)
							var/obj/item/weapon/card/id/id = H.get_idcard()
							for(var/A in id.access)
								if(A == access_security)
									security++
						if(!security)
							//strip their stuff before they teleport into a cell :downs:
							for(var/obj/item/weapon/W in H)
								if(istype(W, /datum/organ/external))
									continue
									//don't strip organs
								H.u_equip(W)
								if (H.client)
									H.client.screen -= W
								if (W)
									W.loc = H.loc
									W.dropped(H)
									W.layer = initial(W.layer)
							//teleport person to cell
							H.loc = pick(prisonwarp)
							H.equip_if_possible(new /obj/item/clothing/under/color/orange(H), H.slot_w_uniform)
							H.equip_if_possible(new /obj/item/clothing/shoes/orange(H), H.slot_shoes)
						else
							//teleport security person
							H.loc = pick(prisonsecuritywarp)
						prisonwarped += H
				if("traitor_all")
					if ((src.rank in list( "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
						if(!ticker)
							alert("The game hasn't started yet!")
							return
						var/objective = input("Enter an objective")
						if(!objective)
							return
						for(var/mob/living/carbon/human/H in world)
							if(H.stat == 2 || !H.client || !H.mind) continue
							if(is_special_character(H)) continue
							//traitorize(H, objective, 0)
							ticker.mode.traitors += H.mind
							H.mind.special_role = "traitor"
							var/datum/objective/new_objective = new
							new_objective.owner = H
							new_objective.explanation_text = objective
							H.mind.objectives += new_objective
							ticker.mode.greet_traitor(H)
							//ticker.mode.forge_traitor_objectives(H.mind)
							ticker.mode.finalize_traitor(H)
						for(var/mob/living/silicon/A in world)
							ticker.mode.traitors += A.mind
							A.mind.special_role = "traitor"
							var/datum/objective/new_objective = new
							new_objective.owner = A
							new_objective.explanation_text = objective
							A.mind.objectives += new_objective
							ticker.mode.greet_traitor(A)
							ticker.mode.finalize_traitor(A)
						message_admins("\blue [key_name_admin(usr)] used everyone is a traitor secret. Objective is [objective]", 1)
						log_admin("[key_name(usr)] used everyone is a traitor secret. Objective is [objective]")
					else
						alert("You're not of a high enough rank to do this")
				if("moveminingshuttle")
					if ((src.rank in list( "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
						if(mining_shuttle_moving)
							return
						move_mining_shuttle()
						message_admins("\blue [key_name_admin(usr)] moved mining shuttle", 1)
						log_admin("[key_name(usr)] moved the mining shuttle")
					else
						alert("You're not of a high enough rank to do this")
				if("moveadminshuttle")
					if ((src.rank in list( "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
						move_admin_shuttle()
						message_admins("\blue [key_name_admin(usr)] moved the centcom administration shuttle", 1)
						log_admin("[key_name(usr)] moved the centcom administration shuttle")
					else
						alert("You're not of a high enough rank to do this")
				if("moveferry")
					if ((src.rank in list( "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
						move_ferry()
						message_admins("\blue [key_name_admin(usr)] moved the centcom ferry", 1)
						log_admin("[key_name(usr)] moved the centcom ferry")
					else
						alert("You're not of a high enough rank to do this")
				if("movealienship")
					if ((src.rank in list( "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
						move_alien_ship()
						message_admins("\blue [key_name_admin(usr)] moved the alien dinghy", 1)
						log_admin("[key_name(usr)] moved the alien dinghy")
					else
						alert("You're not of a high enough rank to do this")
				if("flicklights")
					while(!usr.stat)
	//knock yourself out to stop the ghosts
						for(var/mob/M in world)
							if(M.client && M.stat != 2 && prob(25))
								var/area/AffectedArea = get_area(M)
								if(AffectedArea.name != "Space" && AffectedArea.name != "Engine Walls" && AffectedArea.name != "Chemical Lab Test Chamber" && AffectedArea.name != "Escape Shuttle" && AffectedArea.name != "Arrival Area" && AffectedArea.name != "Arrival Shuttle" && AffectedArea.name != "start area" && AffectedArea.name != "Engine Combustion Chamber")
									AffectedArea.power_light = 0
									AffectedArea.power_change()
									spawn(rand(55,185))
										AffectedArea.power_light = 1
										AffectedArea.power_change()
									var/Message = rand(1,4)
									switch(Message)
										if(1)
											M.show_message(text("\blue You shudder as if cold..."), 1)
										if(2)
											M.show_message(text("\blue You feel something gliding across your back..."), 1)
										if(3)
											M.show_message(text("\blue Your eyes twitch, you feel like something you can't see is here..."), 1)
										if(4)
											M.show_message(text("\blue You notice something moving out of the corner of your eye, but nothing is there..."), 1)
									for(var/obj/W in orange(5,M))
										if(prob(25) && !W.anchored)
											step_rand(W)
						sleep(rand(100,1000))
					for(var/mob/M in world)
						if(M.client && M.stat != 2)
							M.show_message(text("\blue The chilling wind suddenly stops..."), 1)
	/*				if("shockwave")
					ok = 1
					world << "\red <B><big>ALERT: STATION STRESS CRITICAL</big></B>"
					sleep(60)
					world << "\red <B><big>ALERT: STATION STRESS CRITICAL. TOLERABLE LEVELS EXCEEDED!</big></B>"
					sleep(80)
					world << "\red <B><big>ALERT: STATION STRUCTURAL STRESS CRITICAL. SAFETY MECHANISMS FAILED!</big></B>"
					sleep(40)
					for(var/mob/M in world)
						shake_camera(M, 400, 1)
					for(var/obj/structure/window/W in world)
						spawn(0)
							sleep(rand(10,400))
							W.ex_act(rand(2,1))
					for(var/obj/structure/grille/G in world)
						spawn(0)
							sleep(rand(20,400))
							G.ex_act(rand(2,1))
					for(var/obj/machinery/door/D in world)
						spawn(0)
							sleep(rand(20,400))
							D.ex_act(rand(2,1))
					for(var/turf/station/floor/Floor in world)
						spawn(0)
							sleep(rand(30,400))
							Floor.ex_act(rand(2,1))
					for(var/obj/structure/cable/Cable in world)
						spawn(0)
							sleep(rand(30,400))
							Cable.ex_act(rand(2,1))
					for(var/obj/structure/closet/Closet in world)
						spawn(0)
							sleep(rand(30,400))
							Closet.ex_act(rand(2,1))
					for(var/obj/machinery/Machinery in world)
						spawn(0)
							sleep(rand(30,400))
							Machinery.ex_act(rand(1,3))
					for(var/turf/station/wall/Wall in world)
						spawn(0)
							sleep(rand(30,400))
							Wall.ex_act(rand(2,1)) */
				if("wave")
					if ((src.rank in list("Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
						meteor_wave()
						message_admins("[key_name_admin(usr)] has spawned meteors", 1)
						command_alert("Meteors have been detected on collision course with the station.", "Meteor Alert")
						world << sound('meteors.ogg')
					else
						alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
						return
				if("gravanomalies")
					command_alert("Gravitational anomalies detected on the station. There is no additional data.", "Anomaly Alert")
					world << sound('granomalies.ogg')
					var/turf/T = pick(blobstart)
					var/obj/effect/bhole/bh = new /obj/effect/bhole( T.loc, 30 )
					spawn(rand(50, 300))
						del(bh)
				if("timeanomalies")
					command_alert("Space-time anomalies detected on the station. There is no additional data.", "Anomaly Alert")
					world << sound('spanomalies.ogg')
					var/list/turfs = list(	)
					var/turf/picked
					for(var/turf/T in world)
						if(T.z == 1 && istype(T,/turf/simulated/floor) && !istype(T,/turf/space))
							turfs += T
					for(var/turf/T in world)
						set background = 1
						if(prob(20) && T.z == 1 && istype(T,/turf/simulated/floor))
							spawn(50+rand(0,3000))
								picked = pick(turfs)
								var/obj/effect/portal/P = new /obj/effect/portal( T )
								P.target = picked
								P.creator = null
								P.icon = 'objects.dmi'
								P.failchance = 0
								P.icon_state = "anom"
								P.name = "wormhole"
								spawn(rand(300,600))
									del(P)
				if("goblob")
					mini_blob_event()
					message_admins("[key_name_admin(usr)] has spawned blob", 1)
				if("aliens")
					if(aliens_allowed)
						alien_infestation()
						message_admins("[key_name_admin(usr)] has spawned aliens", 1)
				if("spaceninja")
					if(toggle_space_ninja)
						if(space_ninja_arrival())//If the ninja is actually spawned. They may not be depending on a few factors.
							message_admins("[key_name_admin(usr)] has sent in a space ninja", 1)
				if("carp")
					var/choice = input("You sure you want to spawn carp?") in list("Badmin", "Cancel")
					if(choice == "Badmin")
						message_admins("[key_name_admin(usr)] has spawned carp.", 1)
						carp_migration()
				if("radiation")
					message_admins("[key_name_admin(usr)] has has irradiated the station", 1)
					high_radiation_event()
				if("immovable")
					message_admins("[key_name_admin(usr)] has sent an immovable rod to the station", 1)
					immovablerod()
				if("prison_break")
					message_admins("[key_name_admin(usr)] has allowed a prison break", 1)
					prison_break()
				if("lightsout")
					message_admins("[key_name_admin(usr)] has broke a lot of lights", 1)
					lightsout(1,2)
				if("blackout")
					message_admins("[key_name_admin(usr)] broke all lights", 1)
					lightsout(0,0)
				if("virus")
					if(alert("Do you want this to be a random disease or do you have something in mind?",,"Random","Choose")=="Random")
						viral_outbreak()
						message_admins("[key_name_admin(usr)] has triggered a virus outbreak", 1)
					else
						var/list/viruses = list("fake gbs","gbs","magnitis","wizarditis",/*"beesease",*/"brain rot","cold","retrovirus","flu","pierrot's throat","rhumba beat")
						var/V = input("Choose the virus to spread", "BIOHAZARD") in viruses
						viral_outbreak(V)
						message_admins("[key_name_admin(usr)] has triggered a virus outbreak of [V]", 1)
				if("retardify")
					if (src.rank in list("Badmin", "Game Admin", "Game Master"))
						for(var/mob/living/carbon/human/H in world)
							if(H.client)
								H << "\red <B>You suddenly feel stupid.</B>"
							H.brainloss = 60
						message_admins("[key_name_admin(usr)] made everybody retarded")
					else
						alert("You cannot perform this action. You must be of a higher administrative rank!")
						return
				if("fakeguns")
					if (src.rank in list("Badmin", "Game Admin", "Game Master"))
						for(var/obj/item/W in world)
							if(istype(W, /obj/item/clothing) || istype(W, /obj/item/weapon/card/id) || istype(W, /obj/item/weapon/disk) || istype(W, /obj/item/weapon/tank))
								continue
							W.icon = 'gun.dmi'
							W.icon_state = "revolver"
							W.item_state = "gun"
						message_admins("[key_name_admin(usr)] made every item look like a gun")
					else
						alert("You cannot perform this action. You must be of a higher administrative rank!")
						return
				if("schoolgirl")
					if (src.rank in list("Badmin", "Game Admin", "Game Master"))
						for(var/obj/item/clothing/under/W in world)
							W.icon_state = "schoolgirl"
							W.item_state = "w_suit"
							W.color = "schoolgirl"
						message_admins("[key_name_admin(usr)] activated Japanese Animes mode")
						world << sound('animes.ogg')
					else
						alert("You cannot perform this action. You must be of a higher administrative rank!")
						return
				if("dorf")
					if (src.rank in list("Badmin","Game Admin", "Game Master"))
						for(var/mob/living/carbon/human/B in world)
							B.face_icon_state = "facial_wise"
							B.update_face()
						message_admins("[key_name_admin(usr)] activated dorf mode")
					else
						alert("You cannot perform this action. You must be of a higher administrative rank!")
						return
				if("ionstorm")
					if (src.rank in list("Badmin","Game Admin", "Game Master"))
						IonStorm()
						message_admins("[key_name_admin(usr)] triggered an ion storm")
						var/show_log = alert(usr, "Show ion message?", "Message", "Yes", "No")
						if(show_log == "Yes")
							command_alert("Ion storm detected near the station. Please check all AI-controlled equipment for errors.", "Anomaly Alert")
							world << sound('ionstorm.ogg')
					else
						alert("You cannot perform this action. You must be of a higher administrative rank!")
						return
			if (usr)
				log_admin("[key_name(usr)] used secret [href_list["secretsfun"]]")
				if (ok)
					world << text("<B>A secret has been activated by []!</B>", usr.key)
		return

	if (href_list["secretsadmin"])
		if ((src.rank in list( "Moderator", "Temporary Admin", "Admin Candidate", "Trial Admin", "Badmin", "Game Admin", "Game Master"  )))
			var/ok = 0
			switch(href_list["secretsadmin"])
				if("clear_bombs")
					//I do nothing
				if("list_bombers")
					var/dat = "<B>Bombing List<HR>"
					for(var/l in bombers)
						dat += text("[l]<BR>")
					usr << browse(dat, "window=bombers")
				if("list_signalers")
					var/dat = "<B>Showing last [length(lastsignalers)] signalers.</B><HR>"
					for(var/sig in lastsignalers)
						dat += "[sig]<BR>"
					usr << browse(dat, "window=lastsignalers;size=800x500")
				if("list_lawchanges")
					var/dat = "<B>Showing last [length(lawchanges)] law changes.</B><HR>"
					for(var/sig in lawchanges)
						dat += "[sig]<BR>"
					usr << browse(dat, "window=lawchanges;size=800x500")
				if("list_job_debug")
					var/dat = "<B>Job Debug info.</B><HR>"
					if(job_master)
						for(var/line in job_master.job_debug)
							dat += "[line]<BR>"
						dat+= "*******<BR><BR>"
						for(var/datum/job/job in job_master.occupations)
							if(!job)	continue
							dat += "job: [job.title], current_positions: [job.current_positions], total_positions: [job.total_positions] <BR>"
						usr << browse(dat, "window=jobdebug;size=600x500")
				if("check_antagonist")
					if (ticker && ticker.current_state >= GAME_STATE_PLAYING)
						var/dat = "<html><head><title>Round Status</title></head><body><h1><B>Round Status</B></h1>"
						dat += "Current Game Mode: <B>[ticker.mode.name]</B><BR>"
						dat += "Round Duration: <B>[round(world.time / 36000)]:[add_zero(world.time / 600 % 60, 2)]:[world.time / 100 % 6][world.time / 100 % 10]</B><BR>"
						dat += "<B>Emergency shuttle</B><BR>"
						if (!emergency_shuttle.online)
							dat += "<a href='?src=\ref[src];call_shuttle=1'>Call Shuttle</a><br>"
						else
							var/timeleft = emergency_shuttle.timeleft()
							switch(emergency_shuttle.location)
								if(0)
									dat += "ETA: <a href='?src=\ref[src];edit_shuttle_time=1'>[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]</a><BR>"
									dat += "<a href='?src=\ref[src];call_shuttle=2'>Send Back</a><br>"
								if(1)
									dat += "ETA: <a href='?src=\ref[src];edit_shuttle_time=1'>[(timeleft / 60) % 60]:[add_zero(num2text(timeleft % 60), 2)]</a><BR>"

						if(ticker.mode.syndicates.len)
							dat += "<br><table cellspacing=5><tr><td><B>Syndicates</B></td><td></td></tr>"
							for(var/datum/mind/N in ticker.mode.syndicates)
								var/mob/M = N.current
								if(M)
									dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
									dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td></tr>"
								else
									dat += "<tr><td><i>Nuclear Operative not found!</i></td></tr>"
							dat += "</table><br><table><tr><td><B>Nuclear Disk(s)</B></td></tr>"
							for(var/obj/item/weapon/disk/nuclear/N in world)
								dat += "<tr><td>[N.name], "
								var/atom/disk_loc = N.loc
								while(!istype(disk_loc, /turf))
									if(istype(disk_loc, /mob))
										var/mob/M = disk_loc
										dat += "carried by <a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a> "
									if(istype(disk_loc, /obj))
										var/obj/O = disk_loc
										dat += "in \a [O.name] "
									disk_loc = disk_loc.loc
								dat += "in [disk_loc.loc] at ([disk_loc.x], [disk_loc.y], [disk_loc.z])</td></tr>"
							dat += "</table>"

						if(ticker.mode.head_revolutionaries.len || ticker.mode.revolutionaries.len)
							dat += "<br><table cellspacing=5><tr><td><B>Revolutionaries</B></td><td></td></tr>"
							for(var/datum/mind/N in ticker.mode.head_revolutionaries)
								var/mob/M = N.current
								if(!M)
									dat += "<tr><td><i>Head Revolutionary not found!</i></td></tr>"
								else
									dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a> <b>(Leader)</b>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
									dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td></tr>"
							for(var/datum/mind/N in ticker.mode.revolutionaries)
								var/mob/M = N.current
								if(M)
									dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
									dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td></tr>"
							dat += "</table><table cellspacing=5><tr><td><B>Target(s)</B></td><td></td><td><B>Location</B></td></tr>"
							for(var/datum/mind/N in ticker.mode.get_living_heads())
								var/mob/M = N.current
								if(M)
									dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
									dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td>"
									var/turf/mob_loc = get_turf_loc(M)
									dat += "<td>[mob_loc.loc]</td></tr>"
								else
									dat += "<tr><td><i>Head not found!</i></td></tr>"
							dat += "</table>"

						if(ticker.mode.changelings.len > 0)
							dat += "<br><table cellspacing=5><tr><td><B>Changelings</B></td><td></td><td></td></tr>"
							for(var/datum/mind/changeling in ticker.mode.changelings)
								var/mob/M = changeling.current
								if(M)
									dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
									dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td>"
									dat += "<td><A HREF='?src=\ref[src];traitor=\ref[M]'>Show Objective</A></td></tr>"
								else
									dat += "<tr><td><i>Changeling not found!</i></td></tr>"
							dat += "</table>"

						if(ticker.mode.wizards.len > 0)
							dat += "<br><table cellspacing=5><tr><td><B>Wizards</B></td><td></td><td></td></tr>"
							for(var/datum/mind/wizard in ticker.mode.wizards)
								var/mob/M = wizard.current
								if(M)
									dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
									dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td>"
									dat += "<td><A HREF='?src=\ref[src];traitor=\ref[M]'>Show Objective</A></td></tr>"
								else
									dat += "<tr><td><i>Wizard not found!</i></td></tr>"
							dat += "</table>"

						if(ticker.mode.cult.len)
							dat += "<br><table cellspacing=5><tr><td><B>Cultists</B></td><td></td></tr>"
							for(var/datum/mind/N in ticker.mode.cult)
								var/mob/M = N.current
								if(M)
									dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
									dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td></tr>"
							dat += "</table>"

						if(ticker.mode.traitors.len > 0)
							dat += "<br><table cellspacing=5><tr><td><B>Traitors</B></td><td></td><td></td></tr>"
							for(var/datum/mind/traitor in ticker.mode.traitors)
								var/mob/M = traitor.current
								if(M)
									dat += "<tr><td><a href='?src=\ref[src];adminplayeropts=\ref[M]'>[M.real_name]</a>[M.client ? "" : " <i>(logged out)</i>"][M.stat == 2 ? " <b><font color=red>(DEAD)</font></b>" : ""]</td>"
									dat += "<td><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td>"
									dat += "<td><A HREF='?src=\ref[src];traitor=\ref[M]'>Show Objective</A></td></tr>"
								else
									dat += "<tr><td><i>Traitor not found!</i></td></tr>"
							dat += "</table>"

						dat += "</body></html>"
						usr << browse(dat, "window=roundstatus;size=400x500")
					else
						alert("The game hasn't started yet!")
				if("showailaws")
					for(var/mob/living/silicon/ai/ai in world)
						usr << "[key_name(ai, usr)]'s Laws:"
						if (ai.laws == null)
							usr << "[key_name(ai, usr)]'s Laws are null??"
						else
							ai.laws.show_laws(usr)
				if("showgm")
					if(!ticker)
						alert("The game hasn't started yet!")
					else if (ticker.mode)
						alert("The game mode is [ticker.mode.name]")
					else alert("For some reason there's a ticker, but not a game mode")
				if("manifest")
					var/dat = "<B>Showing Crew Manifest.</B><HR>"
					dat += "<table cellspacing=5><tr><th>Name</th><th>Position</th></tr>"
					for(var/mob/living/carbon/human/H in world)
						if(H.ckey)
							dat += text("<tr><td>[]</td><td>[]</td></tr>", H.name, H.get_assignment())
					dat += "</table>"
					usr << browse(dat, "window=manifest;size=440x410")
				if("DNA")
					var/dat = "<B>Showing DNA from blood.</B><HR>"
					dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
					for(var/mob/living/carbon/human/H in world)
						if(H.dna && H.ckey)
							dat += "<tr><td>[H]</td><td>[H.dna.unique_enzymes]</td><td>[H.b_type]</td></tr>"
					dat += "</table>"
					usr << browse(dat, "window=DNA;size=440x410")
				if("fingerprints")
					var/dat = "<B>Showing Fingerprints.</B><HR>"
					dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
					for(var/mob/living/carbon/human/H in world)
						if(H.ckey)
							if(H.dna && H.dna.uni_identity)
								dat += "<tr><td>[H]</td><td>[md5(H.dna.uni_identity)]</td></tr>"
							else if(H.dna && !H.dna.uni_identity)
								dat += "<tr><td>[H]</td><td>H.dna.uni_identity = null</td></tr>"
							else if(!H.dna)
								dat += "<tr><td>[H]</td><td>H.dna = null</td></tr>"
					dat += "</table>"
					usr << browse(dat, "window=fingerprints;size=440x410")
				else
			if (usr)
				log_admin("[key_name(usr)] used secret [href_list["secretsadmin"]]")
				if (ok)
					world << text("<B>A secret has been activated by []!</B>", usr.key)
		return
	if (href_list["secretscoder"])
		if ((src.rank in list( "Badmin", "Game Admin", "Game Master" )))
			switch(href_list["secretscoder"])
				if("spawn_objects")
					var/dat = "<B>Admin Log<HR></B>"
					for(var/l in admin_log)
						dat += "<li>[l]</li>"
					if(!admin_log.len)
						dat += "No-one has done anything this round!"
					usr << browse(dat, "window=admin_log")
				if("maint_access_brig")
					for(var/obj/machinery/door/airlock/maintenance/M in world)
						if (access_maint_tunnels in M.req_access)
							M.req_access = list(access_brig)
					message_admins("[key_name_admin(usr)] made all maint doors brig access-only.")
				if("maint_access_engiebrig")
					for(var/obj/machinery/door/airlock/maintenance/M in world)
						if (access_maint_tunnels in M.req_access)
							M.req_access = list()
							M.req_one_access = list(access_brig,access_engine)
					message_admins("[key_name_admin(usr)] made all maint doors engineering and brig access-only.")
				if("infinite_sec")
					var/datum/job/J = job_master.GetJob("Security Officer")
					if(!J) return
					J.total_positions = -1
					J.spawn_positions = -1
					message_admins("[key_name_admin(usr)] has removed the cap on security officers.")
		return
		//hahaha

///////////////////////////////////////////////////////////////////////////////////////////////Panels

/obj/admins/proc/show_player_panel(var/mob/M in world)
	set category = "Admin"
	set name = "Show Player Panel"
	set desc="Edit player (respawn, ban, heal, etc)"
	if(!M)
		usr << "You seem to be selecting a mob that doesn't exist anymore."
		return
	if (!istype(src,/obj/admins))
		src = usr.client.holder
	if (!istype(src,/obj/admins))
		usr << "Error: you are not an admin!"
		return
	var/dat = "<html><head><title>Options for [M.key]</title></head>"
	var/foo = "\[ "
	if (ismob(M) && M.client)
		if(!M.client.authenticated && !M.client.authenticating)
			foo += text("<A HREF='?src=\ref[src];adminauth=\ref[M]'>Authorize</A> | ")
		else
			foo += text("<B>Authorized</B> | ")
		foo += text("<A HREF='?src=\ref[src];prom_demot=\ref[M.client]'>Promote/Demote</A> | ")
		if(!istype(M, /mob/new_player))
			if(!ismonkey(M))
				foo += text("<A HREF='?src=\ref[src];monkeyone=\ref[M]'>Monkeyize</A> | ")
			else
				foo += text("<B>Monkeyized</B> | ")
			if(isAI(M))
				foo += text("<B>Is an AI</B> | ")
			else if(ishuman(M))
				foo += text("<A HREF='?src=\ref[src];makeai=\ref[M]'>Make AI</A> | ")
				foo += text("<A HREF='?src=\ref[src];makerobot=\ref[M]'>Make Robot</A> | ")
				foo += text("<A HREF='?src=\ref[src];makealien=\ref[M]'>Make Alien</A> | ")
				foo += text("<A HREF='?src=\ref[src];makemetroid=\ref[M]'>Make Metroid</A> | ")
			foo += text("<A HREF='?src=\ref[src];tdome1=\ref[M]'>Thunderdome 1</A> | ")
			foo += text("<A HREF='?src=\ref[src];tdome2=\ref[M]'>Thunderdome 2</A> | ")
			foo += text("<A HREF='?src=\ref[src];tdomeadmin=\ref[M]'>Thunderdome Admin</A> | ")
			foo += text("<A HREF='?src=\ref[src];tdomeobserve=\ref[M]'>Thunderdome Observer</A> | ")
			foo += text("<A HREF='?src=\ref[src];sendtoprison=\ref[M]'>Prison</A> | ")
		//	foo += text("<A HREF='?src=\ref[src];sendtomaze=\ref[M]'>Maze</A> | ")
			foo += text("<A HREF='?src=\ref[src];revive=\ref[M]'>Heal/Revive</A> | ")
		else
			foo += text("<B>Hasn't Entered Game</B> | ")
		foo += text("<A href='?src=\ref[src];forcespeech=\ref[M]'>Forcesay</A> | ")
		if(M.client)
			foo += text("<A href='?src=\ref[src];mute2=\ref[M]'>Mute: [(M.client.muted ? "Muted" : "Voiced")]</A> | ")
			foo += text("<A href='?src=\ref[src];mute_complete=\ref[M]'>Complete mute: [(M.client.muted ? "Completely Muted" : "Voiced")]</A> | ")
		else
			foo += "Mute unavailable - no client"
		foo += text("<A href='?src=\ref[src];boot2=\ref[M]'>Boot</A>")
	foo += text("<br>")
	foo += text("<A href='?src=\ref[src];jumpto=\ref[M]'>Jump to</A> | ")
	foo += text("<A href='?src=\ref[src];getmob=\ref[M]'>Get</A> | ")
	foo += text("<A href='?src=\ref[src];sendmob=\ref[M]'>Send</A>")
	foo += text("<br>")
	foo += text("<A href='?src=\ref[src];traitor=\ref[M]'>Edit mind</A> | ")
	foo += text("<A href='?src=\ref[src];narrateto=\ref[M]'>Narrate to</A> | ")
	foo += text("<A href='?src=\ref[src];subtlemessage=\ref[M]'>Subtle message</A>")
	foo += text("<br>")
	foo += text("<A href='?src=\ref[src];newban=\ref[M]'>Ban</A> | ")
	foo += text("<A href='?src=\ref[src];jobban2=\ref[M]'>Jobban</A>")
	dat += text("<body>[foo]</body></html>")
	usr << browse(dat, "window=adminplayeropts;size=480x150")

/obj/admins/proc/player()
	if (!usr.client.holder)
		return
	var/dat = "<html><head><title>Player Menu</title></head>"
	dat += "<body><table border=1 cellspacing=5><B><tr><th>Name</th><th>Real Name</th><th>Key</th><th>Options</th><th>PM</th><th>Traitor?</th><th>Karma</th></tr></B>"
	//add <th>IP:</th> to this if wanting to add back in IP checking
	//add <td>(IP: [M.lastKnownIP])</td> if you want to know their ip to the lists below
	var/list/mobs = sortmobs()
	var/show_karma = 0
	var/DBConnection/dbcon

	if(config.sql_enabled) // SQL is enabled in config.txt
		dbcon = new() // Setting up connection
		dbcon.Connect("dbi:mysql:[sqldb]:[sqladdress]:[sqlport]","[sqllogin]","[sqlpass]")
		if(dbcon.IsConnected())
			show_karma = 1
		else
			usr << "\red Unable to connect to karma database. This error can occur if your host has failed to set up an SQL database or improperly configured its login credentials.<br>"

	if(!show_karma)
		for(var/mob/M in mobs)
			if(M.ckey)
				dat += "<tr><td>[M.name]</td>"
				if(istype(M, /mob/living/silicon/ai))
					dat += "<td>AI</td>"
				if(istype(M, /mob/living/silicon/robot))
					dat += "<td>Cyborg</td>"
				if(istype(M, /mob/living/carbon/human))
					dat += "<td>[M.real_name]</td>"
				if(istype(M, /mob/living/silicon/pai))
					dat += "<td>pAI</td>"
				if(istype(M, /mob/new_player))
					dat += "<td>New Player</td>"
				if(istype(M, /mob/dead/observer))
					dat += "<td>Ghost</td>"
				if(istype(M, /mob/living/carbon/monkey))
					dat += "<td>Monkey</td>"
				if(istype(M, /mob/living/carbon/alien))
					dat += "<td>Alien</td>"
				dat += {"<td>[M.client?"[M.client]":"No client"]</td>
				<td align=center><A HREF='?src=\ref[src];adminplayeropts=\ref[M]'>X</A></td>
				<td align=center><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td>
				"}
				switch(is_special_character(M))
					if(0)
						dat += {"<td align=center><A HREF='?src=\ref[src];traitor=\ref[M]'>Traitor?</A></td>"}
					if(1)
						dat += {"<td align=center><A HREF='?src=\ref[src];traitor=\ref[M]'><font color=red>Traitor?</font></A></td>"}
					if(2)
						dat += {"<td align=center><A HREF='?src=\ref[src];traitor=\ref[M]'><font color=red><b>Traitor?</b></font></A></td>"}
				if (config.sql_enabled)
					dat += "<td><font color=red>ERROR</font></td></tr>"
				else
					dat += "<td>disabled</td></tr>"

	else

		for(var/mob/M in mobs)
			if(M.ckey)

				var/DBQuery/query = dbcon.NewQuery("SELECT karma FROM karmatotals WHERE byondkey='[M.key]'")
				query.Execute()

				var/currentkarma
				while(query.NextRow())
					currentkarma = query.item[1]

				dat += "<tr><td>[M.name]</td>"
				if(isAI(M))
					dat += "<td>AI</td>"
				if(isrobot(M))
					dat += "<td>Cyborg</td>"
				if(ishuman(M))
					dat += "<td>[M.real_name]</td>"
				if(istype(M, /mob/living/silicon/pai))
					dat += "<td>pAI</td>"
				if(istype(M, /mob/new_player))
					dat += "<td>New Player</td>"
				if(isobserver(M))
					dat += "<td>Ghost</td>"
				if(ismonkey(M))
					dat += "<td>Monkey</td>"
				if(isalien(M))
					dat += "<td>Alien</td>"
				dat += {"<td>[(M.client ? "[M.client]" : "No client")]</td>
				<td align=center><A HREF='?src=\ref[src];adminplayeropts=\ref[M]'>X</A></td>
				<td align=center><A href='?src=\ref[usr];priv_msg=\ref[M]'>PM</A></td>
				"}
				switch(is_special_character(M))
					if(0)
						dat += {"<td align=center><A HREF='?src=\ref[src];traitor=\ref[M]'>Traitor?</A></td>"}
					if(1)
						dat += {"<td align=center><A HREF='?src=\ref[src];traitor=\ref[M]'><font color=red>Traitor?</font></A></td>"}
					if(2)
						dat += {"<td align=center><A HREF='?src=\ref[src];traitor=\ref[M]'><font color=red><b>Traitor?</b></font></A></td>"}
				if(currentkarma)
					dat += "<td>[currentkarma]</td></tr>"
				else
					dat += "<td>0</td></tr>"

	dat += "</table></body></html>"

	usr << browse(dat, "window=players;size=540x480")


/obj/admins/proc/Jobbans()

	if ((src.rank in list( "Game Admin", "Game Master"  )))
		var/dat = "<B>Job Bans!</B><HR><table>"
		for(var/t in jobban_keylist)
			dat += text("<tr><td><A href='?src=\ref[src];removejobban=[t]'>[t]</A></td></tr>")
		dat += "</table>"
		usr << browse(dat, "window=ban;size=400x400")

/obj/admins/proc/Game()

	var/dat
	var/lvl = 0
	switch(src.rank)
		if("Moderator")
			lvl = 1
		if("Temporary Admin")
			lvl = 2
		if("Admin Candidate")
			lvl = 3
		if("Trial Admin")
			lvl = 4
		if("Badmin")
			lvl = 5
		if("Game Admin")
			lvl = 6
		if("Game Master")
			lvl = 7

	dat += "<center><B>Game Panel</B></center><hr>\n"

	if(lvl > 0)

//			if(lvl >= 2 )
		dat += "<A href='?src=\ref[src];c_mode=1'>Change Game Mode</A><br>"

	if(lvl > 0 && master_mode == "secret")
		dat += "<A href='?src=\ref[src];f_secret=1'>(Force Secret Mode)</A><br>"

	dat += "<BR>"

	if(lvl >= 3 )
		dat += "<A href='?src=\ref[src];create_object=1'>Create Object</A><br>"
		dat += "<A href='?src=\ref[src];create_turf=1'>Create Turf</A><br>"
	if(lvl >= 5)
		dat += "<A href='?src=\ref[src];create_mob=1'>Create Mob</A><br>"
//			if(lvl == 6 )
	usr << browse(dat, "window=admin2;size=210x180")
	return
/*
/obj/admins/proc/goons()
	var/dat = "<HR><B>GOOOOOOONS</B><HR><table cellspacing=5><tr><th>Key</th><th>SA Username</th></tr>"
	for(var/t in goon_keylist)
		dat += text("<tr><td><A href='?src=\ref[src];remove=[ckey(t)]'><B>[t]</B></A></td><td>[goon_keylist[ckey(t)]]</td></tr>")
	dat += "</table>"
	usr << browse(dat, "window=ban;size=300x400")

/obj/admins/proc/beta_testers()
	var/dat = "<HR><B>Beta testers</B><HR><table cellspacing=5><tr><th>Key</th></tr>"
	for(var/t in beta_tester_keylist)
		dat += text("<tr><td>[t]</td></tr>")
	dat += "</table>"
	usr << browse(dat, "window=ban;size=300x400")
*/
/obj/admins/proc/Secrets()
	if (!usr.client.holder)
		return

	var/lvl = 0
	switch(src.rank)
		if("Moderator")
			lvl = 1
		if("Temporary Admin")
			lvl = 2
		if("Admin Candidate")
			lvl = 3
		if("Trial Admin")
			lvl = 4
		if("Badmin")
			lvl = 5
		if("Game Admin")
			lvl = 6
		if("Game Master")
			lvl = 7

	var/dat = {"
<B>Choose a secret, any secret at all.</B><HR>
<B>Admin Secrets</B><BR>
<BR>
<A href='?src=\ref[src];secretsadmin=clear_bombs'>Remove all bombs currently in existence</A><BR>
<A href='?src=\ref[src];secretsadmin=list_bombers'>Bombing List</A><BR>
<A href='?src=\ref[src];secretsadmin=check_antagonist'>Show current traitors and objectives</A><BR>
<A href='?src=\ref[src];secretsadmin=list_signalers'>Show last [length(lastsignalers)] signalers</A><BR>
<A href='?src=\ref[src];secretsadmin=list_lawchanges'>Show last [length(lawchanges)] law changes</A><BR>
<A href='?src=\ref[src];secretsadmin=showailaws'>Show AI Laws</A><BR>
<A href='?src=\ref[src];secretsadmin=showgm'>Show Game Mode</A><BR>
<A href='?src=\ref[src];secretsadmin=manifest'>Show Crew Manifest</A><BR>
<A href='?src=\ref[src];secretsadmin=DNA'>List DNA (Blood)</A><BR>
<A href='?src=\ref[src];secretsadmin=fingerprints'>List Fingerprints</A><BR><BR>
<BR>"}
	if(lvl > 2)
		dat += {"
<B>'Random' Events</B><BR>
<BR>
<A href='?src=\ref[src];secretsfun=wave'>Spawn a wave of meteors</A><BR>
<A href='?src=\ref[src];secretsfun=gravanomalies'>Spawn a gravitational anomaly (Untested)</A><BR>
<A href='?src=\ref[src];secretsfun=timeanomalies'>Spawn wormholes (Untested)</A><BR>
<A href='?src=\ref[src];secretsfun=goblob'>Spawn blob(Untested)</A><BR>
<A href='?src=\ref[src];secretsfun=aliens'>Trigger an Alien infestation</A><BR>
<A href='?src=\ref[src];secretsfun=spaceninja'>Send in a space ninja</A><BR>
<A href='?src=\ref[src];secretsfun=carp'>Trigger an Carp migration</A><BR>
<A href='?src=\ref[src];secretsfun=radiation'>Irradiate the station</A><BR>
<A href='?src=\ref[src];secretsfun=prison_break'>Trigger a Prison Break</A><BR>
<A href='?src=\ref[src];secretsfun=virus'>Trigger a Virus Outbreak</A><BR>
<A href='?src=\ref[src];secretsfun=immovable'>Spawn an Immovable Rod</A><BR>
<A href='?src=\ref[src];secretsfun=lightsout'>Toggle a "lights out" event</A><BR>
<A href='?src=\ref[src];secretsfun=ionstorm'>Spawn an Ion Storm</A><BR>
<BR>
<B>Fun Secrets</B><BR>
<BR>
<A href='?src=\ref[src];secretsfun=sec_clothes'>Remove 'internal' clothing</A><BR>
<A href='?src=\ref[src];secretsfun=sec_all_clothes'>Remove ALL clothing</A><BR>
<A href='?src=\ref[src];secretsfun=toxic'>Toxic Air (WARNING: dangerous)</A><BR>
<A href='?src=\ref[src];secretsfun=monkey'>Turn all humans into monkies</A><BR>
<A href='?src=\ref[src];secretsfun=sec_classic1'>Remove firesuits, grilles, and pods</A><BR>
<A href='?src=\ref[src];secretsfun=power'>Make all areas powered</A><BR>
<A href='?src=\ref[src];secretsfun=unpower'>Make all areas unpowered</A><BR>
<A href='?src=\ref[src];secretsfun=toggleprisonstatus'>Toggle Prison Shuttle Status(Use with S/R)</A><BR>
<A href='?src=\ref[src];secretsfun=activateprison'>Send Prison Shuttle</A><BR>
<A href='?src=\ref[src];secretsfun=deactivateprison'>Return Prison Shuttle</A><BR>
<A href='?src=\ref[src];secretsfun=prisonwarp'>Warp all Players to Prison</A><BR>
<A href='?src=\ref[src];secretsfun=traitor_all'>Everyone is the traitor</A><BR>
<A href='?src=\ref[src];secretsfun=flicklights'>Ghost Mode</A><BR>
<A href='?src=\ref[src];secretsfun=retardify'>Make all players retarded</A><BR>
<A href='?src=\ref[src];secretsfun=fakeguns'>Make all items look like guns</A><BR>
<A href='?src=\ref[src];secretsfun=schoolgirl'>Japanese Animes Mode</A><BR>
<A href='?src=\ref[src];secretsfun=moveadminshuttle'>Move Administration Shuttle</A><BR>
<A href='?src=\ref[src];secretsfun=moveferry'>Move Ferry</A><BR>
<A href='?src=\ref[src];secretsfun=movealienship'>Move Alien Dinghy</A><BR>
<A href='?src=\ref[src];secretsfun=moveminingshuttle'>Move Mining Shuttle</A><BR>
<A href='?src=\ref[src];secretsfun=blackout'>Break all lights</A><BR><BR>"}
//<A href='?src=\ref[src];secretsfun=shockwave'>Station Shockwave</A><BR>

	if(lvl >= 5)
		dat += {"
<B>Security Level Elevated</B><BR>
<BR>
<A href='?src=\ref[src];secretscoder=maint_access_engiebrig'>Change all maintenance doors to engie/brig access only</A><BR>
<A href='?src=\ref[src];secretscoder=maint_access_brig'>Change all maintenance doors to brig access only</A><BR>
<A href='?src=\ref[src];secretscoder=infinite_sec'>Remove cap on security officers</A><BR>
<BR>
<B>Coder Secrets</B><BR>
<BR>
<A href='?src=\ref[src];secretsadmin=list_job_debug'>Show Job Debug</A><BR>
<A href='?src=\ref[src];secretscoder=spawn_objects'>Admin Log</A><BR>
<BR>
"}
	usr << browse(dat, "window=secrets")
	return

/obj/admins/proc/Voting()

	var/dat
	var/lvl = 0
	switch(src.rank)
		if("Moderator")
			lvl = 1
		if("Temporary Admin")
			lvl = 2
		if("Admin Candidate")
			lvl = 3
		if("Trial Admin")
			lvl = 4
		if("Badmin")
			lvl = 5
		if("Game Admin")
			lvl = 6
		if("Game Master")
			lvl = 7


	dat += "<center><B>Voting</B></center><hr>\n"

	if(lvl > 0)
//			if(lvl >= 2 )
		dat += {"
<A href='?src=\ref[src];votekill=1'>Abort Vote</A><br>
<A href='?src=\ref[src];vmode=1'>Start Vote</A><br>
<A href='?src=\ref[src];voteres=1'>Toggle Voting</A><br>
"}

//			if(lvl >= 3 )
//			if(lvl >= 5)
//			if(lvl == 6 )

	usr << browse(dat, "window=admin2;size=210x160")
	return



/////////////////////////////////////////////////////////////////////////////////////////////////admins2.dm merge
//i.e. buttons/verbs


/obj/admins/proc/vmode()
	set category = "Server"
	set name = "Start Vote"
	set desc="Starts vote"
	if (!usr.client.holder)
		return
	var/confirm = alert("What vote would you like to start?", "Vote", "Restart", "Change Game Mode", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Restart")
		vote.mode = 0
	// hack to yield 0=restart, 1=changemode
	if(confirm == "Change Game Mode")
		vote.mode = 1
		if(!ticker)
			if(going)
				world << "<B>The game start has been delayed.</B>"
				going = 0
	vote.voting = 1
						// now voting
	vote.votetime = world.timeofday + config.vote_period*10
	// when the vote will end
	spawn(config.vote_period*10)
		vote.endvote()
	world << "\red<B>*** A vote to [vote.mode?"change game mode":"restart"] has been initiated by Admin [usr.key].</B>"
	world << "\red     You have [vote.timetext(config.vote_period)] to vote."

	log_admin("Voting to [vote.mode?"change mode":"restart round"] forced by admin [key_name(usr)]")

	for(var/mob/CM in world)
		if(CM.client)
			if(config.vote_no_default || (config.vote_no_dead && CM.stat == 2) || !CM.client.authenticated)
				CM.client.vote = "none"
			else
				CM.client.vote = "default"

	for(var/mob/CM in world)
		if(CM.client)
			if(config.vote_no_default || (config.vote_no_dead && CM.stat == 2) || !CM.client.authenticated)
				CM.client.vote = "none"
			else
				CM.client.vote = "default"

/obj/admins/proc/votekill()
	set category = "Server"
	set name = "Abort Vote"
	set desc="Aborts a vote"
	if(vote.voting == 0)
		alert("No votes in progress")
		return
	world << "\red <b>*** Voting aborted by [usr.client.stealth ? "Admin Candidate" : usr.key].</b>"

	log_admin("Voting aborted by [key_name(usr)]")

	vote.voting = 0
	vote.nextvotetime = world.timeofday + 10*config.vote_delay

	for(var/mob/M in world)
		// clear vote window from all clients
		if(M.client)
			M << browse(null, "window=vote")
			M.client.showvote = 0

/obj/admins/proc/voteres()
	set category = "Server"
	set name = "Toggle Voting"
	set desc="Toggles Votes"
	var/confirm = alert("What vote would you like to toggle?", "Vote", "Restart [config.allow_vote_restart ? "Off" : "On"]", "Change Game Mode [config.allow_vote_mode ? "Off" : "On"]", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Restart [config.allow_vote_restart ? "Off" : "On"]")
		config.allow_vote_restart = !config.allow_vote_restart
		world << "<b>Player restart voting toggled to [config.allow_vote_restart ? "On" : "Off"]</b>."
		log_admin("Restart voting toggled to [config.allow_vote_restart ? "On" : "Off"] by [key_name(usr)].")

		if(config.allow_vote_restart)
			vote.nextvotetime = world.timeofday
	if(confirm == "Change Game Mode [config.allow_vote_mode ? "Off" : "On"]")
		config.allow_vote_mode = !config.allow_vote_mode
		world << "<b>Player mode voting toggled to [config.allow_vote_mode ? "On" : "Off"]</b>."
		log_admin("Mode voting toggled to [config.allow_vote_mode ? "On" : "Off"] by [key_name(usr)].")

		if(config.allow_vote_mode)
			vote.nextvotetime = world.timeofday

/obj/admins/proc/restart()
	set category = "Server"
	set name = "Restart"
	set desc="Restarts the world"
	if (!usr.client.holder)
		return
	var/confirm = alert("Restart the game world?", "Restart", "Yes", "Cancel")
	if(confirm == "Cancel")
		return
	if(confirm == "Yes")
		world << "\red <b>Restarting world!</b> \blue Initiated by [usr.client.stealth ? "Admin" : usr.key]!"
		log_admin("[key_name(usr)] initiated a reboot.")

		feedback_set_details("end_error","admin reboot - by [usr.key] [usr.client.stealth ? "(stealth)" : ""]")
		feedback_set_details("round_end","[time2text(world.realtime)]")
		if(blackbox)
			blackbox.save_all_data_to_sql()

		sleep(50)
		world.Reboot()

/obj/admins/proc/announce()
	set category = "Special Verbs"
	set name = "Announce"
	set desc="Announce your desires to the world"
	var/message = input("Global message to send:", "Admin Announce", null, null)  as message
	if (message)
		if(usr.client.holder.rank != "Game Admin" && usr.client.holder.rank != "Game Master")
			message = adminscrub(message,500)
		world << "\blue <b>[usr.client.stealth ? "Administrator" : usr.key] Announces:</b>\n \t [message]"
		log_admin("Announce: [key_name(usr)] : [message]")

/obj/admins/proc/toggleooc()
	set category = "Server"
	set desc="Toggle dis bitch"
	set name="Toggle OOC"
	ooc_allowed = !( ooc_allowed )
	if (ooc_allowed)
		world << "<B>The OOC channel has been globally enabled!</B>"
	else
		world << "<B>The OOC channel has been globally disabled!</B>"
	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled OOC.", 1)

/obj/admins/proc/toggleoocdead()
	set category = "Server"
	set desc="Toggle dis bitch"
	set name="Toggle Dead OOC"
	dooc_allowed = !( dooc_allowed )

	log_admin("[key_name(usr)] toggled OOC.")
	message_admins("[key_name_admin(usr)] toggled Dead OOC.", 1)

/obj/admins/proc/toggletraitorscaling()
	set category = "Server"
	set desc="Toggle traitor scaling"
	set name="Toggle Traitor Scaling"
	traitor_scaling = !traitor_scaling
	log_admin("[key_name(usr)] toggled Traitor Scaling to [traitor_scaling].")
	message_admins("[key_name_admin(usr)] toggled Traitor Scaling [traitor_scaling ? "on" : "off"].", 1)

/obj/admins/proc/startnow()
	set category = "Server"
	set desc="Start the round RIGHT NOW"
	set name="Start Now"
	if(!ticker)
		alert("Unable to start the game as it is not set up.")
		return
	if(ticker.current_state == GAME_STATE_PREGAME)
		ticker.current_state = GAME_STATE_SETTING_UP
		log_admin("[usr.key] has started the game.")
		message_admins("<font color='blue'>[usr.key] has started the game.</font>")
		return 1
	else
		alert("Game has already started you fucking jerk, stop spamming up the chat :ARGH:")
		return 0

/obj/admins/proc/toggleenter()
	set category = "Server"
	set desc="People can't enter"
	set name="Toggle Entering"
	enter_allowed = !( enter_allowed )
	if (!( enter_allowed ))
		world << "<B>New players may no longer enter the game.</B>"
	else
		world << "<B>New players may now enter the game.</B>"
	log_admin("[key_name(usr)] toggled new player game entering.")
	message_admins("\blue [key_name_admin(usr)] toggled new player game entering.", 1)
	world.update_status()

/obj/admins/proc/toggleAI()
	set category = "Server"
	set desc="People can't be AI"
	set name="Toggle AI"
	config.allow_ai = !( config.allow_ai )
	if (!( config.allow_ai ))
		world << "<B>The AI job is no longer chooseable.</B>"
	else
		world << "<B>The AI job is chooseable now.</B>"
	log_admin("[key_name(usr)] toggled AI allowed.")
	world.update_status()

/obj/admins/proc/toggleaban()
	set category = "Server"
	set desc="Respawn basically"
	set name="Toggle Respawn"
	abandon_allowed = !( abandon_allowed )
	if (abandon_allowed)
		world << "<B>You may now respawn.</B>"
	else
		world << "<B>You may no longer respawn :(</B>"
	message_admins("\blue [key_name_admin(usr)] toggled respawn to [abandon_allowed ? "On" : "Off"].", 1)
	log_admin("[key_name(usr)] toggled respawn to [abandon_allowed ? "On" : "Off"].")
	world.update_status()

/obj/admins/proc/toggle_aliens()
	set category = "Server"
	set desc="Toggle alien mobs"
	set name="Toggle Aliens"
	aliens_allowed = !aliens_allowed
	log_admin("[key_name(usr)] toggled Aliens to [aliens_allowed].")
	message_admins("[key_name_admin(usr)] toggled Aliens [aliens_allowed ? "on" : "off"].", 1)

/obj/admins/proc/toggle_space_ninja()
	set category = "Server"
	set desc="Toggle space ninjas spawning."
	set name="Toggle Space Ninjas"
	toggle_space_ninja = !toggle_space_ninja
	log_admin("[key_name(usr)] toggled Space Ninjas to [toggle_space_ninja].")
	message_admins("[key_name_admin(usr)] toggled Space Ninjas [toggle_space_ninja ? "on" : "off"].", 1)

/obj/admins/proc/delay()
	set category = "Server"
	set desc="Delay the game start"
	set name="Delay"
	if (!ticker || ticker.current_state != GAME_STATE_PREGAME)
		return alert("Too late... The game has already started!", null, null, null, null, null)
	going = !( going )
	if (!( going ))
		world << "<b>The game start has been delayed.</b>"
		log_admin("[key_name(usr)] delayed the game.")
	else
		world << "<b>The game will start soon.</b>"
		log_admin("[key_name(usr)] removed the delay.")

/obj/admins/proc/adjump()
	set category = "Server"
	set desc="Toggle admin jumping"
	set name="Toggle Jump"
	config.allow_admin_jump = !(config.allow_admin_jump)
	message_admins("\blue Toggled admin jumping to [config.allow_admin_jump].")

/obj/admins/proc/adspawn()
	set category = "Server"
	set desc="Toggle admin spawning"
	set name="Toggle Spawn"
	config.allow_admin_spawning = !(config.allow_admin_spawning)
	message_admins("\blue Toggled admin item spawning to [config.allow_admin_spawning].")

/obj/admins/proc/adrev()
	set category = "Server"
	set desc="Toggle admin revives"
	set name="Toggle Revive"
	config.allow_admin_rev = !(config.allow_admin_rev)
	message_admins("\blue Toggled reviving to [config.allow_admin_rev].")

/obj/admins/proc/immreboot()
	set category = "Server"
	set desc="Reboots the server post haste"
	set name="Immediate Reboot"
	if( alert("Reboot server?",,"Yes","No") == "No")
		return
	world << "\red <b>Rebooting world!</b> \blue Initiated by [usr.client.stealth ? "Admin" : usr.key]!"
	log_admin("[key_name(usr)] initiated an immediate reboot.")

	feedback_set_details("end_error","immediate admin reboot - by [usr.key] [usr.client.stealth ? "(stealth)" : ""]")
	feedback_set_details("round_end","[time2text(world.realtime)]")
	if(blackbox)
		blackbox.save_all_data_to_sql()

	world.Reboot()

/client/proc/deadchat()
	set category = "Admin"
	set desc="Toggles Deadchat Visibility"
	set name="Deadchat Visibility"
	if(deadchat == 0)
		deadchat = 1
		usr << "Deadchat turned on"
	else
		deadchat = 0
		usr << "Deadchat turned off"

/client/proc/toggleprayers()
	set category = "Admin"
	set desc="Toggles Prayer Visibility"
	set name="Prayer Visibility"
	if(seeprayers == 0)
		seeprayers = 1
		usr << "Prayer visibility turned on"
	else
		seeprayers = 0
		usr << "Prayer visibility turned off"

/obj/admins/proc/unprison(var/mob/M in world)
	set category = "Admin"
	set name = "Unprison"
	if (M.z == 2)
		if (config.allow_admin_jump)
			M.loc = pick(latejoin)
			message_admins("[key_name_admin(usr)] has unprisoned [key_name_admin(M)]", 1)
			log_admin("[key_name(usr)] has unprisoned [key_name(M)]")
		else
			alert("Admin jumping disabled")
	else
		alert("[M.name] is not prisoned.")

////////////////////////////////////////////////////////////////////////////////////////////////ADMIN HELPER PROCS

/proc/is_special_character(mob/M as mob) // returns 1 for specail characters and 2 for heroes of gamemode
	if(!ticker || !ticker.mode)
		return 0
	if (!istype(M))
		return 0
	if((M.mind in ticker.mode.head_revolutionaries) || (M.mind in ticker.mode.revolutionaries))
		if (ticker.mode.config_tag == "revolution")
			return 2
		return 1
	if(M.mind in ticker.mode.cult)
		if (ticker.mode.config_tag == "cult")
			return 2
		return 1
	if(M.mind in ticker.mode.malf_ai)
		if (ticker.mode.config_tag == "malfunction")
			return 2
		return 1
	if(M.mind in ticker.mode.syndicates)
		if (ticker.mode.config_tag == "nuclear")
			return 2
		return 1
	if(M.mind in ticker.mode.wizards)
		if (ticker.mode.config_tag == "wizard")
			return 2
		return 1
	if(M.mind in ticker.mode.changelings)
		if (ticker.mode.config_tag == "changeling")
			return 2
		return 1

	for(var/datum/disease/D in M.viruses)
		if(istype(D, /datum/disease/jungle_fever))
			if (ticker.mode.config_tag == "monkey")
				return 2
			return 1
	if(isrobot(M))
		var/mob/living/silicon/robot/R = M
		if(R.emagged)
			return 1
	if(M.mind&&M.mind.special_role)//If they have a mind and special role, they are some type of traitor or antagonist.
		return 1

	return 0

/*
/obj/admins/proc/get_sab_desc(var/target)
	switch(target)
		if(1)
			return "Destroy at least 70% of the plasma canisters on the station"
		if(2)
			return "Destroy the AI"
		if(3)
			var/count = 0
			for(var/mob/living/carbon/monkey/Monkey in world)
				if(Monkey.z == 1)
					count++
			return "Kill all [count] of the monkeys on the station"
		if(4)
			return "Cut power to at least 80% of the station"
		else
			return "Error: Invalid sabotage target: [target]"
*/
/obj/admins/proc/spawn_atom(var/object as text)
	set category = "Debug"
	set desc= "(atom path) Spawn an atom"
	set name= "Spawn"

	if(usr.client.holder.level >= 5)
		var/list/types = typesof(/atom)

		var/list/matches = new()

		for(var/path in types)
			if(findtext("[path]", object))
				matches += path

		if(matches.len==0)
			return

		var/chosen
		if(matches.len==1)
			chosen = matches[1]
		else
			chosen = input("Select an atom type", "Spawn Atom", matches[1]) as null|anything in matches
			if(!chosen)
				return

		new chosen(usr.loc)

		log_admin("[key_name(usr)] spawned [chosen] at ([usr.x],[usr.y],[usr.z])")


	else
		alert("You cannot perform this action. You must be of a higher administrative rank!", null, null, null, null, null)
		return


/obj/admins/proc/show_traitor_panel(var/mob/M in world)
	set category = "Admin"
	set desc = "Edit mobs's memory and role"
	set name = "Show Traitor Panel"

	if (!M.mind)
		usr << "Sorry, this mob has no mind!"
	M.mind.edit_memory()


/obj/admins/proc/toggletintedweldhelmets()
	set category = "Debug"
	set desc="Reduces view range when wearing welding helmets"
	set name="Toggle tinted welding helmes"
	tinted_weldhelh = !( tinted_weldhelh )
	if (tinted_weldhelh)
		world << "<B>The tinted_weldhelh has been enabled!</B>"
	else
		world << "<B>The tinted_weldhelh has been disabled!</B>"
	log_admin("[key_name(usr)] toggled tinted_weldhelh.")
	message_admins("[key_name_admin(usr)] toggled tinted_weldhelh.", 1)

/obj/admins/proc/toggleguests()
	set category = "Server"
	set desc="Guests can't enter"
	set name="Toggle guests"
	guests_allowed = !( guests_allowed )
	if (!( guests_allowed ))
		world << "<B>Guests may no longer enter the game.</B>"
	else
		world << "<B>Guests may now enter the game.</B>"
	log_admin("[key_name(usr)] toggled guests game entering [guests_allowed?"":"dis"]allowed.")
	message_admins("\blue [key_name_admin(usr)] toggled guests game entering [guests_allowed?"":"dis"]allowed.", 1)



/obj/admins/proc/view_txt_log()
	set category = "Admin"
	set desc="Shows todays server log in new window"
	set name="Show Server Log"
	var/path = "data/logs/[time2text(world.realtime,"YYYY")]/[time2text(world.realtime,"MM")]-[time2text(world.realtime,"Month")]/[time2text(world.realtime,"DD")]-[time2text(world.realtime,"Day")].log"
	var/output = {"<html>
						<head>
						<title>[time2text(world.realtime,"Day, MMM DD, YYYY")] - Log</title>
						</head>
						<body>
						<pre>
						[file2text(path)]
						</pre>
						</body>
						</html>"}
	usr << browse(output,"window=server_logfile")
	onclose(usr,"server_logfile")
	return

/client/proc/unjobban_panel()
	set name = "Unjobban Panel"
	set category = "Admin"
	if (src.holder)
		src.holder.unjobbanpanel()
	return


//
//
//ALL DONE
//*********************************************************************************************************
//TO-DO:
//
//


/**********************Administration Shuttle**************************/

var/admin_shuttle_location = 0 // 0 = centcom 13, 1 = station

proc/move_admin_shuttle()
	var/area/fromArea
	var/area/toArea
	if (admin_shuttle_location == 1)
		fromArea = locate(/area/shuttle/administration/station)
		toArea = locate(/area/shuttle/administration/centcom)
	else
		fromArea = locate(/area/shuttle/administration/centcom)
		toArea = locate(/area/shuttle/administration/station)
	fromArea.move_contents_to(toArea)
	if (admin_shuttle_location)
		admin_shuttle_location = 0
	else
		admin_shuttle_location = 1
	return

/**********************Centcom Ferry**************************/

var/ferry_location = 0 // 0 = centcom , 1 = station

proc/move_ferry()
	var/area/fromArea
	var/area/toArea
	if (ferry_location == 1)
		fromArea = locate(/area/shuttle/transport1/station)
		toArea = locate(/area/shuttle/transport1/centcom)
	else
		fromArea = locate(/area/shuttle/transport1/centcom)
		toArea = locate(/area/shuttle/transport1/station)
	fromArea.move_contents_to(toArea)
	if (ferry_location)
		ferry_location = 0
	else
		ferry_location = 1
	return

/**********************Alien ship**************************/

var/alien_ship_location = 1 // 0 = base , 1 = mine

proc/move_alien_ship()
	var/area/fromArea
	var/area/toArea
	if (alien_ship_location == 1)
		fromArea = locate(/area/shuttle/alien/mine)
		toArea = locate(/area/shuttle/alien/base)
	else
		fromArea = locate(/area/shuttle/alien/base)
		toArea = locate(/area/shuttle/alien/mine)
	fromArea.move_contents_to(toArea)
	if (alien_ship_location)
		alien_ship_location = 0
	else
		alien_ship_location = 1
	return