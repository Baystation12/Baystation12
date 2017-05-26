/client
	var/donator
	var/alien_whitelist
	var/command_whitelist
	var/datejoined

/client/proc/saveclientdb()
	//Loading list of notes for this key
	var/savefile/clientdb = new("data/player_saves/[copytext(key, 1, 2)]/[key]/clientdb.sav")
	clientdb["donator"] << donator
	clientdb["alien_whitelist"] << donator
	clientdb["command_whitelist"] << donator
	return 1

/client/proc/loadclientdb()
	//Loading list of notes for this key
	var/savefile/clientdb = new("data/player_saves/[copytext(key, 1, 2)]/[key]/clientdb.sav")
	clientdb["donator"] >> donator
	clientdb["alien_whitelist"] >> alien_whitelist
	clientdb["command_whitelist"] >> command_whitelist
	clientdb["datejoined"] >> datejoined
	if(!datejoined) // No join time set, so we assume he's new.
		datejoined = world.realtime
		clientdb["datejoined"] << datejoined
	return 1

/client/verb/get_days()
	set name = "Check Days"
	usr << "Your account is [round((world.realtime - datejoined) / 864000)] days old."