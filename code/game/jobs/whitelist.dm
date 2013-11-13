#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/proc/load_whitelist()
	whitelist = file2list(WHITELISTFILE)
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return 0
	return ("[M.ckey]" in whitelist)

var/list/alien_whitelist = list()

proc/load_alienwhitelist()
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

client/proc/get_whitelist()
	set category = "Admin"
	set name = "Check Whitelist"
	if(!check_rights(R_ADMIN))	return

	var/path = "data/whitelist.txt"
	if( fexists(path) )
		src << run( file(path) )
	else
		src << "<font color='red'>Error: get_whitelist(): File not found/Invalid path([path]).</font>"
		return
	feedback_add_details("admin_verb","GWL") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return


/client/proc/add_to_whitelist()
	set category = "Admin"
	set name = "Add To Whitelist"
	if(!check_rights(R_ADMIN))	return

	var/path = "data/whitelist.txt"
	var/player = input("Input player byound key", "\n") as text
	if(fexists(path))
		text2file(player,path)
		load_whitelist()
	else
		src << "<font color='red'>Error: get_whitelist(): File not found/Invalid path([path]).</font>"
	return

#undef WHITELISTFILE