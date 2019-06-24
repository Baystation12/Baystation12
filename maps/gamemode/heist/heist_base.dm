#include "heist_base_areas.dm"

/datum/game_mode/heist
	overmap_template = /datum/map_template/ruin/gamemode_site/heist_base

/obj/effect/overmap/sector/heist_base
	name = "asteroid base"
	desc = "A large asteroid emitting faint traces of sub-space activity."
	icon_state = "meteor2"
	known = 0

/datum/map_template/ruin/gamemode_site/heist_base
	name = "raider asteroid base"
	id = "awaysite_heist_hideout"
	description = "Just another large asteroid."
	suffixes = list("heist/heist_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/heist)

/obj/effect/shuttle_landmark/heist/nav1
	name = "Asteroid Base Navpoint #1"
	landmark_tag = "nav_heist_1"

/obj/effect/shuttle_landmark/heist/nav2
	name = "Asteroid Base Navpoint #2"
	landmark_tag = "nav_heist_2"

//Skipjack

/obj/machinery/computer/shuttle_control/explore/vox
	name = "skipjack control console"
	req_access = list(access_syndicate)
	shuttle_tag = "skipjack"

/datum/shuttle/autodock/overmap/heist
	name = "skipjack"
	move_time = 60
	shuttle_area = /area/map_template/skipjack_station/start
	dock_target = "skipjack_shuttle"
	current_location = "nav_skipjack_start"
	landmark_transition = "nav_skipjack_transition"
	range = 1
	fuel_consumption = 0
	logging_home_tag = "nav_skipjack_start"
	defer_initialisation = TRUE

/obj/effect/overmap/ship/landable/heist
	name = "skipjack"
	shuttle = "skipjack"
	vessel_mass = 1000
	fore_dir = NORTH

/obj/effect/shuttle_landmark/skipjack/start
	name = "Raider Outpost"
	landmark_tag = "nav_skipjack_start"
	docking_controller = "skipjack_base"

/obj/effect/shuttle_landmark/transit/gamemode/skipjack
	name = "In transit"
	landmark_tag = "nav_skipjack_transition"
