// Datum used for gathering a set of prometheus metrics.
/datum/metric_family
	var/name = null
	var/metric_type = null
	var/help = null

// Collect should return a list of lists with two entries, one being a list and the other being a number.
/datum/metric_family/proc/collect()
	var/list/out = list()

	out[++out.len] = list(list("foo" = "bar"), 3.14)
	out[++out.len] = list(list("abc" = "def"), 1.23)

	return out

// _to_proto will call the collect() method and format its result in a list
// suitable for encoding as a JSON protobuf mapping.
/datum/metric_family/proc/_to_proto()
	var/list/collected = collect()
	
	var/list/out = list(
		"name" = name,
		"type" = metric_type,
	)

	if(help != null)
		out["help"] = help

	var/list/metrics = list()
	for(var/list/m in collected)
		if(m.len != 2)
			continue

		var/list/label_pairs = list()
		for(var/k in m[1])
			label_pairs[++label_pairs.len] = list("name" = k, "value" = m[1][k])

		metrics[++metrics.len] = list("label" = label_pairs, PROMETHEUS_METRIC_NAME(metric_type) = list("value" = m[2]))
	
	if(metrics.len == 0)
		return null
	out["metric"] = metrics

	return out
