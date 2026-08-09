#include "requiem_areas.dm"
/obj/overmap/visitable/sector/requiem
	name = "derelict ship"
	desc = "Sensor array detects an arctic planet with degraded bluespace emission signatures. Sensors further dictate the presence of a big, crashed ship, and a smaller crashed shuttle."
	icon_state = "globe"
	initial_generic_waypoints = list(
		"nav_requiem_1",
		"nav_requiem_2",
		"nav_requiem_3"
	)

/obj/overmap/visitable/sector/requiem/New(nloc, max_x, max_y)
	name = "Derelict Vessel"
	..()

/datum/map_template/ruin/requiem
	name = "Crashed Sol Exploration Vessel"
	id = "awaysite_requiem"
	spawn_cost = 2
	description = "An arctic planet with a crashed Sol ship."
	suffixes = list("maps/event/requiem/requiem-1.dmm","maps/event/requiem/requiem-2.dmm")
	template_flags = TEMPLATE_FLAG_SPAWN_GUARANTEED
	// generate_mining_by_z = 2

	area_usage_test_exempted_root_areas = list(/area/requiem)
	apc_test_exempt_areas = list(
		/area/requiem/underground = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/requiem/ground = NO_SCRUBBER|NO_VENT|NO_APC
	)

/obj/shuttle_landmark/nav_requiem/nav1
	name = "Icarus Crash Site Landing Point A"
	landmark_tag = "nav_requiem_1"
	base_area = /area/requiem/ground

/obj/shuttle_landmark/nav_requiem/nav2
	name = "Icarus Crash Site Landing Point B"
	landmark_tag = "nav_requiem_2"
	base_area = /area/requiem/ground

/obj/shuttle_landmark/nav_requiem/nav3
	name = "Icarus Crash Site Landing Point C"
	landmark_tag = "nav_requiem_3"
	base_area = /area/requiem/ground

/turf/simulated/floor/reinforced/airless
	map_airless = TRUE
