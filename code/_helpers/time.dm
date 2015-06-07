#define SECOND *10
#define SECONDS *10

#define MINUTE *600
#define MINUTES *600

var/roundstart_hour = 0
//Returns the world time in english
proc/worldtime2text(time = world.time)
	if(!roundstart_hour) roundstart_hour = pick(2,7,12,17)
	return "[round(time / 36000)+roundstart_hour]:[(time / 600 % 60) < 10 ? add_zero(time / 600 % 60, 1) : time / 600 % 60]"

proc/worlddate2text()
	return num2text((text2num(time2text(world.timeofday, "YYYY"))+544)) + "-" + time2text(world.timeofday, "MM-DD")
	
proc/time_stamp()
	return time2text(world.timeofday, "hh:mm:ss")

/* Returns 1 if it is the selected month and day */
proc/isDay(var/month, var/day)
	if(isnum(month) && isnum(day))
		var/MM = text2num(time2text(world.timeofday, "MM")) // get the current month
		var/DD = text2num(time2text(world.timeofday, "DD")) // get the current day
		if(month == MM && day == DD)
			return 1

		// Uncomment this out when debugging!
		//else
			//return 1
