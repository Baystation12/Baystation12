/// The title-case full english-language name of each month
GLOBAL_LIST_INIT(month_names, list(
	"January", "February", "March",
	"April", "May", "June",
	"July", "August", "September",
	"October", "November", "December"
))


/**
* The title-case 3-letter abbreviation of the english-language
* name of each month
*/
GLOBAL_LIST_INIT(month_names_short, list(
	"Jan", "Feb", "Mar",
	"Apr", "May", "Jun",
	"Jul", "Aug", "Sep",
	"Oct", "Nov", "Dec"
))


/// The title-case full english-language name of each week day
GLOBAL_LIST_INIT(day_names, list(
	"Monday", "Tuesday", "Wednesday",
	"Thursday","Friday", "Saturday",
	"Sunday"
))


/**
* The title-case 3-letter abbreviation of the english-language
* name of each week day
*/
GLOBAL_LIST_INIT(day_names_short, list(
	"Mon", "Tue", "Wed",
	"Thu","Fri", "Sat",
	"Sun"
))


/**
* Converts some number of deciseconds to a user-readable string split
* into time measurements from seconds to years.
*/
/proc/time_to_readable(time)
	var/static/regex/match_integers = regex(@"^-?\d+$")
	if (istext(time))
		if (!findtext(time, match_integers))
			return "BAD INPUT"
		time = text2num(time)
	if (!isnum(time))
		return "BAD_INPUT"
	if (time < 0)
		return "INFINITE"
	var/raw_seconds = floor(time / 10)
	var/list/result = list()
	if (raw_seconds > 31536000) // Years
		var/years = floor(raw_seconds / 31536000)
		raw_seconds -= years * 31536000
		result += "[years] year\s"
	if (raw_seconds >= 2592000) // Months
		var/months = floor(raw_seconds / 2592000)
		raw_seconds -= months * 2592000
		result += "[months] month\s"
	if (raw_seconds >= 604800) // Weeks
		var/weeks = floor(raw_seconds / 604800)
		raw_seconds -= weeks * 604800
		result += "[weeks] week\s"
	if (raw_seconds >= 86400) // Days
		var/days = floor(raw_seconds / 86400)
		raw_seconds -= days * 86400
		result += "[days] day\s"
	if (raw_seconds >= 3600) // Hours
		var/hours = floor(raw_seconds / 3600)
		raw_seconds -= hours * 3600
		result += "[hours] hour\s"
	if (raw_seconds >= 60) // Minutes
		var/minutes = floor(raw_seconds / 60)
		raw_seconds -= minutes * 60
		result += "[minutes] minute\s"
	var/seconds = floor(raw_seconds)
	result += "[seconds] second\s"
	return jointext(result, ", ")


/proc/get_game_time()
	var/static/time_offset = 0
	var/static/last_time = 0
	var/static/last_usage = 0
	var/wtime = world.time
	var/wusage = world.tick_usage * 0.01
	if(last_time < wtime && last_usage > 1)
		time_offset += last_usage - 1
	last_time = wtime
	last_usage = wusage
	return wtime + (time_offset + wusage) * world.tick_lag


/// The in-game time at which the round began.
GLOBAL_VAR(roundstart_hour)

/hook/startup/proc/set_roundstart_hour()
	GLOB.roundstart_hour = rand(0, 23)
	return TRUE


/proc/stationtime2text()
	return time2text(station_time_in_ticks, "hh:mm")


GLOBAL_VAR(station_date)

GLOBAL_VAR_INIT(next_station_date_change, 1 DAY)

/proc/stationdate2text()
	var/update_time = FALSE
	if (station_time_in_ticks > GLOB.next_station_date_change)
		GLOB.next_station_date_change += 1 DAY
		update_time = TRUE
	if (update_time || !GLOB.station_date)
		var/extra_days = round(station_time_in_ticks / (1 DAY)) DAYS
		var/timeofday = world.timeofday + extra_days
		GLOB.station_date = "[GLOB.using_map.game_year]-[time2text(timeofday, "MM-DD")]"
	return GLOB.station_date


/proc/time_stamp()
	return time2text(station_time_in_ticks, "hh:mm:ss")


GLOBAL_VAR(round_start_time)

/hook/roundstart/proc/start_timer()
	GLOB.round_start_time = uptime()
	return TRUE


/proc/roundduration2text()
	var/static/result = "00:00"
	var/static/next_update
	if (!GLOB.round_start_time)
		return result
	if (result && world.time < next_update)
		return result
	var/mills = round_duration_in_ticks // only to ds accuracy
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)
	mins = pad_left("[mins]", 2, "0")
	hours = pad_left("[hours]", 2, "0")
	result = "[hours]:[mins]"
	next_update = world.time + 1 MINUTE
	return result


/proc/acquire_days_per_month()
	. = list(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
	if (isLeap(text2num(time2text(world.realtime, "YYYY"))))
		.[2] = 29


/proc/get_weekday_index()
	return GLOB.day_names_short.Find(time2text(world.timeofday, "DDD"))


/proc/current_month_and_day()
	RETURN_TYPE(/list)
	var/time_string = time2text(world.realtime, "MM-DD")
	var/time_list = splittext(time_string, "-")
	return list(text2num(time_list[1]), text2num(time_list[2]))
