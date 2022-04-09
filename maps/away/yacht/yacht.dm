#include "yacht_areas.dm"

/obj/effect/overmap/visitable/ship/yacht
	name = "private yacht"
	desc = "Sensor array is detecting a small vessel with unknown lifeforms on board."
	color = "#ffc966"
	vessel_mass = 3000
	max_speed = 1/(2 SECONDS)
	initial_generic_waypoints = list(
		"nav_yacht_1",
		"nav_yacht_2",
		"nav_yacht_3",
		"nav_yacht_antag"
	)

/obj/effect/overmap/visitable/ship/yacht/New(nloc, max_x, max_y)
	name = "IPV [pick("Razorshark", "Aurora", "Lighting", "Pequod", "Anansi")], \a [name]"
	..()

/datum/map_template/ruin/away_site/yacht
	name = "Yacht"
	id = "awaysite_yach"
	description = "Tiny movable ship with spiders."
	suffixes = list("yacht/yacht.dmm")
	spawn_cost = 0.5
	area_usage_test_exempted_root_areas = list(/area/yacht)

/obj/effect/shuttle_landmark/nav_yacht/nav1
	name = "Small Yacht Navpoint #1"
	landmark_tag = "nav_yacht_1"

/obj/effect/shuttle_landmark/nav_yacht/nav2
	name = "Small Yacht Navpoint #2"
	landmark_tag = "nav_yacht_2"

/obj/effect/shuttle_landmark/nav_yacht/nav3
	name = "Small Yacht Navpoint #3"
	landmark_tag = "nav_yacht_3"

/obj/effect/shuttle_landmark/nav_yacht/nav4
	name = "Small Yacht Navpoint #4"
	landmark_tag = "nav_yacht_antag"
