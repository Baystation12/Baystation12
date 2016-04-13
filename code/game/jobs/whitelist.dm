#define WHITELISTFILE "data/whitelist.txt"

var/list/whitelist = list()

/hook/startup/proc/loadWhitelist()
	if(config.usewhitelist)
		load_whitelist()
	return 1

/proc/load_whitelist()
	whitelist = file2list(WHITELISTFILE)
	if(!whitelist.len)	whitelist = null

/proc/check_whitelist(mob/M /*, var/rank*/)
	if(!whitelist)
		return 0
	return ("[M.ckey]" in whitelist)

/var/list/alien_whitelist = list()

/hook/startup/proc/loadAlienWhitelist()
	if(config.usealienwhitelist)
		if(config.usealienwhitelistSQL)
			if(!load_alienwhitelistSQL())
				world.log << "Could not load alienwhitelist via SQL"
		else
			load_alienwhitelist()
	return 1
/proc/load_alienwhitelist()
	var/text = file2text("config/alienwhitelist.txt")
	if (!text)
		log_misc("Failed to load config/alienwhitelist.txt")
		return 0
	else
		alien_whitelist = splittext(text, "\n")
		return 1
/proc/load_alienwhitelistSQL()
	var/DBQuery/query = dbcon_old.NewQuery("SELECT * FROM whitelist")
	if(!query.Execute())
		world.log << dbcon_old.ErrorMsg()
		return 0
	else
		while(query.NextRow())
			var/list/row = query.GetRowData()
			if(alien_whitelist[row["ckey"]])
				var/list/A = alien_whitelist[row["ckey"]]
				A.Add(row["race"])
			else
				alien_whitelist[row["ckey"]] = list(row["race"])
	return 1


//todo: admin aliens
/proc/is_alien_whitelisted(mob/M, var/species)
	if(!M || !species)
		return 0
	if(!config.usealienwhitelist)
		return 1
	if(istype(species,/datum/species) || istype(species,/datum/language))
		species = "[species]";
	if(species == "human" || species == "Human")
		return 1
	if(check_rights(R_ADMIN, 0, M))
		return 1
	if(!alien_whitelist)
		return 0
	if(config.usealienwhitelistSQL)
		var race = lowertext(species)
		if(!(M.ckey in alien_whitelist))
			return 0;
		var/list/whitelisted = alien_whitelist[M.ckey]
		if(race in whitelisted)
			return 1
		return 0
	else
		if(M && species)
			for (var/s in alien_whitelist)
				if(findtext(s,"[M.ckey] - [species]"))
					return 1
				if(findtext(s,"[M.ckey] - All"))
					return 1
	return 0

#undef WHITELISTFILE
