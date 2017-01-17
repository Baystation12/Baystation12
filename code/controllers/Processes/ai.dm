var/list/datum/list_of_ais = list()

/datum/controller/process/ai/setup()
	name = "ai"
	schedule_interval = 2 SECONDS
	start_delay = 17

/datum/controller/process/ai/doWork()
	for(last_object in list_of_ais)
		var/datum/ai/AI = last_object
		if(isnull(AI.gcDestroyed) && istype(AI))
			try
				if(AI.process() == PROCESS_KILL)
					list_of_ais -= AI
			catch(var/exception/e)
				catchException(e, AI)
			SCHECK
		else
			catchBadType(AI)
			list_of_ais -= AI

/datum/controller/process/ai/statProcess()
	..()
	stat(null, "[list_of_ais.len] AI\s")
