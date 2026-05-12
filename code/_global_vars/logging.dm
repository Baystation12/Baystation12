var/global/datum/configuration/config
var/global/diary
var/global/game_id = randhex(8)
var/global/datum/log_init/log_initializer = new

GLOBAL_VAR(log_directory)
GLOBAL_PROTECT(log_directory)

/datum/log_init/New()
	GLOB.log_directory = "data/logs/[time2text(world.realtime, "YYYY/MM/DD", 0)]/[time2text(world.timeofday, "hhmm", 0)]-[game_id]"
	del(src)
