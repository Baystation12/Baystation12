var/global/list/processing_turfs = list()

/datum/controller/process/turf/setup()
	name = "turf"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/turf/doWork()
	for(var/turf/unsimulated/wall/supermatter/SM in processing_turfs)
		SM.process()
