SUBSYSTEM_DEF(evac)
	name = "Evacuation"
	priority = SS_PRIORITY_EVAC
	//Initializes at default time
	flags = SS_NO_TICK_CHECK|SS_BACKGROUND
	wait = 2 SECONDS

/datum/controller/subsystem/evac/Initialize()
	. = ..()
	if(!GLOB.evacuation_controller)
		GLOB.evacuation_controller = new GLOB.using_map.evac_controller_type ()
		GLOB.evacuation_controller.set_up()

/datum/controller/subsystem/evac/fire()
	GLOB.evacuation_controller.process()
