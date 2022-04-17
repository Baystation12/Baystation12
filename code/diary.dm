/* == Logging ==
* Two general varieties of logging macro exist - log and trace.
* Trace automatically includes the file path and line in the message.
*
* logging macros are all used like THE_MACRO("text", source?, user?).
* For example:
*   LOG_CRITICAL("Starting the server!") => "15-48-54z Critical # Starting the server!"
*   TRACE_DEBUG("User found!", user=someguy) => "15-48-54z Debug (usr:Some Guy) # code/myfile.dmL13 User found!"
*
* UPPER_CASE logs directly to the DAY log.
*   LOG_CRITICAL, TRACE_CRITICAL -- For Startup, Shutdown, and intentional Crash events.
*   LOG_ERROR, TRACE_ERROR -- For when something is wrong and has broken.
*   LOG_WARNING, TRACE_WARNING -- For when something was wrong but fixable.
*   LOG_DEBUG, TRACE_DEBUG -- For development and soft bug hunting.
*   LOG_GAME, TRACE_GAME -- The game log, as seen in the client log panel.
*   LOG_TEST, TRACE_TEST -- Only enabled during unit testing.
*
* Some lower_case logs to the DAY log and also to connected, opted-in users.
*   log_critical, trace_critical
*   log_error, trace_error
*   log_warning, trace_warning
*   log_debug, trace_debug
*
* Other lower_case logs ONLY to the ROUND log.
*   log_game -- catch-all for writing to the round log.
*
* And yet other lower_case logs to the ROUND log and also to connected, opted-in users.
*   log_admin -- log_game with "Admin: " prefix.
*   log_attack -- log_game with "Attack: " prefix.
*   log_ooc -- log_game with "OOC: " prefix.
*   log_looc -- log_game with "LOOC: " prefix.
*   loc_aooc -- log_game with "AOOC: " prefix.
*/


/* == Setting A Log Level ==
* Pick ONE (or no) __LOG_LEVEL_* below to compile with.
* This sets the limit for what will be written to the day log.
* Each level INCLUDES the levels above it.
* __LOG_LEVEL_WARNING is recommended for live use.
*/
//#define __LOG_LEVEL_CRITICAL
//#define __LOG_LEVEL_ERROR
//#define __LOG_LEVEL_WARNING
//#define __LOG_LEVEL_DEBUG
#define __LOG_LEVEL_WARNING


// == Configuration Above, Dragons Below ==


#if defined(__LOG_LEVEL_GAME)

var/global/const/__LOG_LEVEL = "game"
#define __LOG_LEVEL_DEBUG
#define __LOG_LEVEL_WARNING
#define __LOG_LEVEL_ERROR
#define __LOG_LEVEL_CRITICAL

#elif defined(__LOG_LEVEL_DEBUG)

var/global/const/__LOG_LEVEL = "debug"
#define __LOG_LEVEL_WARNING
#define __LOG_LEVEL_ERROR
#define __LOG_LEVEL_CRITICAL

#elif defined(__LOG_LEVEL_WARNING)

var/global/const/__LOG_LEVEL = "warning"
#define __LOG_LEVEL_ERROR
#define __LOG_LEVEL_CRITICAL

#elif defined(__LOG_LEVEL_ERROR)

var/global/const/__LOG_LEVEL = "error"
#define __LOG_LEVEL_CRITICAL

#elif defined(__LOG_LEVEL_CRITICAL)

var/global/const/__LOG_LEVEL = "critical"

#else

var/global/const/__LOG_LEVEL = "silent"

#endif


#if defined(__LOG_LEVEL_CRITICAL)

/proc/__log_day(level, text, source, user)
	if (!text)
		return
	var/static/file
	if (!file)
		file = file("data/log2/[time2text(boot_time, "YYYY/MM/DD", -world.timezone)].txt")
		if (config.log_uncaught_runtimes)
			world.log = file
		if (fexists(file))
			to_target(file, "\n\n")
	var/ident
	if (source)
		if (user)
			ident = "(src:[source], usr:[user]) "
		else
			ident = "(src:[source]) "
	else if (user)
		ident = "(usr:[user]) "
	to_target(file, "[time2text(world.timeofday, "hh-mm-ss", -world.timezone)]z [level] [ident]# [text]")

