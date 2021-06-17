GLOBAL_DATUM_INIT(prometheus_metrics, /datum/prometheus_metrics, new)

// prometheus_metrics holds a list of metric_family datums and uses them to
// create a json protobuf.
/datum/prometheus_metrics
	var/list/metric_families

/datum/prometheus_metrics/New()
	metric_families = list()
	for(var/T in typesof(/datum/metric_family) - /datum/metric_family)
		var/datum/metric_family/mf = T
		if(initial(mf.name) == null || initial(mf.metric_type) == null)
			continue
		metric_families += new T

/datum/prometheus_metrics/proc/collect()
	var/list/out = list()

	for(var/datum/metric_family/MF in metric_families)
		var/proto = MF._to_proto()
		if(proto != null)
			out[++out.len] = MF._to_proto()
	
	return json_encode(out)
