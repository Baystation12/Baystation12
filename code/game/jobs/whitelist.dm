var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(config.usewhitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	whitelist = file2list("config/whitelist.txt")
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
//	if(!whitelist)
//		return 0
//	return ("[M.ckey]" in whitelist)
	for (var/s in whitelist)
		if(findtext(s,"[M.ckey]"))
			return 1
	return 0

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(config.usealienwhitelist)
		load_alienwhitelist()
	return 1

/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		diary << "Failed to load config/alienwhitelist.txt\n"
	else
		alien_whitelist = text2list(text, "\n")

//todo: admin aliens
/proc/is_alien_whitelisted(mob/M, var/species)
	if(!config.usealienwhitelist)
		return 1
	if(species == "human" || species == "Human")
		return 1
	if(check_rights(R_ADMIN, 0))
		return 1
	if(!alien_whitelist)
		return 0
	if(M && species)
		for (var/s in alien_whitelist)
			if(findtext(s,"[M.ckey] - [species]"))
				return 1
			if(findtext(s,"[M.ckey] - All"))
				return 1

	return 0

client/proc/get_alienwhitelist()
	set category = "Server"
	set name = "Whitelist(Alien): Check"
	if(!check_rights(R_ADMIN))	return

	var/path = "config/alienwhitelist.txt"
	if( fexists(path) )
		src << run( file(path) )
	else
		src << "<font color='red'>Error: get_alienwhitelist(): File not found/Invalid path([path]).</font>"
		return
	return

/client/proc/add_to_alienwhitelist()
	set category = "Server"
	set name = "Whitelist(Alien): Add"
	if(!check_rights(R_ADMIN))	return

	var/path = "config/alienwhitelist.txt"
	var/player = ckey(input("Input player byound key", "\n") as text)
	if(length(player) == 0)
		return
	player += " - "
	player += input("Input alien species, e.g. Soghun, Tajaran, Skrell, Diona") as text
	player += " ,added by [src.key]\n"
	if(fexists(path))
		text2file(player,path)
		load_alienwhitelist()
	else
		src << "<font color='red'>Error: get_alienwhitelist(): File not found/Invalid path([path]).</font>"
	message_admins("Alien whitelist: [player]", 1)
	return

client/proc/get_whitelist()
	set category = "Server"
	set name = "Whitelist: Check"
	if(!check_rights(R_ADMIN))	return

	var/path = "config/whitelist.txt"
	if( fexists(path) )
		src << run( file(path) )
	else
		src << "<font color='red'>Error: get_whitelist(): File not found/Invalid path([path]).</font>"
		return
	feedback_add_details("admin_verb","GWL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return


/client/proc/add_to_whitelist()
	set category = "Server"
	set name = "Whitelist: Add"
	if(!check_rights(R_ADMIN))	return

	var/path = "config/whitelist.txt"
	var/player = ckey(input("Input player byound key", "\n") as text)
	if(length(player) == 0)
		return
	player += " ,added by [src.key]\n"
	if(fexists(path))
		text2file(player,path)
		load_whitelist()
	else
		src << "<font color='red'>Error: get_whitelist(): File not found/Invalid path([path]).</font>"
	message_admins("Whitelist: [player]", 1)
	return
