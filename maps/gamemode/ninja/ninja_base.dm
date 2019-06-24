#include "ninja_base_areas.dm"

/datum/game_mode/ninja
	overmap_template = /datum/map_template/ruin/gamemode_site/ninja_base

/obj/effect/overmap/sector/ninja_base
	name = "anomalous electrical storm"
	desc = "A large asteroid emitting faint traces of sub-space activity."
	icon_state = "electrical1"
	known = 0

/datum/map_template/ruin/gamemode_site/ninja_base
	name = "anomalous electrical storm"
	id = "awaysite_ninja_hideout"
	description = "A large electrical storm causing unusual sensor readings."
	suffixes = list("ninja/ninja_base.dmm")
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ninja)

/obj/effect/shuttle_landmark/ninja/nav1
	name = "Electrical Storm Navpoint #1"
	landmark_tag = "nav_ninja_1"

/obj/effect/shuttle_landmark/ninja/nav2
	name = "Electrical Storm Navpoint #2"
	landmark_tag = "nav_ninja_2"

//Shuttle

/obj/machinery/computer/shuttle_control/explore/ninja
	name = "stealth shuttle control console"
	req_access = list(access_syndicate)
	shuttle_tag = "stealth shuttle"

/datum/shuttle/autodock/overmap/ninja
	name = "stealth shuttle"
	move_time = 60
	shuttle_area = /area/map_template/ninja_dojo/start
	current_location = "nav_ninja_start"
	landmark_transition = "nav_ninja_transition"
	range = 1
	fuel_consumption = 0
	logging_home_tag = "nav_skipjack_start"
	defer_initialisation = TRUE

/obj/effect/overmap/ship/landable/ninja
	name = "stealth shuttle"
	shuttle = "stealth shuttle"
	vessel_mass = 500
	fore_dir = SOUTH

/obj/effect/shuttle_landmark/ninja/start
	name = "Clan Dojo"
	landmark_tag = "nav_ninja_start"

/obj/effect/shuttle_landmark/ninja/internim
	name = "In transit"
	landmark_tag = "nav_ninja_transition"
