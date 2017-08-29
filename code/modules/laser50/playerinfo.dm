/client
	var/donator //Donator status
	var/alien_whitelist //Alien whitelists
	var/command_whitelist //Head whitelists
	var/datejoined //The date the player first joined the server
	var/lastseen //The last time since we've seen the player (in days)
	var/enforcingmod //Enforcing moderator status
	var/list/iplogs = list() //List of most recent IPs
	var/list/cidlogs = list() //List of most recent computer IDs
	var/list/relatedaccounts = list() //List of (possible) related accounts

/client/proc/saveclientdb()
	//Loading list of notes for this key
	var/savefile/clientdb = new("data/player_saves/[copytext(key, 1, 2)]/[key]/clientdb.sav")
	clientdb["donator"] << donator
	clientdb["enforcingmod"] << enforcingmod
	clientdb["alien_whitelist"] << alien_whitelist
	clientdb["command_whitelist"] << command_whitelist
	return 1

/client/proc/refreshclientdb() // Refreshes the client DB with recent information.
	var/savefile/clientdb = new("data/player_saves/[copytext(key, 1, 2)]/[key]/clientdb.sav")

	clientdb["iplogs"] >> iplogs
	if(!iplogs)
		iplogs = list()
	if(!locate(address) in iplogs)
		iplogs.Add(address)
		if(iplogs.len > 10)
			iplogs.Cut(1, 2) // Remove oldest entry.
	clientdb["iplogs"] << iplogs
	sleep(0)
	clientdb["cidlogs"] >> cidlogs
	if(!cidlogs)
		cidlogs = list()
	if(!locate(computer_id) in cidlogs)
		cidlogs.Add(computer_id)
		if(cidlogs.len > 10)
			cidlogs.Cut(1, 2) // Remove oldest entry.
	clientdb["cidlogs"] << cidlogs
	lastseen = round((world.realtime - lastseen) / 864000, 0.1)
	clientdb["lastseen"] << lastseen

/client/verb/get_days()
	set name = "Check Age"
	set desc = "Checks the age of your account on the server."
	set category = "OOC"
	usr << "Your account is [get_player_age()] day(s) old."