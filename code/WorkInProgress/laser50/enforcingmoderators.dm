#define WHITELISTFILE "config/enforcingmods.txt"

var/list/enfmods = list()
var/admin_requested_enfmod = 0

/proc/load_enfmods()
	enfmods = file2list(WHITELISTFILE)
	if(!enfmods.len)	enfmods = null

/client/proc/Is_Enfmod(client/C)
	if(!enfmods)
		return 0
	if(C)
		return ("[C.ckey]" in enfmods)

/proc/Draft_Enfmods()
	var/list/possiblemods = list()
	for(var/client/C in clients)
		spawn(0)
			if(C.Is_Enfmod(C))
				if(locate(C in admins))
					continue
				switch(alert("Would you like to become an enforcing moderator this round?", "Enforcing Moderator draft", "Yes", "No"))
					if("Yes")
						possiblemods.Add(C)
						C << "\red Thank you for responding, Enforcing moderators will be drafted soon."
	return possiblemods

/proc/Check_EnfMod_Need()
	var/ratio = round(clients.len/8, 1) // Predicting 1 admin for 8 players, on 40 players that is 40/8 = 5
	if(admin_requested_enfmod >= 1)
		return 1
	if(admins.len > ratio) // If we have more admins than the ratio predicts we need, No.
		return 0
	else if(admins.len == ratio) // If we have the precise amount the ratio predicts, 50/50 chance yes or no.
		if(prob(50))
			return 1
		else
			return 0
	else if(admins.len < ratio) // If we have too little admins, Yes.
		return 1
	admin_requested_enfmod = 0 // Reset the value.

/world/proc/EnfModProcessor()
	while(src)
		if(Check_EnfMod_Need())
			for(var/client/C in Draft_Enfmods())
				var/title = "Moderator"
				if(config.mods_are_mentors) title = "Mentor"
				var/rights = admin_ranks[title]
				var/datum/admins/D = new /datum/admins(title, rights, C.ckey)
				D.associate(directory[C.ckey])
				return
		sleep(600)