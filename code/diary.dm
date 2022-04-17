/**
* __log_file_day is written to according to logging level to data/logs/yyyy/mm/dd.txt in UTC at boot time
* __log_file_round writes only game logs to data/logs/yyyy/mm/dd/hh-mm - roundID.txt in UTC at boot time
* It is written to by using the LOG_* and TRACE_* macros:
* LOG/TRACE_CRITICAL
* LOG/TRACE_ERROR
* LOG/TRACE_WARNING
* LOG/TRACE_INFO
* LOG/TRACE_DEBUG
* A LOG_* writes the message passed to it.
* A TRACE_* also includes the file and line it was called on.
*/


/// Write only critical logs. Critical logs are for Startup, Shutdown, and Fatal (intentional crash) events.
//#define __LOG_LEVEL_CRITICAL

/// Write __LOG_LEVEL_CRITICAL plus error logs. Error logs are for when something is wrong and has broken.
//#define __LOG_LEVEL_ERROR

/// Write __LOG_LEVEL_ERROR plus warning logs. Warning logs are for when something was wrong but fixable. Recommended level.
//#define __LOG_LEVEL_WARNING

/// Write __LOG_LEVEL_WARNING plus debug logs. Debug logs are for development and soft bug hunting.
//#define __LOG_LEVEL_DEBUG

/// Write LOG_LEVEL_WARNING plus game logs. Game logs will clutter the diary.
#define __LOG_LEVEL_GAME


// -- Configuration Above, Dragons Below --

var/global/__log_file_day

var/global/__log_file_round

var/global/game_id = copytext(rgb(rand(0, 255), rand(0, 255), rand(0, 255), rand(0, 255)), 2)


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

/proc/__LOG(level, message, source, user)
	if (!message)
		return
	var/ident
	if (source)
		if (user)
			ident = "(src:[source], usr:[user]) "
		else
			ident = "(src:[source]) "
	else if (user)
		ident = "(usr:[user]) "
	to_target(__log_file_day, "[time2text(world.timeofday, "hh-mm-ss", -world.timezone)]z [level] [ident]# [message]")

/proc/__TRACE(level, file, line, message, source, user)
	__LOG(level, "[file]L[line] [message]", source, user)

#define LOG_CRITICAL(MSG_SRC_USR...) __LOG("Critical", MSG_SRC_USR)

#define TRACE_CRITICAL(MSG_SRC_USR...) __TRACE("Critical", __FILE__, __LINE__, MSG_SRC_USR)

#else

#define LOG_CRITICAL(UNUSED...)

#define TRACE_CRITICAL(UNUSED...)

#endif


#if defined(__LOG_LEVEL_ERROR)

#define LOG_ERROR(MSG_SRC_USR...) __LOG("Error", MSG_SRC_USR)

#define TRACE_ERROR(MSG_SRC_USR...) __TRACE("Error", __FILE__, __LINE__, MSG_SRC_USR)

#else

#define LOG_ERROR(UNUSED...)

#define TRACE_ERROR(UNUSED...)

#endif


#if defined(__LOG_LEVEL_WARNING)

#define LOG_WARNING(MSG_SRC_USR...) __LOG("Warning", MSG_SRC_USR)

#define TRACE_WARNING(MSG_SRC_USR...) __TRACE("Warning", __FILE__, __LINE__, MSG_SRC_USR)

#else

#define LOG_WARNING(UNUSED...)

#define TRACE_WARNING(UNUSED...)

#endif


#if defined(__LOG_LEVEL_DEBUG)

#define LOG_DEBUG(MSG_SRC_USR...) __LOG("Debug", MSG_SRC_USR)

#define TRACE_DEBUG(MSG_SRC_USR...) __TRACE("Debug", __FILE__, __LINE__, MSG_SRC_USR)

#else

#define LOG_DEBUG(UNUSED...)

#define TRACE_DEBUG(UNUSED...)

#endif


#if defined(__LOG_LEVEL_GAME)

#define LOG_GAME(MSG_SRC_USR...) __LOG("Game", MSG_SRC_USR)

#define TRACE_GAME(MSG_SRC_USR...) __TRACE("Game", __FILE__, __LINE__, MSG_SRC_USR)

#else

#define LOG_GAME(UNUSED...)

#define TRACE_GAME(UNUSED...)

#endif


/world/New()
	var/boot_time = world.timeofday
	var/year = time2text(boot_time, "YYYY", -world.timezone)
	var/month = time2text(boot_time, "MM", -world.timezone)
	var/day = time2text(boot_time, "DD", -world.timezone)
	var/time = time2text(boot_time, "hh-mm", -world.timezone)
	__log_file_round = file("data/log2/[year]/[month]/[day]/[time] [game_id].txt")
	if (__LOG_LEVEL != "silent")
		__log_file_day = file("data/log2/[year]/[month]/[day].txt")
		if (config.log_uncaught_runtimes)
			world.log = __log_file_day
		if (fexists(__log_file_day))
			to_target(__log_file_day, "\n\n")
	LOG_CRITICAL("BOOTED [game_id]")
	..()


/world/Del()
	LOG_CRITICAL("HALTED [game_id]")
	..()


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