/proc/__trace_day(level, file, line, text, source, user)
	__log_day(level, "[file]L[line] [text]", source, user)

#define LOG_CRITICAL(TEXT_SOURCE_USER...) __log_day("Critical", TEXT_SOURCE_USER)

#define TRACE_CRITICAL(TEXT_SOURCE_USER...) __trace_day("Critical", __FILE__, __LINE__, TEXT_SOURCE_USER)

#else

#define LOG_CRITICAL(UNUSED...)

#define TRACE_CRITICAL(UNUSED...)

#endif


#if defined(__LOG_LEVEL_ERROR)

#define LOG_ERROR(TEXT_SOURCE_USER...) __log_day("Error", TEXT_SOURCE_USER)

#define TRACE_ERROR(TEXT_SOURCE_USER...) __trace_day("Error", __FILE__, __LINE__, TEXT_SOURCE_USER)

#else

#define LOG_ERROR(UNUSED...)

#define TRACE_ERROR(UNUSED...)

#endif


#if defined(__LOG_LEVEL_WARNING)

#define LOG_WARNING(TEXT_SOURCE_USER...) __log_day("Warning", TEXT_SOURCE_USER)

#define TRACE_WARNING(TEXT_SOURCE_USER...) __trace_day("Warning", __FILE__, __LINE__, TEXT_SOURCE_USER)

#else

#define LOG_WARNING(UNUSED...)

#define TRACE_WARNING(UNUSED...)

#endif


#if defined(__LOG_LEVEL_DEBUG)

#define LOG_DEBUG(TEXT_SOURCE_USER...) __log_day("Debug", TEXT_SOURCE_USER)

#define TRACE_DEBUG(TEXT_SOURCE_USER...) __trace_day("Debug", __FILE__, __LINE__, TEXT_SOURCE_USER)

#else

#define LOG_DEBUG(UNUSED...)

#define TRACE_DEBUG(UNUSED...)

#endif


#if defined(__LOG_LEVEL_GAME)

#define LOG_GAME(TEXT_SOURCE_USER...) __log_day("Game", TEXT_SOURCE_USER)

#define TRACE_GAME(TEXT_SOURCE_USER...) __trace_day("Game", __FILE__, __LINE__, TEXT_SOURCE_USER)

#else

#define LOG_GAME(UNUSED...)

#define TRACE_GAME(UNUSED...)

#endif


#if defined(UNIT_TEST)

#define LOG_UNIT_TEST(TEXT_SOURCE_USER...) __log_day("Unit Test", TEXT_SOURCE_USER)

#define TRACE_UNIT_TEST(TEXT_SOURCE_USER...) __trace_day("Unit Test", __FILE__, __LINE__, TEXT_SOURCE_USER)

#else

#define LOG_UNIT_TEST(UNUSED...)

#define TRACE_UNIT_TEST(UNUSED...)

#endif


/proc/__log_round(text)
	var/static/file
	if (!file)
		file = file("data/log2/[time2text(boot_time, "YYYY/MM/DD/hh-mm [game_id]", -world.timezone)].txt")
	if (!text)
		return
	to_target(file, "[CURRENT_STATION_TIME] # [text]")


/proc/__log_notify(preference, text, atom/atom, mob/mob)
	if (atom || mob)
		var/list/build = list("(")
		if (atom)
			build += "<a href=\"?_src_=holder;admin_goto=1;X=[atom.x];Y=[atom.y];Z=[atom.z]\">LOC</a>"
		if (mob)
			if (atom)
				build += "|"
			build += "<a href=\"?_src_=holder;admin_follow=\ref[mob]\">MOB</a>"
		build += ")"
		text = "[jointext(build, null)] [text]"
	for (var/client/client as anything in GLOB.admins)
		if (client.get_preference_value(preference) != GLOB.PREF_SHOW)
			continue
		to_chat(client, text)


