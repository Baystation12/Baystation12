/datum/controller/process/nanoui
	var/tmp/datum/updateQueue/updateQueueInstance

/datum/controller/process/nanoui/setup()
	name = "nanoui"
	schedule_interval = 10 // every 1 second
	updateQueueInstance = new

/datum/controller/process/nanoui/doWork()
	updateQueueInstance.init(nanomanager.processing_uis, "process")
	updateQueueInstance.Run()

/datum/controller/process/nanoui/getStatName()
	return ..()+"([nanomanager.processing_uis.len])"
