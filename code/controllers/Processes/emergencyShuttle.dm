/datum/controller/process/evac/setup()
	name = "evacuation"
	schedule_interval = 20 // every 2 seconds

	if(!evacuation_controller)
		evacuation_controller = new GLOB.using_map.evac_controller_type ()
		evacuation_controller.set_up()

/datum/controller/process/evac/doWork()
	evacuation_controller.process()
