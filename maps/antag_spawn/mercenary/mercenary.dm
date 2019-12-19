/datum/map_template/ruin/antag_spawn/mercenary
	name = "Mercenary Base"
	suffixes = list("mercenary/mercenary_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/multi/antag/mercenary)
	apc_test_exempt_areas = list(
		/area/map_template/merc_shuttle = NO_SCRUBBER|NO_VENT|NO_APC
	)

/datum/shuttle/autodock/multi/antag/mercenary
	name = "Mercenary"
	defer_initialisation = TRUE
	warmup_time = 0
	destination_tags = list(
		"nav_merc_dock",
		"nav_merc_start"
		)
	shuttle_area = /area/map_template/merc_shuttle
	dock_target = "merc_shuttle"
	current_location = "nav_merc_start"
	landmark_transition = "nav_merc_transition"
	announcer = "Proximity Sensor Array"
	home_waypoint = "nav_merc_start"
	arrival_message = "Attention, vessel detected entering vessel proximity."
	departure_message = "Attention, vessel detected leaving vessel proximity."

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_base"

/obj/effect/shuttle_landmark/merc/internim
	name = "In transit"
	landmark_tag = "nav_merc_transition"

/obj/effect/shuttle_landmark/merc/dock
	name = "Docking Port"
	landmark_tag = "nav_merc_dock"
	docking_controller = "nuke_shuttle_dock_airlock"

//Areas

/area/map_template/syndicate_mothership
	name = "\improper Mercenary Base"
	icon_state = "syndie-ship"
	requires_power = 0
	dynamic_lighting = 0
	req_access = list(access_syndicate)

/area/map_template/merc_shuttle
	name = "\improper Mercenary Forward Operating Base"
	icon_state = "yellow"
	requires_power = 0
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)
