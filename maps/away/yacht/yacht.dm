#include "yacht_areas.dm"
#include "yacht.dmm"


/obj/effect/overmap/ship/yacht
	name = "Small ship"
	desc = "Sensor array is detecting a small vessel with unknown lifeforms on board"
	name = "Yacht"
	color = "#FFC966"
	vessel_mass = 30
	default_delay = 35 SECONDS
	speed_mod = 5 SECONDS
	triggers_events = 0
	generic_waypoints = list(
		"nav_yacht_1",
		"nav_yacht_2",
		"nav_yacht_3",
		"nav_yacht_antag"
	)
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
