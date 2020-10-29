/datum/map_template/ruin/antag_spawn/mercenary
	name = "Mercenary Base"
	suffixes = list("mercenary/mercenary_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/merc_shuttle)

/obj/effect/overmap/visitable/merc_base
	name = "Barren Asteroid"
	desc = "Sensor array detects a small asteroid devoid of any useful materials."
	in_space = 1
	icon_state = "meteor4"
	hide_from_reports = TRUE
	initial_generic_waypoints = list(
		"nav_merc_1",
		"nav_merc_2",
		"nav_merc_3",
		"nav_merc_4"
	)


/obj/effect/overmap/visitable/ship/landable/merc
	name = "Hammerhead"
	desc = "An older model shuttle with a number of visible modifications. The hull plating is deflecting attempts at more thorough scans."
	shuttle = "Hammerhead"
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 14000

/datum/shuttle/autodock/overmap/merc_shuttle
	name = "Hammerhead"
	shuttle_area = list(/area/map_template/merc_shuttle,/area/map_template/merc_shuttle/rear)
	dock_target = "merc_shuttle"
	current_location = "nav_merc_start"
	defer_initialisation = TRUE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling/merc
	warmup_time = 5
	range = 1
	fuel_consumption = 4
	skill_needed = SKILL_NONE

/turf/simulated/floor/shuttle_ceiling/merc
	color = COLOR_RED

/obj/machinery/computer/shuttle_control/explore/merc_shuttle
	name = "shuttle control console"
	shuttle_tag = "Hammerhead"

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
	docking_controller = "eva_airlock"

//Areas

/area/map_template/merc_spawn
	name = "\improper Abandoned Mine"
	icon_state = "syndie-ship"
	req_access = list(access_syndicate)

/area/map_template/merc_shuttle
	name = "\improper Hammerhead Fore Compartment"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)

/area/map_template/merc_shuttle/rear
	name = "\improper Hammerhead Rear Compartment"
	icon_state = "green"
