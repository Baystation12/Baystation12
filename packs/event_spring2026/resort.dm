#include "event_items.dm"
#include "resort.dmm"

/datum/map_template/ruin/resort
	name = "Beach Resort"
	id = "awaysite_beach_resort"
	description = "A "
	suffixes = list("packs/event_spring2026/resort.dmm")
	area_usage_test_exempted_root_areas = list(/area/hotel)

// Area shenanigans

	apc_test_exempt_areas = list(
		/area/beach = NO_SCRUBBER|NO_VENT,
	)

/area/map_template/resort
	icon_state = "shuttlegrn"
	always_unpowered = FALSE
	requires_power = FALSE

// Landing Markers

// /obj/shuttle_landmark/hotel/one
// 	name = Resort East"
// 	landmark_tag = "nav_cinnamon_hotel_1"

// /obj/shuttle_landmark/hotel/two
// 	name = Resort West"
// 	landmark_tag = "nav_cinnamon_hotel_2"

// /obj/shuttle_landmark/hotel/three
// 	name = Resort South"
// 	landmark_tag = "nav_cinnamon_hotel_3"
