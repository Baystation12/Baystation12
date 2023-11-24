/datum/map_template/ruin/antag_spawn/ert
	prefix = "mods/antagonists/maps/"
	suffixes = list("ert_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/antag/rescue)
	apc_test_exempt_areas = list(/area/map_template/rescue_base = NO_SCRUBBER|NO_VENT|NO_APC)

/datum/shuttle/autodock/multi/antag/rescue
	destination_tags = list(
		"nav_ert_deck1",
		"nav_ert_deck2",
		"nav_ert_deck3",
		"nav_ert_deck4",
		"nav_ert_deck5",
		"nav_ert_dock",
		"nav_ert_start"
	)

// Areas

/area/map_template/rescue_base/start
	base_turf = /turf/unsimulated/floor/techfloor
