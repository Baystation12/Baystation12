#define RECOMMENDED_VERSION 514
#define FAILED_DB_CONNECTION_CUTOFF 5
#define THROTTLE_MAX_BURST 15 SECONDS
#define SET_THROTTLE(TIME, REASON) throttle[1] = base_throttle + (TIME); throttle[2] = (REASON);


var/global/server_name = "Baystation 12"
var/global/game_id = null

GLOBAL_VAR(href_logfile)

/hook/global_init/proc/generate_gameid()
	if(game_id != null)
		return
	game_id = ""

	var/list/c = list("a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	var/l = c.len

	var/t = world.timeofday
	for(var/_ = 1 to 4)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)
	game_id = "-[game_id]"
	t = round(world.realtime / (10 * 60 * 60 * 24))
	for(var/_ = 1 to 3)
		game_id = "[c[(t % l) + 1]][game_id]"
		t = round(t / l)
	return 1

// Find mobs matching a given string
//
// search_string: the string to search for, in params format; for example, "some_key;mob_name"
// restrict_type: A mob type to restrict the search to, or null to not restrict
//
// Partial matches will be found, but exact matches will be preferred by the search
//
// Returns: A possibly-empty list of the strongest matches
/proc/text_find_mobs(search_string, restrict_type = null)
	var/list/search = params2list(search_string)
	var/list/ckeysearch = list()
	for(var/text in search)
		ckeysearch += ckey(text)

	var/list/match = list()

	for(var/mob/M in SSmobs.mob_list)
		if(restrict_type && !istype(M, restrict_type))
			continue
		var/strings = list(M.name, M.ckey)
		if(M.mind)
			strings += M.mind.assigned_role
			strings += M.mind.special_role
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.species)
				strings += H.species.name
		for(var/text in strings)
			if(ckey(text) in ckeysearch)
				match[M] += 10 // an exact match is far better than a partial one
			else
				for(var/searchstr in search)
					if(findtext(text, searchstr))
						match[M] += 1

	var/maxstrength = 0
	for(var/mob/M in match)
		maxstrength = max(match[M], maxstrength)
	for(var/mob/M in match)
		if(match[M] < maxstrength)
			match -= M

	return match


/proc/stack_trace(msg)
	CRASH(msg)


/proc/enable_debugging(mode, port)
	CRASH("auxtools not loaded")


/proc/auxtools_expr_stub()
	return


#ifndef UNIT_TEST
/hook/startup/proc/set_visibility()
	world.update_hub_visibility(config.hub_visible)
#endif

/world/New()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_init")()
		enable_debugging()

	name = "[server_name] - [GLOB.using_map.full_name]"

	//logs
	SetupLogs()
	var/date_string = time2text(world.realtime, "YYYY/MM/DD")
	to_file(global.diary, "[log_end]\n[log_end]\nStarting up. (ID: [game_id]) [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]")

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		config.server_name += " #[(world.port % 1000) / 100]"

	if(config && config.log_runtime)
		var/runtime_log = file("data/logs/runtime/[date_string]_[time2text(world.timeofday, "hh:mm")]_[game_id].log")
		to_file(runtime_log, "Game [game_id] starting up at [time2text(world.timeofday, "hh:mm.ss")]")
		log = runtime_log // Note that, as you can see, this is misnamed: this simply moves world.log into the runtime log file.

	if (config && config.log_hrefs)
		GLOB.href_logfile = file("data/logs/[date_string] hrefs.htm")

	if(byond_version < RECOMMENDED_VERSION)
		to_world_log("Your server's byond version does not meet the recommended requirements for this server. Please update BYOND")

	callHook("startup")
	..()

#ifdef UNIT_TEST
	log_unit_test("Unit Tests Enabled. This will destroy the world when testing is complete.")
	load_unit_test_changes()
#endif
	Master.Initialize(10, FALSE)


/world/Del()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_shutdown")()
	callHook("shutdown")
	return ..()


GLOBAL_LIST_EMPTY(world_topic_throttle)
GLOBAL_VAR_INIT(world_topic_last, world.timeofday)


