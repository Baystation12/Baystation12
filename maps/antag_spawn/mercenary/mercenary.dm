/datum/map_template/ruin/antag_spawn/mercenary
	name = "Mercenary Base"
	suffixes = list("mercenary/mercenary_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/merc_shuttle)
/*	apc_test_exempt_areas = list(
		/area/map_template/merc_shuttle = NO_SCRUBBER|NO_VENT|NO_APC)*/

/obj/effect/overmap/sector/merc_base
	name = "asteriod cluster"
	desc = "Sensor array detects artifical structures permeating through the asteriod cluster."
	in_space = 1
	icon_state = "meteor2"
	initial_generic_waypoints = list(//this one
		"nav_merc_1",
	)

/obj/effect/overmap/ship/landable/merc
	name = "mercenary shuttle"
	desc = "A military gunship of CCG design. Scanner detects heavy modification to the framework of the vessel and no designation."
	shuttle = "Merc Shuttle"
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL
	vessel_mass = 15000

/obj/effect/overmap/ship/landable/merc/Initialize()
	. = ..()
	name = pick("Wasp", "Hornet", "Mosquito")

/datum/shuttle/autodock/overmap/merc_shuttle
	name = "Merc Shuttle"
	shuttle_area = list(/area/merc_shuttle,/area/merc_shuttle/rear)
	dock_target = "merc_shuttle"
	current_location = "nav_merc_start"
	defer_initialisation = TRUE
	ceiling_type = /turf/simulated/floor/shuttle_ceiling
	warmup_time = 5
	range = 1
	fuel_consumption = 7
	skill_needed = SKILL_BASIC

/obj/machinery/computer/shuttle_control/explore/merc_shuttle
	name = "shuttle control console"
	shuttle_tag = "Merc Shuttle"

/obj/effect/shuttle_landmark/merc/start
	name = "Mercenary Base"
	landmark_tag = "nav_merc_start"
	docking_controller = "merc_base"

/obj/effect/shuttle_landmark/merc/nav
	name = "Mercenary Base"
	landmark_tag = "nav_merc_1"

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

/area/merc_shuttle
	name = "\improper Mercenary Shuttle Fore Compartment"
	icon_state = "yellow"
	area_flags = AREA_FLAG_RAD_SHIELDED | AREA_FLAG_ION_SHIELDED
	req_access = list(access_syndicate)

/area/merc_shuttle/rear
	name = "\improper Mercenary Shuttle Rear Compartment"
	icon_state = "green"