/datum/map_template/ruin/antag_spawn/hunter_ascent
	name = "Ascent Carrier"
	suffixes = list("hunter/hunter_base_ascent.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ascent_cutter)

/area/map_template/ascent_carrier
	name = "\improper Ascent Carrier"
	icon_state = "syndie-ship"
	req_access = list(access_ascent_warship)

/area/map_template/ascent_cutter
	name = "\improper Ascent Cutter"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_ascent_warship)

/datum/shuttle/autodock/overmap/ascent_cutter
	name = "Ascent Cutter"
	//dock_target = "ascent_cutter_dock"
	shuttle_area = list(/area/map_template/ascent_cutter)
	current_location = "nav_ascent_cutter_start"
	defer_initialisation = TRUE
	warmup_time = 5
	range = 2
	fuel_consumption = 2
	skill_needed = SKILL_NONE

/obj/effect/shuttle_landmark/ascent_cutter_start
	name = "Ascent Carrier"
	landmark_tag = "nav_ascent_cutter_start"
	//docking_controller = "ascent_carrier_dock"

/obj/machinery/computer/shuttle_control/explore/ascent_cutter
	name = "cutter control console"
	shuttle_tag = "Ascent Cutter"

/obj/effect/overmap/visitable/sector/hunter_base_ascent
	name = "Ascent Carrier"
	desc = "Sensor array detects an inactive Ascent carrier ship. Power readings and heat signatures are minimal."
	in_space = TRUE
	known = FALSE
	icon_state = "object"
	hide_from_reports = TRUE

/obj/effect/overmap/visitable/ship/landable/ascent_cutter
	name = "Ascent Cutter"
	desc = "A sleek, menacing interceptor of Ascent design, all prongs and sharp angles."
	shuttle = "Ascent Cutter"
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 7500
