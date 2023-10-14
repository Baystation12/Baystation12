/obj/overmap/visitable/sector/empty
	name = "empty sector"
	desc = "An empty sector devoid of anything of interest."
	icon_state = "event"
	hide_from_reports = TRUE
	initial_generic_waypoints = list(
		"nav_empty_1",
		"nav_empty_2",
		"nav_empty_3",
		"nav_empty_4",
		"nav_empty_5",
		"nav_empty_6",
		"nav_empty_7"
	)


/datum/map_template/ruin/empty
	name = "Empty"
	id = "empty_sector"
	description = "An empty sector devoid of anthything interesting."
	suffixes = list("maps/event/empty/empty.dmm")
	apc_test_exempt_areas = list(
		/area/empty_tp_target = NO_SCRUBBER|NO_VENT|NO_APC
	)


/area/empty_tp_target
	name = "Empty Sector"

/obj/shuttle_landmark/empty/nav1
	name = "Away Landing zone #1"
	landmark_tag = "nav_empty_1"

/obj/shuttle_landmark/empty/nav2
	name = "Away Landing zone #2"
	landmark_tag = "nav_empty_2"

/obj/shuttle_landmark/empty/nav3
	name = "Away Landing zone #3"
	landmark_tag = "nav_empty_3"

/obj/shuttle_landmark/empty/nav4
	name = "Away Landing zone #4"
	landmark_tag = "nav_empty_4"

/obj/shuttle_landmark/empty/nav5
	name = "Away Landing zone #5"
	landmark_tag = "nav_empty_5"

/obj/shuttle_landmark/empty/nav6
	name = "Away Landing zone #6"
	landmark_tag = "nav_empty_6"

/obj/shuttle_landmark/empty/nav7
	name = "Away Landing zone #7"
	landmark_tag = "nav_empty_7"
