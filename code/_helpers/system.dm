/// Real time in deciseconds the server process has been active
/proc/uptime()
	var/static/days = 0
	var/static/result = 0
	var/static/start_time = world.timeofday
	var/static/last_time = start_time
	var/time = world.timeofday
	if (time == last_time)
		return result
	if (time < last_time)
		++days
	last_time = time
	result = time - start_time + days DAYS
	return result


/**
* Non-blocking sleep that allows server state to advance while the
* caller waits for something to be complete, or to pause its own
* behavior to be neighbourly
*/
/proc/stoplag(initial_delay = world.tick_lag)
	if (!Master || !(GAME_STATE & RUNLEVELS_DEFAULT))
		sleep(world.tick_lag)
		return 1
	var/delta
	var/total = 0
	var/delay = initial_delay / world.tick_lag
	do // sleeps have entry overhead from proc duplication so delay scales up under load
		delta = delay * max(0.01 * max(world.tick_usage, world.cpu) * max(Master.sleep_delta, 1), 1)
		sleep(world.tick_lag * delta)
		total += ceil(delta)
		delay *= 2
	while (world.tick_usage > min(Master.tick_limit_to_run, Master.current_ticklimit))
	return total
