var/global/list/turf/processing_turfs = list()

/datum/controller/process/turf/setup()
	name = "turf"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/turf/doWork()
	for(var/turf/T in processing_turfs)
		if(T.process() == PROCESS_KILL)
			processing_turfs.Remove(T)
		scheck()

/datum/controller/process/turf/getStatName()
	return ..()+"([processing_turfs.len])"
