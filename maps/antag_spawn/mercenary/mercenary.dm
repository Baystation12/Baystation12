/datum/map_template/ruin/antag_spawn/mercenary
	name = "Mercenary Base"
	suffixes = list("mercenary/mercenary_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/merc_shuttle)

/obj/effect/overmap/visitable/merc_base
	name = "TCV Tersten Tenacity"
	desc = "Sensor array detects a medium cargo vessel with high structural damage."
	in_space = 1
	icon_state = "ship"
	hide_from_reports = TRUE
	initial_generic_waypoints = list(
		"nav_merc_1",
		"nav_merc_2",
		"nav_merc_3",
		"nav_merc_4"
	)
	has_distress_beacon = "SOS - multiple breaches, possible hostiles"

/obj/effect/overmap/visitable/ship/landable/merc
	name = "Desperado"
	desc = "A military gunship of ICCG design. Scanner detects heavy modification to the framework of the vessel and no designation."
	shuttle = "Desperado"
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 14000

/datum/shuttle/autodock/overmap/merc_shuttle
	name = "Desperado"
	shuttle_area = list(/area/map_template/merc_shuttle,/area/map_template/merc_shuttle/rear)
	dock_target = "merc_shuttle"
	current_location = "nav_merc_start"
	defer_initialisation = TRUE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/merc
	warmup_time = 5
	range = 1
	fuel_consumption = 7
	skill_needed = SKILL_BASIC

/turf/simulated/floor/shuttle_ceiling/merc
	color = COLOR_RED

/obj/machinery/computer/shuttle_control/explore/merc_shuttle
	name = "shuttle control console"
	shuttle_tag = "Desperado"

/obj/effect/shuttle_landmark/merc/start
	landmark_tag = "nav_merc_start"

/obj/effect/shuttle_landmark/merc/nav1
	landmark_tag = "nav_merc_1"

/obj/effect/shuttle_landmark/merc/nav2
	landmark_tag = "nav_merc_2"

/obj/effect/shuttle_landmark/merc/nav3
	landmark_tag = "nav_merc_3"

/obj/effect/shuttle_landmark/merc/nav4
	landmark_tag = "nav_merc_4"

/obj/effect/shuttle_landmark/merc/dock
	name = "Docking Port"
	landmark_tag = "nav_merc_dock"
	docking_controller = "nuke_shuttle_dock_airlock"

//Areas

/area/map_template/merc_spawn
	name = "\improper TCV Tersten Tenacity"
	icon_state = "syndie-ship"
	req_access = list(access_syndicate)

/area/map_template/merc_shuttle
	name = "\improper Desperado Fore Compartment"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)

/area/map_template/merc_shuttle/rear
	name = "\improper Desperado Rear Compartment"
	icon_state = "green"