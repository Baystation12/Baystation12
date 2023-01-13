/datum/event/gravity/setup()
	announceWhen = rand(15, 60)

/datum/event/gravity/start()
	var/obj/machinery/gravity_generator/main/GG = GLOB.station_gravity_generator
	if(!GG || !(GG.z in affecting_z))
		log_debug("The gravity generator was not found while trying to start an event.")
		return

	GG.set_state(FALSE)
