
// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end = world.system_type == UNIX ? ascii2text(13) : ""
GLOBAL_PROTECT(log_end)
GLOBAL_VAR_INIT(log_end, (ascii2text(13))) // CRLF for all logs


#define DIRECT_OUTPUT(A, B) A << B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)

/proc/start_log(log)
	rustg_log_write(log, "Starting up. Round ID is [game_id ? game_id : "NULL"]\n-------------------------[GLOB.log_end]")

/proc/error(msg)
	to_world_log("## ERROR: [msg][log_end]")

/proc/log_ss(subsystem, text, log_world = TRUE)
	if (!subsystem)
		subsystem = "UNKNOWN"
	var/msg = "[subsystem]: [text]"
	game_log("SS", msg)
	if (log_world)
		to_world_log("SS[subsystem]: [text]")

/proc/log_ss_init(text)
	game_log("SS", "[text]")

#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	to_world_log("## WARNING: [msg][log_end]")
	rustg_log_write(GLOB.world_game_log, "## WARNING: [html_decode(msg)][GLOB.log_end]")

//print a testing-mode debug message to world.log
/proc/testing(msg)
	to_world_log("## TESTING: [msg][log_end]")
	rustg_log_write(GLOB.world_game_log, "## TESTING: [html_decode(msg)][GLOB.log_end]")


/proc/game_log(category, text)
	rustg_log_write(GLOB.world_game_log, "[category]: [text][GLOB.log_end]")

/proc/log_game(text)
	if(config.log_game)
		rustg_log_write(GLOB.world_game_log, "GAME: [text][GLOB.log_end]")

/proc/log_admin(text)
	GLOB.admin_log.Add(text)
	if (config.log_admin)
		rustg_log_write(GLOB.world_game_log, "ADMIN: [text][GLOB.log_end]")

/proc/log_debug(text)
	if (config.log_debug)
		rustg_log_write(GLOB.world_game_log, "DEBUG: [text][GLOB.log_end]")
	to_debug_listeners(text)

/proc/log_error(text)
	error(text)
	to_debug_listeners(text, "ERROR")

/proc/log_warning(text)
	warning(text)
	to_debug_listeners(text, "WARNING")

/proc/log_sql(text)
	if (global.sqlenabled)
		diary <<"\[[time_stamp()]] [game_id] SQL: [text][log_end]"

/proc/to_debug_listeners(text, prefix = "DEBUG")
	for(var/client/C as anything in GLOB.admins)
		if(C.get_preference_value(/datum/client_preference/staff/show_debug_logs) == GLOB.PREF_SHOW)
			to_chat(C, SPAN_DEBUG("<b>[prefix]</b>: [text]"))

/proc/log_vote(text)
	if (config.log_vote)
		rustg_log_write(GLOB.world_game_log, "VOTE: [text][GLOB.log_end]")

/proc/log_runtime(text)
	for (var/client/C as anything in GLOB.admins)
		if (C.get_preference_value(/datum/client_preference/staff/show_runtime_logs) == GLOB.PREF_SHOW)
			to_chat(C, append_admin_tools(SPAN_DEBUG("<b>RUNTIME</b>: [text]"), usr, usr?.loc))

/proc/log_access_in(client/new_client)
	if(config.log_access)
		var/message = "[key_name(new_client)] - IP:[new_client.address] - CID:[new_client.computer_id] - BYOND v[new_client.byond_version]"
		rustg_log_write(GLOB.world_game_log, "ACCESS IN: [message][GLOB.log_end]")

/proc/log_access_out(mob/last_mob)
	if(config.log_access)
		var/message = "[key_name(last_mob)] - IP:[last_mob.lastKnownIP] - CID:[last_mob.computer_id] - BYOND Logged Out"
		rustg_log_write(GLOB.world_game_log, "ACCESS OUT: [message][GLOB.log_end]")

/proc/log_say(text, mob/speaker)
	if(config.log_say)
		rustg_log_write(GLOB.world_game_log, "SAY: [speaker.simple_info_line()]: [html_decode(text)][GLOB.log_end]")

/proc/log_ghostsay(text, mob/speaker)
	if(config.log_say)
		rustg_log_write(GLOB.world_game_log, "DEADCHAT: [speaker.simple_info_line()]: [html_decode(text)][GLOB.log_end]")

/proc/log_ooc(text, client/user)
	if(config.log_ooc)
		rustg_log_write(GLOB.world_game_log, "OOC: [user.simple_info_line()]: [html_decode(text)][GLOB.log_end]")

/proc/log_looc(text, client/user)
	if(config.log_ooc)
		rustg_log_write(GLOB.world_game_log, "LOOC: [user.simple_info_line()]: [html_decode(text)][GLOB.log_end]")

/proc/log_whisper(text, mob/speaker)
	if(config.log_whisper)
		rustg_log_write(GLOB.world_game_log, "WHISPER: [speaker.simple_info_line()]: [html_decode(text)][GLOB.log_end]")

