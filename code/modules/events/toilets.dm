/datum/event/toilet_clog
	var/clog_min = 1
	var/clog_max = 3
	var/clog_severity_min = 1
	var/clog_severity_max = 2

/datum/event/toilet_clog/start()
	var/clog_amt = rand(clog_min,clog_max)
	var/clog_severity = rand(clog_severity_min, clog_severity_max)
	var/list/toilets = SSfluids.hygiene_props.Copy()
	while(clog_amt && toilets.len)
		var/obj/structure/hygiene/toilet = pick_n_take(toilets)
		if((toilet.z in affecting_z) && toilet.clog(clog_severity)) clog_amt--

/datum/event/toilet_clog/flood
	clog_min = 3
	clog_max = 5
	clog_severity_min = 3
	clog_severity_max = 3