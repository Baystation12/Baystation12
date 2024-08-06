#define SECOND *10
#define SECONDS *10

#define MINUTE *600
#define MINUTES *600

#define HOUR *36000
#define HOURS *36000

#define DAY *864000
#define DAYS *864000

GLOBAL_LIST_INIT(month_names, list(
	"January", "February", "March",
	"April", "May", "June",
	"July", "August", "September",
	"October", "November", "December"
))

GLOBAL_LIST_INIT(month_names_short, list(
	"Jan", "Feb", "Mar",
	"Apr", "May", "Jun",
	"Jul", "Aug", "Sep",
	"Oct", "Nov", "Dec"
))

GLOBAL_LIST_INIT(day_names, list(
	"Monday", "Tuesday", "Wednesday",
	"Thursday","Friday", "Saturday",
	"Sunday"
))

GLOBAL_LIST_INIT(day_names_short, list(
	"Mon", "Tue", "Wed",
	"Thu","Fri", "Sat",
	"Sun"
))

/// Real time since the server started. Same concept as REALTIMEOFDAY.
/proc/Uptime(from_zero)
	var/static/days = 0
	var/static/result = 0
	var/static/started = world.timeofday
	var/static/last_time = started
	var/time = world.timeofday
	if (time == last_time)
		return result
	if (time < last_time)
		++days
	last_time = time
	result = time + days DAYS
	if (from_zero)
		result -= started
	return result

/// Converts an integer of world.time to a user-readable string split into time measurements from seconds to years.
/proc/time_to_readable(time, round = TRUE)
	if (!isnum(time))
		time = text2num(time)

	if (time < 0)
		return "INFINITE"
	if (isnull(time))
		return "BAD INPUT"

	var/seconds = time / 10
	var/minutes = 0
	var/hours = 0
	var/days = 0
	var/weeks = 0
	var/months = 0
	var/years = 0
	var/list/result = list()

	// Years
	if (seconds > 31536000)
		years = round(seconds / 31536000)
		seconds -= years * 31536000
		result += "[years] year\s"

	// Months
	if (seconds >= 2592000)
		months = round(seconds / 2592000)
		seconds -= months * 2592000
		result += "[months] month\s"

	// Weeks
	if (seconds >= 604800)
		weeks = round(seconds / 604800)
		seconds -= weeks * 604800
		result += "[weeks] week\s"

	// Days
	if (seconds >= 86400)
		days = round(seconds / 86400)
		seconds -= days * 86400
		result += "[days] day\s"

	// Hours
	if (seconds >= 3600)
		hours = round(seconds / 3600)
		seconds -= hours * 3600
		result += "[hours] hour\s"

	// Minutes
	if (seconds >= 60)
		minutes = round(seconds / 60)
		seconds -= minutes * 60
		result += "[minutes] minute\s"

	// Seconds
	if (round)
		seconds = round(seconds)
	if (seconds > 0 || !length(result)) // Empty result should just say 0 seconds
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

var/global/roundstart_hour
var/global/station_date = ""
var/global/next_station_date_change = 1 DAY

#define duration2stationtime(time) time2text(station_time_in_ticks + time, "hh:mm")
#define worldtime2stationtime(time) time2text(roundstart_hour HOURS + time, "hh:mm")
#define round_duration_in_ticks (round_start_time ? world.time - round_start_time : 0)
#define station_time_in_ticks (roundstart_hour HOURS + round_duration_in_ticks)

/proc/stationtime2text()
	return time2text(station_time_in_ticks, "hh:mm")

/proc/stationdate2text()
	var/update_time = FALSE
	if(station_time_in_ticks > next_station_date_change)
		next_station_date_change += 1 DAY
		update_time = TRUE
	if(!station_date || update_time)
		var/extra_days = round(station_time_in_ticks / (1 DAY)) DAYS
		var/timeofday = world.timeofday + extra_days
		station_date = "[GLOB.using_map.game_year]-[time2text(timeofday, "MM-DD")]"
	return station_date

/proc/time_stamp()
	return time2text(station_time_in_ticks, "hh:mm:ss")

/* Returns 1 if it is the selected month and day */
/proc/isDay(month, day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1

var/global/next_duration_update = 0
var/global/last_round_duration = 0
var/global/round_start_time = 0

/hook/roundstart/proc/start_timer()
	round_start_time = world.time
	return 1

/proc/roundduration2text()
	if(!round_start_time)
		return "00:00"
	if(last_round_duration && world.time < next_duration_update)
		return last_round_duration

	var/mills = round_duration_in_ticks // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = round((mills % 36000) / 600)
	var/hours = round(mills / 36000)

	mins = pad_left("[mins]", 2, "0")
	hours = pad_left("[hours]", 2, "0")

	last_round_duration = "[hours]:[mins]"
	next_duration_update = world.time + 1 MINUTES
	return last_round_duration

/hook/startup/proc/set_roundstart_hour()
	roundstart_hour = rand(0, 23)
	return 1


/proc/stoplag(initial_delay = world.tick_lag)
	if (!Master || !(GAME_STATE & RUNLEVELS_DEFAULT))
		sleep(world.tick_lag)
		return 1
	var/delta
	var/total = 0
	var/delay = initial_delay / world.tick_lag
	do
		delta = delay * max(0.01 * max(world.tick_usage, world.cpu) * max(Master.sleep_delta, 1), 1) // Scale up delay under load; sleeps have entry overhead from proc duplication
		sleep(world.tick_lag * delta)
		total += ceil(delta)
		delay *= 2
	while (world.tick_usage > min(Master.tick_limit_to_run, Master.current_ticklimit))
	return total


/proc/acquire_days_per_month()
	. = list(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
	if(isLeap(text2num(time2text(world.realtime, "YYYY"))))
		.[2] = 29

/proc/get_weekday_index()
	var/list/weekdays = list("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun")
	return weekdays.Find(time2text(world.timeofday, "DDD"))

/proc/current_month_and_day()
	RETURN_TYPE(/list)
	var/time_string = time2text(world.realtime, "MM-DD")
	var/time_list = splittext(time_string, "-")
	return list(text2num(time_list[1]), text2num(time_list[2]))


#define MIDNIGHT_ROLLOVER		864000	//number of deciseconds in a day

var/global/midnight_rollovers = 0
var/global/rollovercheck_last_timeofday = 0
/proc/update_midnight_rollover()
	if (world.timeofday < global.rollovercheck_last_timeofday) //TIME IS GOING BACKWARDS!
		global.midnight_rollovers += 1
	global.rollovercheck_last_timeofday = world.timeofday
	return global.midnight_rollovers

//time of day but automatically adjusts to the server going into the next day within the same round.
//for when you need a reliable time number that doesn't depend on byond time.
#define REALTIMEOFDAY (world.timeofday + (MIDNIGHT_ROLLOVER * MIDNIGHT_ROLLOVER_CHECK))
#define MIDNIGHT_ROLLOVER_CHECK ( global.rollovercheck_last_timeofday != world.timeofday ? update_midnight_rollover() : global.midnight_rollovers )