/proc/log_emote(text, mob/speaker)
	if (config.log_emote)
		rustg_log_write(GLOB.world_game_log, "EMOTE: [speaker.simple_info_line()]: [html_decode(text)][GLOB.log_end]")

/proc/log_attack(var/mob/attacker, var/mob/defender, message)
	if (config.log_attack)
		rustg_log_write(GLOB.world_game_log, "ATTACK: [attacker.simple_info_line()] against [defender.simple_info_line()]: [message][GLOB.log_end]") //Seperate attack logs? Why?

/proc/log_adminsay(text, mob/speaker)
	if(config.log_adminchat)
		rustg_log_write(GLOB.world_game_log, "ADMINSAY: [speaker.simple_info_line()]: [html_decode(text)][GLOB.log_end]")

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		rustg_log_write(GLOB.world_game_log, "ADMINWARN: [html_decode(text)][GLOB.log_end]")

/proc/log_permissions(text)
	rustg_log_write(GLOB.world_game_log,"PERMISSIONS: [html_decode(text)][GLOB.log_end]")

/proc/log_fax(text)
	rustg_log_write(GLOB.world_game_log, "FAX: [html_decode(text)][GLOB.log_end]")

/proc/log_misc(text)
	rustg_log_write(GLOB.world_game_log, "MISC: [text][GLOB.log_end]")

/proc/log_asset(text)
	rustg_log_write(GLOB.world_game_log, "ASSETS: [text][GLOB.log_end]")

/proc/log_unit_test(text)
	to_world_log("## UNIT_TEST ##: [text]")
	log_debug(text)

/proc/log_qdel(text)
	to_file(GLOB.world_qdel_log, "\[[time_stamp()]]QDEL: [text]")

/proc/log_world(var/text)
	to_world_log(text)
	if (config && config.log_world_output)
		rustg_log_write(GLOB.world_game_log, "WORLD: [html_decode(text)][GLOB.log_end]")

//pretty print a direction bitflag, can be useful for debugging.
/proc/dir_text(dir)
	var/list/comps = list()
	if(dir & NORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")

//more or less a logging utility
/proc/key_name(whom, include_link = null, include_name = 1, highlight_special_characters = 1, datum/ticket/ticket = null)
	var/mob/M
	var/client/C
	var/key

	if(!whom)	return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
	else if(ismob(whom))
		M = whom
		C = M.client
		key = LAST_KEY(M)
	else if(istype(whom, /datum/mind))
		var/datum/mind/D = whom
		key = D.key
		M = D.current
		if(D.current)
			C = D.current.client
	else if(istype(whom, /datum))
		var/datum/D = whom
		return "*invalid:[D.type]*"
	else
		return "*invalid*"

	. = ""

	if(key)
		if(include_link && C)
			. += "<a href='?priv_msg=\ref[C];ticket=\ref[ticket]'>"

		. += key

		if(include_link)
			if(C)	. += "</a>"
			else	. += " (DC)"
	else
		. += "*no key*"

	if(include_name && M)
		var/name

		if(M.real_name)
			name = M.real_name
		else if(M.name)
			name = M.name


		if(is_special_character(M) && highlight_special_characters)
			. += "/([SPAN_COLOR("#ffa500", name)])" //Orange
		else
			. += "/([name])"

	return .

/proc/key_name_admin(whom, include_name = 1)
	return key_name(whom, 1, include_name)

// Helper procs for building detailed log lines
/datum/proc/get_log_info_line()
	return "[src] ([type]) ([any2ref(src)])"

/area/get_log_info_line()
	return "[..()] ([isnum(z) ? "[x],[y],[z]" : "0,0,0"])"

/turf/get_log_info_line()
	return "[..()] ([x],[y],[z]) ([loc ? loc.type : "NULL"])"

/atom/movable/get_log_info_line()
	var/turf/t = get_turf(src)
	return "[..()] ([t ? t : "NULL"]) ([t ? "[t.x],[t.y],[t.z]" : "0,0,0"]) ([t ? t.type : "NULL"])"

/mob/get_log_info_line()
	return ckey ? "[..()] ([ckey])" : ..()

/proc/log_info_line(datum/d)
	if(isnull(d))
		return "*null*"
	if(islist(d))
		var/list/L = list()
		for(var/e in d)
			// Indexing on numbers just gives us the same number again in the best case and causes an index out of bounds runtime in the worst
			var/v = isnum(e) ? null : d[e]
			L += "[log_info_line(e)][v ? " - [log_info_line(v)]" : ""]"
		return "\[[jointext(L, ", ")]\]" // We format the string ourselves, rather than use json_encode(), because it becomes difficult to read recursively escaped "
	if(!istype(d))
		return json_encode(d)
	return d.get_log_info_line()

/proc/report_progress(progress_message)
	admin_notice(SPAN_CLASS("boldannounce", "[progress_message]"), R_DEBUG)
	to_world_log(progress_message)
	log_world(progress_message)

/mob/proc/simple_info_line()
	return "[key_name(src)] ([x],[y],[z])"

/client/proc/simple_info_line()
	return "[key_name(src)] ([mob.x],[mob.y],[mob.z])"
