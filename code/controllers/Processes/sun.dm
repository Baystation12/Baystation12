/datum/controller/process/sun/setup()
	name = "sun"
	schedule_interval = 20 // every second
	GLOB.sun = new

/datum/controller/process/sun/doWork()
	GLOB.sun.calc_position()
