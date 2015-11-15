/datum/controller/process/wireless/setup()
	name = "wireless"
	schedule_interval = 50

/datum/controller/process/wireless/doWork()
	wifi_manager.process()