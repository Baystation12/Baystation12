/// Multiplies by deciseconds in a second
#define SECOND *10

/// Multiplies by deciseconds in a second
#define SECONDS *10

/// Multiplies by deciseconds in a minute
#define MINUTE *600

/// Multiplies by deciseconds in a minute
#define MINUTES *600

/// Multiplies by deciseconds in an hour
#define HOUR *36000

/// Multiplies by deciseconds in an hour
#define HOURS *36000

/// Multiplies by deciseconds in a day
#define DAY *864000

/// Multiplies by deciseconds in a day
#define DAYS *864000

#define worldtime2stationtime(time) time2text(GLOB.roundstart_hour HOURS + time, "hh:mm")

#define station_time_in_ticks (GLOB.roundstart_hour HOURS + round_duration_in_ticks)

#define duration2stationtime(time) time2text(station_time_in_ticks + time, "hh:mm")

#define round_duration_in_ticks (GLOB.round_start_time ? uptime() - GLOB.round_start_time : 0)
