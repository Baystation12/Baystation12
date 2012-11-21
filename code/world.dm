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
	src.load_admins()
	src.load_mods()
	investigate_reset()
	if (config.usewhitelist)
		load_whitelist()
	if (config.usealienwhitelist)
		load_alienwhitelist()
	LoadBansjob()
	Get_Holiday()	//~Carn, needs to be here when the station is named so :P
	src.update_status()
	makepowernets()

	sun = new /datum/sun()
	radio_controller = new /datum/controller/radio()
	data_core = new /obj/effect/datacore()
	paiController = new /datum/paiController()

	..()

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

		for(var/client/C in client_list)
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
//	spawn(0) // Yeah there we go end round sounds removed, mission accomplished
//		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy

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
	var/text = file2text("data/mode.txt")
	if (text)
		var/list/lines = dd_text2list(text, "\n")
		if (lines[1])
			master_mode = lines[1]
			diary << "Saved mode is '[master_mode]'"

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")

/world/proc/load_admins()
	if(config.admin_legacy_system)
		//Legacy admin system uses admins.txt
		var/text = file2text("config/admins.txt")
		if (!text)
			diary << "Failed to load config/admins.txt\n"
		else
			var/list/lines = dd_text2list(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/pos = findtext(line, " - ", 1, null)
				if (pos)
					var/m_key = copytext(line, 1, pos)
					var/a_lev = copytext(line, pos + 3, length(line) + 1)
					admins[m_key] = new /datum/admins(a_lev)
					diary << ("ADMIN: [m_key] = [a_lev]")
	else
		//The current admin system uses SQL
		var/user = sqlfdbklogin
		var/pass = sqlfdbkpass
		var/db = sqlfdbkdb
		var/address = sqladdress
		var/port = sqlport

		var/DBConnection/dbcon = new()

		dbcon.Connect("dbi:mysql:[db]:[address]:[port]","[user]","[pass]")
		if(!dbcon.IsConnected())
			diary << "Failed to connect to database in load_admins(). Reverting to legacy system."
			config.admin_legacy_system = 1
			load_admins()
			return

		var/DBQuery/query = dbcon.NewQuery("SELECT ckey, rank, level, flags FROM erro_admin")
		query.Execute()
		while(query.NextRow())
			var/adminckey = query.item[1]
			var/adminrank = query.item[2]
			var/adminlevel = query.item[3]
			if(istext(adminlevel))
				adminlevel = text2num(adminlevel)
			var/permissions = query.item[4]
			if(istext(permissions))
				permissions = text2num(permissions)

			//This list of stuff translates the permission defines the database uses to the permission structure that the game uses.
			var/permissions_actual = 0
			if(permissions & SQL_BUILDMODE)
				permissions_actual |= BUILDMODE
			if(permissions & SQL_ADMIN)
				permissions_actual |= ADMIN
			if(permissions & SQL_BAN)
				permissions_actual |= BAN
			if(permissions & SQL_FUN)
				permissions_actual |= FUN
			if(permissions & SQL_SERVER)
				permissions_actual |= SERVER
			if(permissions & SQL_DEBUG)
				permissions_actual |= ADMDEBUG
			if(permissions & SQL_POSSESS)
				permissions_actual |= POSSESS
			if(permissions & SQL_PERMISSIONS)
				permissions_actual |= PERMISSIONS

			if(adminrank == "Removed")
				return	//This person was de-adminned. They are only in the admin list for archive purposes.

			var/datum/admins/AD = new /datum/admins(adminrank)
			AD.level = adminlevel //Legacy support for old verbs
			AD.sql_permissions = permissions_actual
			admins[adminckey] = AD

		if(!admins)
			diary << "The database query in load_admins() resulted in no admins being added to the list. Reverting to legacy system."
			config.admin_legacy_system = 1
			load_admins()
			return

//copy paste of above - load_admins() will take care of loading mods if it's enabled
/world/proc/load_mods()
	if(config.admin_legacy_system)
		//Legacy admin system uses admins.txt
		var/text = file2text("config/moderators.txt")
		if (!text)
			diary << "Failed to load config/mods.txt\n"
		else
			var/list/lines = dd_text2list(text, "\n")
			for(var/line in lines)
				if (!line)
					continue

				if (copytext(line, 1, 2) == ";")
					continue

				var/m_key = copytext(line, 1, length(line)+1)
				admins[m_key] = new /datum/admins("Moderator")
				diary << ("MOD: [m_key]")

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
