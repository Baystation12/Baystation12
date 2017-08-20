// ss13-specific metrics

/datum/metric_family/ss13_process_time_seconds
	name = "ss13_process_time_seconds"
	metric_type = PROMETHEUS_METRIC_COUNTER
	help = "Counter of time spent in a process in seconds"

/datum/metric_family/ss13_process_time_seconds/collect()
	var/list/out = list()

	if(processScheduler)
		for(var/datum/controller/process/P in processScheduler.processes)
			out[++out.len] = list(list("process" = P.name), P.getTotalRunTime() / 10)

	return out
