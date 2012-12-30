/world
	mob = /mob/new_player
	turf = /turf/space
	area = /area
	view = "15x15"



#define RECOMMENDED_VERSION 494
/world/New()
	..()

	src.load_configuration()

	if (config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	src.load_mode()
	src.load_motd()
	load_admins()
	investigate_reset()
	if (config.usewhitelist)
		load_whitelist()
	LoadBansjob()
	Get_Holiday()	//~Carn, needs to be here when the station is named so :P
	src.update_status()
	makepowernets()

	sun = new /datum/sun()
	radio_controller = new /datum/controller/radio()
	data_core = new /obj/effect/datacore()
	paiController = new /datum/paiController()

	..()

	if(!setup_database_connection())
		world.log << "Your server failed to establish a connection with the feedback database."
	else
		world.log << "Feedback database connection established."

	if(!setup_old_database_connection())
		world.log << "Your server failed to establish a connection with the tgstation database."
	else
		world.log << "Tgstation database connection established."

	sleep(50)

	plmaster = new /obj/effect/overlay(  )
	plmaster.icon = 'icons/effects/tile_effects.dmi'
	plmaster.icon_state = "plasma"
	plmaster.layer = FLY_LAYER
	plmaster.mouse_opacity = 0

	slmaster = new /obj/effect/overlay(  )
	slmaster.icon = 'icons/effects/tile_effects.dmi'
	slmaster.icon_state = "sleeping_agent"
	slmaster.layer = FLY_LAYER
	slmaster.mouse_opacity = 0

	src.update_status()

	master_controller = new /datum/controller/game_controller()
	spawn(-1)
		master_controller.setup()
		lighting_controller.Initialize()

	if(byond_version < RECOMMENDED_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for TGstation code. Please update BYOND"

	diary = file("data/logs/[time2text(world.realtime, "YYYY/MM-Month/DD-Day")].log")
	diary << {"

Starting up. [time2text(world.timeofday, "hh:mm.ss")]
---------------------
"}

	diaryofmeanpeople = file("data/logs/[time2text(world.realtime, "YYYY/MM-Month/DD-Day")] Attack.log")
	diaryofmeanpeople << {"

Starting up. [time2text(world.timeofday, "hh:mm.ss")]
---------------------
"}

	href_logfile = file("data/logs/[time2text(world.realtime, "YYYY/MM-Month/DD-Day")] hrefs.html")

	jobban_loadbanfile()
	jobban_updatelegacybans()
	LoadBans()
	make_datum_references_lists()	//initialises global lists for referencing frequently used datums (so that we only ever do it once)
	process_teleport_locs()			//Sets up the wizard teleport locations
	process_ghost_teleport_locs()	//Sets up ghost teleport locations.
	sleep_offline = 1

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()
		if(config.kick_inactive)
			KickInactiveClients()

#undef RECOMMENDED_VERSION

	return

//world/Topic(href, href_list[])
//		world << "Received a Topic() call!"
//		world << "[href]"
//		for(var/a in href_list)
//			world << "[a]"
//		if(href_list["hello"])
//			world << "Hello world!"
//			return "Hello world!"
//		world << "End of Topic() call."
//		..()

/world/Topic(T, addr, master, key)
	diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key]"

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (T == "status")
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config ? abandon_allowed : 0
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["players"] = list()
		var/n = 0
		var/admins = 0

		for(var/client/C in clients)
			if(C.holder)
				if(C.holder.fakekey)
					continue	//so stealthmins aren't revealed by the hub
				admins++
			s["player[n]"] = C.key
			n++
		s["players"] = n

		if(revdata)	s["revision"] = revdata.revision
		s["admins"] = admins

		return list2params(s)


/world/Reboot(var/reason)
	spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy

	for(var/client/C)
		if (config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")
		else
			C << link("byond://[world.address]:[world.port]")

	..(reason)


#define INACTIVITY_KICK	6000	//10 minutes in ticks (approx.)
/world/proc/KickInactiveClients()
	for(var/client/C)
		if( !C.holder && (C.inactivity >= INACTIVITY_KICK) )
			if(C.mob)
				if(!istype(C.mob, /mob/dead/))
					log_access("AFK: [key_name(C)]")
					C << "\red You have been inactive for more than 10 minutes and have been disconnected."
			del(C)
	spawn(3000) KickInactiveClients()//more or less five minutes
#undef INACTIVITY_KICK


/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			diary << "Saved mode is '[master_mode]'"

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")

/world/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.loadsql("config/dbconfig.txt")
	config.loadforumsql("config/forumdbconfig.txt")
	// apply some settings from config..
	abandon_allowed = config.respawn


/world/proc/update_status()
	var/s = ""

	if (config && config.server_name)
		s += "<b>[config.server_name]</b> &#8212; "

	s += "<b>[station_name()]</b>";
	s += " ("
	s += "<a href=\"http://\">" //Change this to wherever you want the hub to link to.
//	s += "[game_version]"
	s += "Default"  //Replace this with something else. Or ever better, delete it and uncomment the game version.
	s += "</a>"
	s += ")"

	var/list/features = list()

	if (!ticker)
		features += "<b>STARTING</b>"

	if (ticker && master_mode)
		features += master_mode

	if (!enter_allowed)
		features += "closed"

	if (abandon_allowed)
		features += abandon_allowed ? "respawn" : "no respawn"

	if (config && config.allow_vote_mode)
		features += "vote"

	if (config && config.allow_ai)
		features += "AI allowed"

	var/n = 0
	for (var/mob/M in player_list)
		if (M.client)
			n++

	if (n > 1)
		features += "~[n] players"
	else if (n > 0)
		features += "~[n] player"

	/*
	is there a reason for this? the byond site shows 'hosted by X' when there is a proper host already.
	if (host)
		features += "hosted by <b>[host]</b>"
	*/

	if (!host && config && config.hostedby)
		features += "hosted by <b>[config.hostedby]</b>"

	if (features)
		s += ": [dd_list2text(features, ", ")]"

	/* does this help? I do not know */
	if (src.status != s)
		src.status = s

#define FAILED_DB_CONNECTION_CUTOFF 5
var/failed_db_connections = 0
var/failed_old_db_connections = 0

proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon)
		dbcon = new()

	var/user = sqlfdbklogin
	var/pass = sqlfdbkpass
	var/db = sqlfdbkdb
	var/address = sqladdress
	var/port = sqlport

	dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon.IsConnected()
	if ( . )
		failed_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_db_connections++		//If it failed, increase the failed connections counter.

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_db_connection()
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1




//These two procs are for the old database, while it's being phased out. See the tgstation.sql file in the SQL folder for more information.
proc/setup_old_database_connection()

	if(failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0

	if(!dbcon_old)
		dbcon_old = new()

	var/user = sqllogin
	var/pass = sqlpass
	var/db = sqldb
	var/address = sqladdress
	var/port = sqlport

	dbcon_old.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
	. = dbcon_old.IsConnected()
	if ( . )
		failed_old_db_connections = 0	//If this connection succeeded, reset the failed connections counter.
	else
		failed_old_db_connections++		//If it failed, increase the failed connections counter.

	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
proc/establish_old_db_connection()
	if(failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon_old || !dbcon_old.IsConnected())
		return setup_old_database_connection()
	else
		return 1

#undef FAILED_DB_CONNECTION_CUTOFF