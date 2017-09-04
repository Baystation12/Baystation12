/datum/event/grid_check	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 5

/datum/event/grid_check/start()
	power_failure(0, severity, GLOB.using_map.contact_levels)

/datum/event/grid_check/announce()
	GLOB.using_map.grid_check_announcement()
