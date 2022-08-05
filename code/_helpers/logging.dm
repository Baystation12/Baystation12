
// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""


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

//print a testing-mode debug message to world.log
/proc/testing(msg)
	to_world_log("## TESTING: [msg][log_end]")

/proc/game_log(category, text)
	to_file(global.diary, "\[[time_stamp()]] [game_id] [category]: [text][log_end]")

/proc/log_admin(text)
	GLOB.admin_log.Add(text)
	if (config.log_admin)
		game_log("ADMIN", text)

/proc/log_debug(text)
	if (config.log_debug)
		game_log("DEBUG", text)
	to_debug_listeners(text)

/proc/log_runtime(text)
	for (var/client/C as anything in GLOB.admins)
		if (C.get_preference_value(/datum/client_preference/staff/show_runtime_logs) == GLOB.PREF_SHOW)
			to_chat(C, append_admin_tools(SPAN_DEBUG("<b>RUNTIME</b>: [text]"), usr, usr?.loc))

/proc/log_error(text)
	error(text)
	to_debug_listeners(text, "ERROR")

/proc/log_warning(text)
	warning(text)
	to_debug_listeners(text, "WARNING")

/proc/to_debug_listeners(text, prefix = "DEBUG")
	for(var/client/C as anything in GLOB.admins)
		if(C.get_preference_value(/datum/client_preference/staff/show_debug_logs) == GLOB.PREF_SHOW)
			to_chat(C, SPAN_DEBUG("<b>[prefix]</b>: [text]"))

/proc/log_game(text)
	if (config.log_game)
		game_log("GAME", text)

/proc/log_vote(text)
	if (config.log_vote)
		game_log("VOTE", text)

/proc/log_access(text)
	if (config.log_access)
		game_log("ACCESS", text)

/proc/log_say(text)
	if (config.log_say)
		game_log("SAY", text)

/proc/log_ooc(text)
	if (config.log_ooc)
		game_log("OOC", text)

/proc/log_whisper(text)
	if (config.log_whisper)
		game_log("WHISPER", text)

/proc/log_emote(text)
	if (config.log_emote)
		game_log("EMOTE", text)

/proc/log_attack(text)
	if (config.log_attack)
		game_log("ATTACK", text)

/proc/log_adminsay(text)
	if (config.log_adminchat)
		game_log("ADMINSAY", text)

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		game_log("ADMINWARN", text)

/proc/log_misc(text)
	game_log("MISC", text)

/proc/log_unit_test(text)
	to_world_log("## UNIT_TEST ##: [text]")
	log_debug(text)

/proc/log_qdel(text)
	to_file(GLOB.world_qdel_log, "\[[time_stamp()]]QDEL: [text]")

//This replaces world.log so it displays both in DD and the file
/proc/log_world(text)
	to_world_log(text) //this comes before the config check because it can't possibly runtime
	if(config.log_world_output)
		game_log("DD_OUTPUT", text)

//pretty print a direction bitflag, can be useful for debugging.
/proc/dir_text(var/dir)
	var/list/comps = list()
	if(dir & NORTH) comps += "NORTH"
	if(dir & SOUTH) comps += "SOUTH"
	if(dir & EAST) comps += "EAST"
	if(dir & WEST) comps += "WEST"
	if(dir & UP) comps += "UP"
	if(dir & DOWN) comps += "DOWN"

	return english_list(comps, nothing_text="0", and_text="|", comma_text="|")

//more or less a logging utility
/proc/key_name(var/whom, var/include_link = null, var/include_name = 1, var/highlight_special_characters = 1, var/datum/ticket/ticket = null)
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
			. += "/(<font color='#ffa500'>[name]</font>)" //Orange
		else
			. += "/([name])"

	return .

/proc/key_name_admin(var/whom, var/include_name = 1)
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

/proc/log_info_line(var/datum/d)
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

/proc/report_progress(var/progress_message)
	admin_notice("<span class='boldannounce'>[progress_message]</span>", R_DEBUG)
	to_world_log(progress_message)
