/obj/effect/overmap/sector/test1
	name = "Test Sector #1"
	color = "#00FF00"
	start_x = 8
	start_y = 8

	generic_waypoints = list(
		"nav_ingoing1",
		"nav_ingoing3",
		"nav_ingoing4",
	)

/obj/effect/overmap/sector/test2
	name = "Test Sector #2"
	color = "#FF0000"
	start_x = 6
	start_y = 8

	generic_waypoints = list(
		"nav_ingoing2",
		"nav_abandoned_pod",
	)


/obj/machinery/computer/shuttle_control/explore/test2
	name = "abandoned pod console"
	shuttle_tag = "Exploration Pod"

/datum/shuttle/autodock/overmap/abandoned_pod
	name = "Exploration Pod"
	shuttle_area = /area/sector/shuttle/outgoing2
	dock_target = "exploration_pod"
	current_location = "nav_abandoned_pod"

/area/sector/shuttle/outgoing2
  name = "Exploration Pod"

/area/sector/shuttle
	name = "\improper Entry Point"
	icon_state = "tcomsatcham"
	requires_power = 0
	luminosity = 1
	dynamic_lighting = 0

/obj/effect/shuttle_landmark/ingoing1
	name = "Navpoint #1"
	landmark_tag = "nav_ingoing1"

/obj/effect/shuttle_landmark/ingoing2
	name = "Navpoint #2"
	landmark_tag = "nav_ingoing2"

/obj/effect/shuttle_landmark/ingoing3
	name = "Navpoint #3"
	landmark_tag = "nav_ingoing3"

/obj/effect/shuttle_landmark/ingoing4
	name = "Navpoint #4"
	landmark_tag = "nav_ingoing4"

/obj/effect/shuttle_landmark/pod
	name = "Navpoint #5"
	landmark_tag = "nav_abandoned_pod"