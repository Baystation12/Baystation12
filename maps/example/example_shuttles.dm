/obj/effect/shuttle_landmark/lower_level
	name = "Lower Level Dock"
	landmark_tag = "nav_example_station"
	docking_target = "lower_level_dock"
	docking_controller = "example_shuttle_starboard"

/obj/effect/shuttle_landmark/upper_level
	name = "Upper Level Dock"
	landmark_tag = "nav_example_offsite"
	docking_target = "upper_level_dock"
	docking_controller = "example_shuttle_port"

/datum/shuttle/autodock/ferry/example
	name = "Example"
	shuttle_area = /area/shuttle/escape
	warmup_time = 10

	location = 0
	waypoint_station = "nav_example_station"
	waypoint_offsite = "nav_example_offsite"