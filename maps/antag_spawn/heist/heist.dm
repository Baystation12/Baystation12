/datum/map_template/ruin/antag_spawn/heist
	name = "Heist Base"
	suffixes = list("heist/heist_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/antag/skipjack)
	apc_test_exempt_areas = list(
		/area/map_template/skipjack_station = NO_SCRUBBER|NO_VENT|NO_APC
	)

/datum/shuttle/autodock/multi/antag/skipjack
	name = "Skipjack"
	defer_initialisation = TRUE
	warmup_time = 0
	destination_tags = list(
		"nav_skipjack_dock",
		"nav_skipjack_start"
		)
	shuttle_area =  /area/map_template/skipjack_station/start
	dock_target = "skipjack_shuttle"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_transition"
	announcer = "Proximity Sensor Array"
	home_waypoint = "nav_skipjack_start"
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/heist

/obj/effect/shuttle_landmark/skipjack/start
	name = "Raider Outpost"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "skipjack_base"

/obj/effect/shuttle_landmark/skipjack/internim
	name = "In transit"
	landmark_tag = "nav_skipjack_transition"

/obj/effect/shuttle_landmark/skipjack/dock
	name = "Docking Port"
	landmark_tag = "nav_skipjack_dock"
	docking_controller = "skipjack_shuttle_dock_airlock"

//Areas
/area/map_template/skipjack_station
	name = "Raider Outpost"
	icon_state = "yellow"
	requires_power = 0
	req_access = list(access_syndicate)

/area/map_template/skipjack_station/start
	name = "\improper Skipjack"
	icon_state = "yellow"
	req_access = list(access_syndicate)
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED

/area/map_template/syndicate_mothership/raider_base
	name = "\improper Raider Base"
	requires_power = 0
	dynamic_lighting = 0
	req_access = list(access_syndicate)

/turf/simulated/floor/shuttle_ceiling/heist
	color = COLOR_DARK_BROWN