/proc/__log_critical(text, source, user)
	LOG_CRITICAL(text, source, user)
	__log_notify(
		/datum/client_preference/staff/show_log_critical,
		SPAN_LOG_CRITICAL("Critical: [text]"),
		source,
		user
	)

/proc/__trace_critical(file, line, text, source, user)
	__log_critical("[file]L[line] [text]", source, user)

#define log_critical(TEXT_SOURCE_USER...) __log_critical(TEXT_SOURCE_USER)

#define trace_critical(TEXT_SOURCE_USER...) __trace_critical(__FILE__, __LINE__, TEXT_SOURCE_USER)


/proc/__log_error(text, source, user)
	LOG_ERROR(text, source, user)
	__log_notify(
		/datum/client_preference/staff/show_log_error,
		SPAN_LOG_ERROR("Error: [text]"),
		source,
		user
	)

/proc/__trace_error(file, line, text, source, user)
	__log_error("[file]L[line] [text]", source, user)

#define log_error(TEXT_SOURCE_USER...) __log_error(TEXT_SOURCE_USER)

#define trace_error(TEXT_SOURCE_USER...) __trace_error(__FILE__, __LINE__, TEXT_SOURCE_USER)


/proc/__log_warning(text, source, user)
	LOG_WARNING(text, source, user)
	__log_notify(
		/datum/client_preference/staff/show_log_warning,
		SPAN_LOG_WARNING("Warning: [text]"),
		source,
		user
	)

/proc/__trace_warning(file, line, text, source, user)
	__log_warning("[file]L[line] [text]", source, user)

#define log_warning(TEXT_SOURCE_USER...) __log_warning(TEXT_SOURCE_USER)

#define trace_warning(TEXT_SOURCE_USER...) __trace_warning(__FILE__, __LINE__, TEXT_SOURCE_USER)


/proc/__log_debug(text, source, user)
	LOG_DEBUG(text, source, user)
	__log_notify(
		/datum/client_preference/staff/show_log_debug,
		SPAN_LOG_DEBUG("Debug: [text]"),
		source,
		user
	)

/proc/__trace_debug(file, line, text, source, user)
	__log_debug("[file]L[line] [text]", source, user)

#define log_debug(TEXT_SOURCE_USER...) __log_debug(TEXT_SOURCE_USER)

#define trace_debug(TEXT_SOURCE_USER...) __trace_debug(__FILE__, __LINE__, TEXT_SOURCE_USER)


/proc/log_game(text, preference, atom, mob)
	LOG_GAME(text, atom, mob)
	__log_round(text)
	if (!preference)
		return
	__log_notify(preference, text, atom, mob)

#define log_admin(TEXT, TURF_MOB...) log_game("Admin: [(TEXT)]", /datum/client_preference/staff/show_log_admin, TURF_MOB)

#define log_attack(TEXT, TURF_MOB...) log_game("Attack: [(TEXT)]", /datum/client_preference/staff/show_log_attack, TURF_MOB)

/proc/log_say(text)
	log_game("Say: [(text)]")

/proc/log_whisper(text)
	log_game("Whisper: [(text)]")

/proc/log_emote(text)
	log_game("Emote: [(text)]")

/proc/log_ooc(text)
	log_game("OOC: [(text)]")

/proc/log_aooc(text)
	log_game("AOOC: [(text)]")


var/global/game_id = copytext(rgb(rand(0, 255), rand(0, 255), rand(0, 255), rand(0, 255)), 2)


#if defined(__LOG_LEVEL_GAME)
#undef __LOG_LEVEL_GAME
#endif

#if defined(__LOG_LEVEL_DEBUG)
#undef __LOG_LEVEL_DEBUG
#endif

#if defined(__LOG_LEVEL_WARNING)
#undef __LOG_LEVEL_WARNING
#endif

#if defined(__LOG_LEVEL_ERROR)
#undef __LOG_LEVEL_ERROR
#endif

#if defined(__LOG_LEVEL_CRITICAL)
#undef __LOG_LEVEL_CRITICAL
#endif
