/datum/map/overmap_example
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/scrap/shuttle/ = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/sector/shuttle/ = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/scrap/cargo/lower = NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/maintenance/engine/lower = NO_VENT,
		/area/ship/scrap/maintenance/engine/aft = NO_SCRUBBER,
		/area/ship/scrap/maintenance/engine/port = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/scrap/maintenance/engine/starboard = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/scrap/maintenance/atmos = NO_SCRUBBER,
		/area/ship/scrap/crew/hallway/port= NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/crew/hallway/starboard= NO_SCRUBBER|NO_VENT|NO_APC,
	)
