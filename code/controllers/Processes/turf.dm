var/global/list/turf/processing_turfs = list()
var/global/list/turf/processing_turf_effects = list()

/datum/controller/process/turf/setup()
	name = "turf"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/turf/doWork()
	for(var/turf/T in processing_turfs)
		if(T.process() == PROCESS_KILL)
			processing_turfs.Remove(T)
		SCHECK

	for(var/datum/turf_effects/TE in processing_turf_effects)
		if(TE.process() == PROCESS_KILL)
			processing_turf_effects.Remove(TE)
		SCHECK

/datum/controller/process/turf/statProcess()
	..()
	stat(null, "[processing_turfs.len] turf\s")
	stat(null, "[processing_turf_effects.len] effect\s")
