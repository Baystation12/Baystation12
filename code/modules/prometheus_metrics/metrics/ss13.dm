// ss13-specific metrics

/datum/metric_family/ss13_controller_time_seconds
	name = "ss13_controller_time_seconds"
	metric_type = PROMETHEUS_METRIC_COUNTER
	help = "Counter of time spent in a controller in seconds"

/datum/metric_family/ss13_controller_time_seconds/collect()
	var/list/out = list()
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


/datum/metric_family/ss13_garbage_queue_length
	name = "ss13_garbage_queue_length"
	metric_type = PROMETHEUS_METRIC_GAUGE
	help = "Length of SSgarbage queues"

/datum/metric_family/ss13_garbage_queue_length/collect()
	var/list/out = list()

	if(SSgarbage)
		for(var/i = 1 to GC_QUEUE_COUNT)
			out[++out.len] = list(list("queue" = "[i]"), length(SSgarbage.queues[i]))

	return out


/datum/metric_family/ss13_garbage_queue_results
	name = "ss13_garbage_queue_results"
	metric_type = PROMETHEUS_METRIC_COUNTER
	help = "Counter of pass/fail results for SSgarbage queues"

/datum/metric_family/ss13_garbage_queue_results/collect()
	var/list/out = list()

	if(SSgarbage)
		for(var/i = 1 to GC_QUEUE_COUNT)
			out[++out.len] = list(list("queue" = "[i]", "result" = "pass"), SSgarbage.pass_counts[i])
			out[++out.len] = list(list("queue" = "[i]", "result" = "fail"), SSgarbage.fail_counts[i])

	return out


/datum/metric_family/ss13_garbage_total_cleaned
	name = "ss13_garbage_total_cleaned"
	metric_type = PROMETHEUS_METRIC_COUNTER
	help = "Counter for number of objects deleted/GCed by SSgarbage"

/datum/metric_family/ss13_garbage_total_cleaned/collect()
	var/list/out = list()

	if(SSgarbage)
		out[++out.len] = list(list("type" = "gc"), SSgarbage.totalgcs)
		out[++out.len] = list(list("type" = "del"), SSgarbage.totaldels)

	return out
