/obj/effect/shuttle_landmark/lower_level
	name = "Lower Level Dock"
	landmark_tag = "nav_example_station"
	docking_controller = "lower_level_dock"

/obj/effect/shuttle_landmark/upper_level
	name = "Upper Level Dock"
	landmark_tag = "nav_example_offsite"
	special_dock_targets = list("Example" = "example_shuttle_port")
	docking_controller = "upper_level_dock"

/datum/shuttle/autodock/ferry/example
	name = "Example"
	shuttle_area = /area/shuttle/escape
	dock_target = "example_shuttle_starboard"
	warmup_time = 10

	location = 0
	waypoint_station = "nav_example_station"
	waypoint_offsite = "nav_example_offsite"