/datum/shuttle/autodock/overmap/salvage_shuttle
	name = "ISV Crab"
	move_time = 45
	shuttle_area = list(
		/area/salvage_shuttle/cockpit,
		/area/salvage_shuttle/maintenance,
		/area/salvage_shuttle/airlock,
		/area/salvage_shuttle/lounge,
		/area/salvage_shuttle/cargo,
		/area/salvage_shuttle/net
	)
	dock_target = "crab_dock"
	current_location = "nav_salvage_shuttle_crab"
	landmark_transition = "nav_transit_salvage_shuttle"
	range = 1
	fuel_consumption = 3
	logging_home_tag = "nav_salvage_shuttle_crab"
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	flags = SHUTTLE_FLAGS_PROCESS
	defer_initialisation = TRUE

/obj/overmap/visitable/ship/landable/salvage_shuttle
	name = "ISV Crab"
	desc = "A Firex SX5-B salvage shuttle, broadcasting the callsign \"Crab\""
	shuttle = "ISV Crab"
	max_speed = 1/(5 SECONDS)
	burn_delay = 2 SECONDS
	vessel_mass = 4000
	fore_dir = WEST
	skill_needed = SKILL_BASIC
	vessel_size = SHIP_SIZE_SMALL

/obj/shuttle_landmark/nav_salvage_shuttle
	base_turf = /turf/space
	base_area = /area/space

/obj/shuttle_landmark/nav_salvage_shuttle/crab
	name = "Navpoint - Crab"
	landmark_tag = "nav_salvage_shuttle_crab"
	docking_controller = "crab_dock"

/obj/shuttle_landmark/nav_salvage_shuttle/nav1
	name = "Navpoint A"
	landmark_tag = "nav_salvage_shuttle_1"

/obj/shuttle_landmark/nav_salvage_shuttle/nav2
	name = "Navpoint B"
	landmark_tag = "nav_salvage_shuttle_2"

/obj/shuttle_landmark/nav_salvage_shuttle/nav3
	name = "Navpoint C"
	landmark_tag = "nav_salvage_shuttle_3"

/obj/shuttle_landmark/nav_salvage_shuttle/transit
	name = "In transit"
	landmark_tag = "nav_transit_salvage_shuttle"

/obj/shuttle_landmark/nav_salvage_shuttle/torch/d4
	name = "SEV Torch ISV Crab EVA Dock"
	landmark_tag = "nav_salvage_shuttle_torch_eva_dock"

/obj/machinery/computer/shuttle_control/explore/crab
	name = "crab control console"
	shuttle_tag = "ISV Crab"
