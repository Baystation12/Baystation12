/datum/map_template/ruin/antag_spawn/hunter
	name = "Disused Dockyard"
	suffixes = list("hunter/hunter_base_generic.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/bounty_hunter_shuttle)

/area/map_template/hunter_base
	name = "\improper Disused Dockyard"
	icon_state = "syndie-ship"
	req_access = list(access_hunter)

/area/map_template/hunter_shuttle
	name = "\improper ICV Courser VII"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_hunter)

/datum/shuttle/autodock/overmap/bounty_hunter_shuttle
	name = "ICV Courser VII"
	//dock_target = "hunter_shuttle_dock"
	shuttle_area = list(/area/map_template/hunter_shuttle)
	current_location = "nav_hunter_start"
	defer_initialisation = TRUE
	warmup_time = 5
	range = 2
	fuel_consumption = 2
	skill_needed = SKILL_NONE

/obj/effect/shuttle_landmark/hunter_start
	name = "Disused Dockyard"
	landmark_tag = "nav_hunter_start"
	//docking_controller = "hunter_base_dock"

/obj/machinery/computer/shuttle_control/explore/bounty_hunter
	name = "cruiser control console"
	shuttle_tag = "ICV Courser VII"

/obj/effect/overmap/visitable/sector/hunter_base
	name = "disused dockyards"
	desc = "Sensor array detects a small, long-abandoned dockyard. Scans report nothing of significance."
	in_space = TRUE
	known = FALSE
	icon_state = "object"
	hide_from_reports = TRUE

/obj/effect/overmap/visitable/ship/landable/hunter_ship
	name = "ICV Courser VII"
	desc = "A small older-model interceptor craft. The transponder codes seem to be out of date."
	shuttle = "ICV Courser VII"
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 7500
