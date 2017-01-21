/datum/shuttle_waypoint/lower_level
	name = "Lower Level Dock"
	id = "lower_level"
	landmark_tag = "nav_example_station"
	docking_target = "lower_level_dock"
	docking_controller = "example_shuttle_starboard"

/datum/shuttle_waypoint/upper_level
	name = "Upper Level Dock"
	id = "upper_level"
	landmark_tag = "nav_example_offsite"
	docking_target = "upper_level_dock"
	docking_controller = "example_shuttle_port"

/datum/shuttle/autodock/ferry/example
	name = "Example"
	shuttle_area = /area/shuttle/escape
	warmup_time = 10

	location = 0
	waypoint_station = "lower_level"
	waypoint_offsite = "upper_level"