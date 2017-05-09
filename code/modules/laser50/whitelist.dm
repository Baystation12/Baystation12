/proc/check_whitelist(mob/M)
	if(!M)
		return 0
	if(check_rights(R_ADMIN, 0, M))
		return 1
	return M.client.command_whitelist

/proc/is_species_whitelisted(mob/M, var/species_name)
	var/datum/species/S = all_species[species_name]
	return is_alien_whitelisted(M, S)

//todo: admin aliens
/proc/is_alien_whitelisted(mob/M, var/species)
	if(!M || !species)
		return 0
	if(check_rights(R_ADMIN, 0, M))
		return 1

	if(istype(species,/datum/language))
		var/datum/language/L = species
		if(!(L.flags & (WHITELISTED|RESTRICTED)))
			return 1
		return whitelist_lookup(L.name, M.client)

	if(istype(species,/datum/species))
		var/datum/species/S = species
		if(!(S.spawn_flags & (SPECIES_IS_WHITELISTED|SPECIES_IS_RESTRICTED)))
			return 1
		return whitelist_lookup(S.get_bodytype(S), M.client)
	return 0

/proc/whitelist_lookup(var/item, var/client/C)
	if(!item || !C)
		return 0
	if(findtext(C.alien_whitelist,"[item]") || findtext(C.alien_whitelist,"All"))
		return 1
	return 0

/client/proc/add_whitelist()
	set category = "Admin"
	set name = "Write to whitelist"
	set desc = "Adds a user to any whitelist available in the directory mid-round."

	if(!check_rights(R_ADMIN|R_MOD))
		return
	var/client/C
	switch(alert("Is player online?","Set whitelist","Yes","No"))
		if("Yes")
			C = input("Please, select a player!", "Add User to Whitelist") in clients
			if(!C || C == src)
				usr << "<span class='warning'>Either he/she does not exsist or you've tried promoting yourself.</span>"
				return 0

	var/type = input("Select what type of whitelist", "Add User to Whitelist") as null|anything in list( "Command Whitelist", "Alien Whitelist", "Donators" )

	switch(type)
		if("Command Whitelist")
			if(C.command_whitelist)
				usr << "<span class='warning'>Could not add [C] to the command whitelist. Already on whitelist.</span>"
				return 0
			else
				message_admins("[key_name_admin(usr)] has whitelisted [C].")
				to_chat(C, "Whitelisted for command roles.")
				C.command_whitelist = 1
		if("Alien Whitelist")
			var/datum/species/race = input("Which species?") as null|anything in whitelisted_species
			if(!race)
				return 0
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
			if(is_donator(C))
				usr << "<span class='warning'>Could not add [C] to donators. Already a donator.</span>"
				return 0
			C.donator = 1
			message_admins("[key_name_admin(usr)] has added [C] as a donator.")
			to_chat(C, "Donator status added.")
	if(C.saveclientdb())
		usr << "Whitelist written to file."