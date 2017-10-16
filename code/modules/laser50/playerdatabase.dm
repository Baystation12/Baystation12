var/global/savefile/userdb = new("data/userdatabase.db")
var/datum/userdb/userdatabase

/datum/userdb
	var/list/userdblist = list() //Simple cache.
	var/screen = 0 // 0 = list, 1 = account screen

/datum/userdb/proc/AddToDB(var/client/C)
	if(userdb && C)
		if(userdb["[C.key]"])
			return 0 // Already in the DB, no action required.
		else
			userdb["[C.key]"] << C.key

/datum/admins/offlinedb/proc/offline_player_database()//The new one
	if (!usr.client.holder)
		return
	var/dat = "<html><head><title>Admin Player Database</title></head>"

	if(!userdatabase.userdblist.len)
		for(var/entry in userdb.dir)
			userdatabase.userdblist.Add(entry)
			dat += "<a href='?src=\ref[src];choice=userdb;player=\ref[entry]'><b>[entry]</b></a><br>"
	else
		for(var/entry in userdatabase.userdblist) //Cache
			dat += "<a href='?src=\ref[src];choice=userdb;player=\ref[entry]'><b>[entry]</b></a><br>"

	usr << browse(dat, "window=playerdb;size=600x480")

/datum/admins/offlinedb/Topic(href, href_list)
	var/dat = "<html><head><title>Admin Player Database</title></head>"
	switch(href_list["choice"])
		if("userdb")
			var/player = locate(href_list["player"])
			if(!player)
				return

			dat = {"
					<html>
					<head>
						<title>[player] User DB</title>
					</head>
					<body>
						<h1>[player] User DB></h1>
						<b>Administrative Options:</b>
						<a href='?src=\ref[src];selected=ban;player=\ref[player]'>Ban Player</a>
						<a href='?src=\ref[src];selected=jobban;player=\ref[player]'>jobban Player</a>
						<a href='?src=\ref[src];selected=whitelist;player=\ref[player]'>Set Whitelist/donator</a>
						"}
	switch(href_list["selected"])
		if("ban")
			if(!check_rights(R_MOD,0) && !check_rights(R_BAN, 0))
				to_chat(usr, "<span class='warning'>You do not have the appropriate permissions to add bans!</span>")
				return

			if(check_rights(R_MOD,0) && !check_rights(R_ADMIN, 0) && !config.mods_can_job_tempban) // If mod and tempban disabled
				to_chat(usr, "<span class='warning'>Mod jobbanning is disabled!</span>")
				return

			var/player = locate(href_list["player"])
			if(!player)	return 0 //No player? abort.

			var/client/C = new()
			C.ckey = player
			C.loadclientdb(player) // Load up his shit

			switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
				if("Yes")
					var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num|null
					if(!mins)
						return
					if(check_rights(R_MOD, 0) && !check_rights(R_BAN, 0) && mins > config.mod_tempban_max)
						to_chat(usr, "<span class='warning'>Moderators can only job tempban up to [config.mod_tempban_max] minutes!</span>")
						return
					if(mins >= 525600) mins = 525599
					var/reason = sanitize(input(usr,"Reason?","reason","Griefer") as text|null)
					if(!reason)
						return
					AddBan(player, C.cidlogs[10], reason, usr.ckey, 1, mins, C.iplogs[10])
					ban_unban_log_save("[usr.client.ckey] has banned [player]. - Reason: [reason] - This will be removed in [mins] minutes.")
					notes_add(player,"[usr.client.ckey] has banned [player]. - Reason: [reason] - This will be removed in [mins] minutes.",usr)
					feedback_inc("ban_tmp",1)
					feedback_inc("ban_tmp_mins",mins)
					log_and_message_admins("has banned [player].\nReason: [reason]\nThis will be removed in [mins] minutes.")
					qdel(C)

				if("No")
					if(!check_rights(R_BAN))   return
					var/reason = sanitize(input(usr,"Reason?","reason","Griefer") as text|null)
					if(!reason)
						return
					AddBan(player, C.cidlogs[10], reason, usr.ckey, 0, 0, C.iplogs[10])
					ban_unban_log_save("[usr.client.ckey] has permabanned [player]. - Reason: [reason] - This is a ban until appeal.")
					notes_add(player,"[usr.client.ckey] has permabanned [player]. - Reason: [reason] - This is a ban until appeal.",usr)
					log_and_message_admins("has banned [player].\nReason: [reason]\nThis is a ban until appeal.")
					feedback_inc("ban_perma",1)
					qdel(C)
				if("Cancel")
					return
		if("jobban")
			return
		if("whitelist")
			var/type = input("Select what type of whitelist", "Add User to Whitelist") in list( "Command Whitelist", "Alien Whitelist", "Donators" )
			var/player = locate(href_list["player"])
			if(!player)	return 0 //No player? abort.

			var/client/C = new()
			C.ckey = player
			C.loadclientdb(player) // Load up his shit
			var/aor = alert("Add or Remove from list?", "Whitelist editing", "Add", "Remove")
			if(!aor)	return 0
			switch(type)
				if("Command Whitelist")
					if(aor == "Remove")
						if(C.command_whitelist && C.command_whitelist)
							var/reason = input("Reason for removal?", "Command whitelist removal") as text
							if(!reason)	return to_chat(usr, "No reason specified, aborting.")
							notes_add(player,"[usr.client.ckey] removed command whitelist from [player]. - Reason: [reason]",usr)
							to_chat(usr, "Command roles removed from [C]")
							message_admins("[key_name_admin(usr)] has de-whitelisted [C].")
					else
						if(C.command_whitelist)
							usr << "<span class='warning'>Could not add [C] to the command whitelist. Already on whitelist.</span>"
							return 0
						else
							message_admins("[key_name_admin(usr)] has whitelisted [C].")
							C.command_whitelist = 1
				if("Alien Whitelist")
					var/datum/species/race = input("Which species?") as null|anything in whitelisted_species
					if(!race)
						return 0
					if(aor == "Remove" && C.alien_whitelist)
						var/reason = input("Reason for removal?", "Alien whitelist removal") as text
						if(!reason)	return to_chat(usr, "No reason specified, aborting.")
						if(findtext(C.alien_whitelist, race.name))
							C.alien_whitelist = replacetext(C.alien_whitelist, race.name, "")
						notes_add(player,"[usr.client.ckey] removed alien whitelist ([race.name]) from [player]. - Reason: [reason]",usr)
						to_chat(usr, "whitelist for [race.name] removed from [C]")
						message_admins("[key_name_admin(usr)] has de-whitelisted [C] for species [race.name]")
					else
						if(!C.alien_whitelist)
							C.alien_whitelist = "[race.name]"
						else
							if(findtext(C.alien_whitelist, race.name)) //What, already in there?
								usr << "<span class='warning'>Could not add [race] to the whitelist of [C]. Already found.</span>"
								return 0
							else
								C.alien_whitelist = "[C.alien_whitelist],[race.name]"
						message_admins("[key_name_admin(usr)] has whitelisted [C] for [race].")
						to_chat(C, "Whitelisted for race [race].")
				if("Donators")
					if(aor == "remove" && is_donator(C))
						var/reason = input("Reason for removal?", "donator status removal") as text
						if(!reason)	return to_chat(usr, "No reason specified, aborting.")
						notes_add(player,"[usr.client.ckey] removed donator status from [player]. - Reason: [reason]",usr)
						to_chat(usr, "Donator status removed from [C]")
						message_admins("[key_name_admin(usr)] has removed donator status from [C].")
					else
						if(is_donator(C))
							usr << "<span class='warning'>Could not add [C] to donators. Already a donator.</span>"
							return 0
						C.donator = 1
						message_admins("[key_name_admin(usr)] has added [C] as a donator.")
						to_chat(C, "Donator status added.")
			if(C.saveclientdb())
				usr << "Whitelist written to file."
			else
				usr << "Whitelist could not be written, please try again or contact laser."
	usr << browse(dat, "window=offlineppanel;size=600x480")

