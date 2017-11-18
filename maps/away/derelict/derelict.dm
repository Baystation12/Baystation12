#include "derelict_areas.dm"

/obj/effect/overmap/sector/derelict
	name = "debris field"
	desc = "A large field of miscellanious debris."
	icon_state = "object"
	known = 0

	generic_waypoints = list(
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
	cost = 1
	accessibility_weight = 10

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