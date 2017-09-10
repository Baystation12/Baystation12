var/datum/enforcingmods/enfmods

/datum/enforcingmods
	var/list/enforcingmods = list()
	var/modscore = 0 //0 means no need for a moderator, 100 means it will get at least 1 moderator if possible on its next loop.
	var/max_enfmods = 4
	var/active_enfmods = 0

/datum/enforcingmods/proc/CheckScore()
	var/afk_admins = 0
	for(var/client/C in GLOB.admins)
		if(check_rights((R_ADMIN|R_MOD),0,C))
			if(C.is_afk(9000)) // More than 15 minutes of AFK time = Really AFK
				afk_admins++
	var/active_admins = GLOB.admins.len - afk_admins
	var/admplayratio
	if(!active_admins) // No fucking admins?
		modscore += 25
	else
		admplayratio = GLOB.clients.len / active_admins // Ratio of 10 is perfect (1 admin per 10 players)
	if(active_enfmods < max_enfmods)
		modscore += 10
	if(admplayratio < 10) // Ratio is not good enough.
		modscore += admplayratio*5 // 1 point per ratio point missed.
		modscore += adminhelps_unanswered*3
	else if(admplayratio >= 10)
		modscore -= admplayratio*5
	modscore -= active_enfmods*5
	if(modscore >= 25)
		selectenfmods()
	spawn(18000)
		CheckScore()

/datum/enforcingmods/proc/selectenfmods()
	if(modscore >= 25) // Otherwise no use..
		if(prob(modscore))
			var/modsneeded
			switch(modscore)
				if(25 to 50)
					modsneeded = pick(1)
				if(51 to 74)
					modsneeded = pick(1, 2)
				if(75 to 200)
					modsneeded = pick(1, 2, 3)
			world << "Mods list is [enforcingmods.len] long."
			var/list/acceptedinvites = list()
			for(var/client/C in enforcingmods)
				if(C.is_afk(6000))
					continue
				if(C.mob && C.mob.mind.special_role)
					continue // Skip Antags too.
				world << "Chose [C]"
				switch(alert(C, "Would you like to become an enforcing moderator this round?","Enforcing Moderator","Yes","No"))
					if("Yes")
						acceptedinvites.Add(C)
					if("No")
						enforcingmods.Remove(C)

			for(var/client/C in acceptedinvites)
				while(modsneeded)
					C.holder = new /datum/admins("Enforcing Moderator",R_MOD,C)
					C.holder.associate(src)
					message_admins("[C.key] has been auto-modded based on score ([modscore])")
					modsneeded--
					active_enfmods++
			modscore = 0

/client/verb/SetModScore()
	set name = "Set mod score"
	enfmods.modscore = input("Choose score") as num
	usr << "Modscore is now [enfmods.modscore]"
	var/answer = input("Would you like to check now?","EnfMods") in list("yes","no")
	if(answer == "yes")
		enfmods.CheckScore()

/client/verb/SetEnfMod()
	set name = "Set enfmod"
	var/client/C = input("Add who?", "Enf Mod") in GLOB.clients
	if(C)
		enfmods.enforcingmods.Add(C)