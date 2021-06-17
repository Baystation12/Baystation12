#include "derelict_areas.dm"

/obj/effect/overmap/visitable/sector/derelict
	name = "debris field"
	desc = "A large field of miscellanious debris."
	icon_state = "object"
	known = 0

	initial_generic_waypoints = list(
		"nav_derelict_1",
		"nav_derelict_2",
		"nav_derelict_3",
		"nav_derelict_4",
		"nav_derelict_5",
		"nav_derelict_6",
		"nav_derelict_7"
	)

/datum/map_template/ruin/away_site/derelict
	name = "Derelict Station"
	id = "awaysite_derelict"
	description = "An abandoned construction project."
	suffixes = list("derelict/derelict-station.dmm")
	spawn_cost = 1
	accessibility_weight = 10
	area_usage_test_exempted_areas = list(/area/AIsattele)
	area_usage_test_exempted_root_areas = list(/area/constructionsite, /area/derelict)
	apc_test_exempt_areas = list(
		/area/AIsattele = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/constructionsite = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/constructionsite/ai = NO_SCRUBBER|NO_VENT,
		/area/constructionsite/atmospherics = NO_SCRUBBER|NO_VENT,
		/area/constructionsite/teleporter = NO_SCRUBBER|NO_VENT,
		/area/derelict/ship = NO_SCRUBBER|NO_VENT,
		/area/djstation = NO_SCRUBBER|NO_VENT|NO_APC
	)
	area_coherency_test_subarea_count = list(
		/area/constructionsite = 7,
		/area/constructionsite/maintenance = 14,
		/area/constructionsite/solar = 3,
	)

/obj/effect/shuttle_landmark/derelict/nav1
	name = "Debris Navpoint #1"
	landmark_tag = "nav_derelict_1"

/obj/effect/shuttle_landmark/derelict/nav2
	name = "Debris Navpoint #2"
	landmark_tag = "nav_derelict_2"

/obj/effect/shuttle_landmark/derelict/nav3
	name = "Debris Navpoint #3"
	landmark_tag = "nav_derelict_3"

/obj/effect/shuttle_landmark/derelict/nav4
	name = "Debris Navpoint #4"
	landmark_tag = "nav_derelict_4"

/obj/effect/shuttle_landmark/derelict/nav5
	name = "Debris Navpoint #5"
	landmark_tag = "nav_derelict_5"

/obj/effect/shuttle_landmark/derelict/nav6
	name = "Debris Navpoint #6"
	landmark_tag = "nav_derelict_6"

/obj/effect/shuttle_landmark/derelict/nav7
	name = "Debris Navpoint #7"
	landmark_tag = "nav_derelict_7"