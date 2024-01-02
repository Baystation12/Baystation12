/datum/map_template/ruin/exoplanet/crashed_shuttle
	name = "Crushed shuttle"
	id = "crashed_shuttle"
	description = "Crushed corporate shuttle."
	suffixes = list("crashed_shuttle/crashed_shuttle.dmm")
	spawn_cost = 0.5
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/graysontug)
	apc_test_exempt_areas = list(/area/map_template/crashed_shuttle/crash = NO_SCRUBBER|NO_VENT|NO_APC)
	ruin_tags = RUIN_HUMAN|RUIN_WRECK
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS

	skip_main_unit_tests = "Ruin has shuttle landmark."

/area/map_template/crashed_shuttle/graysontug
	name = "\improper GM Tug"
	icon_state = "shuttlegrn"

/area/map_template/crashed_shuttle/crash
	name = "\improper Crash zone"
	icon_state = "shuttle2"
	area_flags = AREA_FLAG_EXTERNAL

/datum/shuttle/autodock/overmap/graysontug
	name = "GM Tug"
	dock_target = "graysontug_shuttle"
	current_location = "nav_graysontug_start"
	range = 1
	shuttle_area = /area/map_template/crashed_shuttle/graysontug
	fuel_consumption = 4
	defer_initialisation = TRUE
	flags = SHUTTLE_FLAGS_PROCESS
	skill_needed = SKILL_MIN
	ceiling_type = /turf/simulated/floor/shuttle_ceiling

/obj/machinery/computer/shuttle_control/explore/graysontug
	name = "GM Tug Shuttle control console"
	shuttle_tag = "GM Tug"

/obj/overmap/visitable/ship/landable/graysontug
	name = "GM Tug"
	desc = "Grayson Manufactories Tug. Space truckin commonly seen across Frontier."
	shuttle = "GM Tug"
	fore_dir = NORTH
	color = "#e6f7ff"
	vessel_mass = 2500
	vessel_size = SHIP_SIZE_TINY

/obj/shuttle_landmark/graysontug/start
	name = "Crash Zone"
	landmark_tag = "nav_graysontug_start"
	base_area = /area/map_template/crashed_shuttle/crash
	base_turf = /turf/simulated/floor/exoplanet/barren
	movable_flags = MOVABLE_FLAG_EFFECTMOVE
