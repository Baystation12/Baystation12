/datum/controller/process/event/setup()
	name = "event controller"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/event/doWork()
	for(last_object in GLOB.event_manager.active_events)
		var/datum/event/E = last_object
		E.process()
		SCHECK

	for(var/i = EVENT_LEVEL_MUNDANE to EVENT_LEVEL_MAJOR)
		last_object = GLOB.event_manager.event_containers[i]
		var/list/datum/event_container/EC = last_object
		EC.process()
		SCHECK
