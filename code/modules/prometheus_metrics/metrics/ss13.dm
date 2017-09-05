// ss13-specific metrics

/datum/metric_family/ss13_controller_time_seconds
	name = "ss13_controller_time_seconds"
	metric_type = PROMETHEUS_METRIC_COUNTER
	help = "Counter of time spent in a controller in seconds"

/datum/metric_family/ss13_controller_time_seconds/collect()
	var/list/out = list()

	if(processScheduler)
		for(var/datum/controller/process/P in processScheduler.processes)
			out[++out.len] = list(list("type" = "process", "name" = P.name), P.getTotalRunTime() / 10)

	if(Master)
		for(var/name in Master.total_run_times)
			out[++out.len] = list(list("type" = "subsystem", "name" = name), Master.total_run_times[name])

	return out


/datum/metric_family/ss13_master_runlevel
	name = "ss13_master_runlevel"
	metric_type = PROMETHEUS_METRIC_GAUGE
	help = "Current MC runlevel"

/datum/metric_family/ss13_master_runlevel/collect()
	if(Master)
		return list(list(null, Master.current_runlevel))
	return list()
