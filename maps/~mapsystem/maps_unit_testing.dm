/datum/map
	// Unit test vars
	var/list/apc_test_exempt_areas = list()
	var/list/area_coherency_test_exempt_areas = list(
			/area/space,
			/area/mine/explored,
			/area/mine/unexplored)

	var/const/NO_APC = 1
	var/const/NO_VENT = 2
	var/const/NO_SCRUBBER = 4