/world/Topic(topic, remoteAddress, fromParent, list/remoteKeys)
	if (!config["warden"]) // Warden will provide caching for relevant calls
		if (GLOB.world_topic_last > world.timeofday)
			GLOB.world_topic_throttle = list() //probably passed midnight
		GLOB.world_topic_last = world.timeofday
		var/list/throttle = GLOB.world_topic_throttle[addr]
		if (!throttle)
			GLOB.world_topic_throttle[addr] = throttle = list(0, null)
		else if (throttle[1] && throttle[1] > world.timeofday + THROTTLE_MAX_BURST)
			return throttle[2] ? {"\{"error": "throttled","reason":"[throttle[2]"\}"}
		var/base_throttle = max(throttle[1], world.timeofday)
		SET_THROTTLE(3 SECONDS, null)

	// The minimum length of a potentially valid topic is {"action":"x"}
	var/payloadSize = length_char(topic)
	if (payloadSize < 14 || topic[1] != "{" || topic[-1] != "}")
		return {"\{"error": "bad payload"\}"}
	var/list/payload = json_decode(topic)

	var/static/list/topic_actions
	if (!topic_actions)
		topic_actions = list()
		var/list/topic_action_instances = decls_repository.get_decls_of_subtype(/decl/topic_action)
		for (var/decl/topic_action/action_path as anything in topic_action_instances)
			var/decl/topic_action/action = topic_action_instances[action_path]
			topic_actions[action.action] = action

	var/decl/topic_action/action = topic_actions[payload["action"]]
	if (!action)
		return {"\{"error": "bad action"\}"}
	var/problem = action.validate(payload)
	if (problem)
		return problem
	return action.handler(payload)


/decl/topic_action
	abstract_type = /decl/topic_action
	var/action
	var/list/params


/decl/topic_action/proc/validate(list/payload)
	for (var/param in params)
		var/list/rules = params[param]
		var/value = payload[param]
		var/len = length_char(value)
		if (rules["min"] && len < rules["min"])
			return {"\{\}"}
		if (rules["max"] && len > rules["max"])
			return {"\{\}"}


/decl/topic_action/proc/handler(list/payload)
	return {"\{"error": "unimplemented"\}"}


/decl/topic_action/status
	action = "status"


/decl/topic_action/status/validate(list/payload)
	return


/decl/topic_action/status/handler(list/payload)
	// Respond with the server's current round state, including a player list and manifest
	return {"\{\}"}


/decl/topic_action/profile
	action = "profile"

	params = list(
		"ckey" = list("min" = 3, "max" = 31),
		"anonymous" = list()
	)


/decl/topic_action/profile/handler(list/payload)
	// Respond with a user's byond details, server details, and notes, optionally anonymized
	return {"\{\}"}


/decl/topic_action/message
	action = "message"
	params = list(
		"ckey" = list("min" = 3, "max" = 31),
		"origin" = list("min" = 3, "max" = 31),
		"message" = list("min" = 1, "max" = 256)
	)


/decl/topic_action/message/handler(list/payload)
	// Send message to ckey from origin, providing a response link
	return {"\{\}"}


/decl/topic_action/kick
	action = "kick"
	params = list(
		"ckey" = list("min" = 3, "max" = 31),
		"reason" = list("max" = 256)
	)


/decl/topic_action/kick/handler(list/payload)
	// Kick a user with an optional reason
	return {"\{\}"}


/decl/topic_action/gameban
	action = "gameban"
	params = list(
		"ckey" = list("min" = 3, "max" = 31),
		"reason" = list("max" = 256)
	)


/decl/topic_action/gameban/handler(list/payload)
	// Server ban a user with an optional reason and duration
	return {"\{\}"}


/decl/topic_action/roleban
	action = "roleban"
	params = list(
		"ckey" = list("min" = 3, "max" = 31),
		"role" = list("min" = 2, "max" = 32),
		"reason" = list("max" = 256)
	)


/decl/topic_action/roleban/handler(list/payload)
	// Role ban a user with an optional reason and duration
	return {"\{\}"}


/world/Reboot(reason)
	/*spawn(0)
		sound_to(world, sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')))// random end sounds!! - LastyBatsy

		*/

	Master.Shutdown()

	var/datum/chatOutput/co
	for(var/client/C in GLOB.clients)
		co = C.chatOutput
		if(co)
			co.ehjax_send(data = "roundrestart")
	if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
		for(var/client/C in GLOB.clients)
			send_link(C, "byond://[config.server]")

	if(config.wait_for_sigusr1_reboot && reason != 3)
		text2file("foo", "reboot_called")
		to_world("<span class=danger>World reboot waiting for external scripts. Please be patient.</span>")
		return

	..(reason)


/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	if(!fexists("data/mode.txt"))
		return

	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			SSticker.master_mode = Lines[1]
			log_misc("Saved mode is '[SSticker.master_mode]'")

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	to_file(F, the_mode)


/world/proc/update_status()
	if (!config?.hub_visible || !config.hub_entry)
		return
	status = config.generate_hub_entry()


/world/proc/SetupLogs()
	GLOB.log_directory = "data/logs/[time2text(world.realtime, "YYYY/MM/DD")]/round-"
	if(game_id)
		GLOB.log_directory += "[game_id]"
	else
		GLOB.log_directory += "[replacetext(time_stamp(), ":", ".")]"

	GLOB.world_qdel_log = file("[GLOB.log_directory]/qdel.log")
	to_file(GLOB.world_qdel_log, "\n\nStarting up round ID [game_id]. [time_stamp()]\n---------------------")


var/global/failed_db_connections = 0
var/global/failed_old_db_connections = 0

/hook/startup/proc/connectDB()
	if(!setup_database_connection())
		to_world_log("Your server failed to establish a connection with the feedback database.")
	else
		to_world_log("Feedback database connection established.")
	return 1

/proc/setup_database_connection()
	if (!sqlenabled)
		return 0
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
		to_world_log(dbcon.ErrorMsg())
	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_db_connection()
	if (!sqlenabled)
		return 0
	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0
	if(!dbcon || !dbcon.IsConnected())
		return setup_database_connection()
	else
		return 1


/hook/startup/proc/connectOldDB()
	if(!setup_old_database_connection())
		to_world_log("Your server failed to establish a connection with the SQL database.")
	else
		to_world_log("SQL database connection established.")
	return 1

//These two procs are for the old database, while it's being phased out. See the tgstation.sql file in the SQL folder for more information.
/proc/setup_old_database_connection()
	if (!sqlenabled)
		return 0
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
		to_world_log(dbcon.ErrorMsg())
	return .

//This proc ensures that the connection to the feedback database (global variable dbcon) is established
/proc/establish_old_db_connection()
	if (!sqlenabled)
		return 0
	if(failed_old_db_connections > FAILED_DB_CONNECTION_CUTOFF)
		return 0

	if(!dbcon_old || !dbcon_old.IsConnected())
		return setup_old_database_connection()
	else
		return 1

#undef RECOMMENDED_VERSION
#undef FAILED_DB_CONNECTION_CUTOFF
#undef THROTTLE_MAX_BURST
#undef SET_THROTTLE
