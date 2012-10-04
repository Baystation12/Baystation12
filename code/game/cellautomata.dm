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
				admins[m_key] = a_lev
				diary << ("ADMIN: [m_key] = [a_lev]")

	// look for moderators in a separate file
	text = file2text("config/moderators.txt")
	if (!text)
		diary << "Failed to load config/moderators.txt\n"
	else
		var/list/lines = dd_text2list(text, "\n")
		for(var/line in lines)
			if (!line)
				continue

			if (copytext(line, 1, 2) == ";")
				continue

			var/m_key = copytext(line, 1, length(line)+1)
			var/a_lev = "Moderator"
			admins[m_key] = a_lev

/world/proc/load_testers()
	var/text = file2text("config/testers.txt")
	if (!text)
		diary << "Failed to load config/testers.txt\n"
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
				admins[m_key] = a_lev


/world/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	//config.loadsql("config/dbconfig.txt")
	//config.loadforumsql("config/forumdbconfig.txt")
	// apply some settings from config..
	abandon_allowed = config.respawn

/world/New()
	src.load_configuration()

	if (config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	src.load_mode()
	src.load_motd()
	src.load_admins()
	investigate_reset()

	if (config.usealienwhitelist)
		load_alienwhitelist()
	if (config.usewhitelist)
		load_whitelist()

	LoadBansjob()
	//Get_Holiday()	//~Carn, needs to be here when the station is named so :P
	src.update_status()
	makepowernets()

	sun = new /datum/sun()
	vote = new /datum/vote()
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

	socket_talk = new /datum/socket_talk()
	master_controller = new /datum/controller/game_controller()
	spawn(-1)
		master_controller.setup()
		lighting_controller.Initialize()
	return

//Crispy fullban
/world/Reboot(var/reason)
	spawn(0)
		send2irc(world.url,"Server Rebooting!")
		socket_talk.send_raw("type=reboot")
		//world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy

	for(var/client/C)
		if (config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")
		else
			C << link("byond://[world.address]:[world.port]")

//	sleep(10) // wait for sound to play
	..(reason)

/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/living/silicon/ai))
		return 1
	return

/atom/proc/on_reagent_change()
	return

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/movable/Bump(var/atom/A as mob|obj|turf|area, yes)
	spawn( 0 )
		if ((A && yes))
			A.last_bumped = world.time
			A.Bumped(src)
		return
	..()
	return

// **** Note in 40.93.4, split into obj/mob/turf point verbs, no area

/atom/verb/point()
	set name = "Point To"
	set category = "Object"
	set src in oview()
	var/atom/this = src//detach proc from src
	src = null

	if(!usr || !isturf(usr.loc))
		return
	if(usr.stat || usr.restrained())
		return
	if(usr.status_flags & FAKEDEATH)
		return

	var/tile = get_turf(this)
	if (!tile)
		return

	var/P = new /obj/effect/decal/point(tile)
	spawn (20)
		if(P)	del(P)

	usr.visible_message("<b>[usr]</b> points to [this]")

/obj/effect/decal/point/point()
	set src in oview()
	set hidden = 1
	return