// byond-specific metrics

/datum/metric_family/byond_time
	name = "byond_world_time_seconds"
	metric_type = PROMETHEUS_METRIC_COUNTER
	help = "Counter of 'game-time' seconds since server startup"

/datum/metric_family/byond_time/collect()
	return list(list(null, world.time / 10))


/datum/metric_family/byond_tick_lag
	name = "byond_tick_lag"
	metric_type = PROMETHEUS_METRIC_GAUGE
	help = "Current value of world.tick_lag"

/datum/metric_family/byond_tick_lag/collect()
	return list(list(null, world.tick_lag))


/datum/metric_family/byond_players
	name = "byond_players"
	metric_type = PROMETHEUS_METRIC_GAUGE
	help = "Number of players currently connected to the server"

/datum/metric_family/byond_players/collect()
	var/c = 0
	for(var/client/C)
		if(C.connection == "seeker" || C.connection == "web")
			c++
	return list(list(null, c))


/datum/metric_family/byond_cpu
	name = "byond_cpu"
	metric_type = PROMETHEUS_METRIC_GAUGE
	help = "Current value of world.cpu"

/datum/metric_family/byond_cpu/collect()
	return list(list(null, world.cpu))
