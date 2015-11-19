/datum/controller/process/disease
	var/tmp/datum/updateQueue/updateQueueInstance

/datum/controller/process/disease/setup()
	name = "disease"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/disease/doWork()
	for(var/disease in active_diseases)
		var/datum/disease/D = disease
		D.process()
		SCHECK

/datum/controller/process/disease/statProcess()
	..()
	stat(null, "[active_diseases.len] disease\s")
