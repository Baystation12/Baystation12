/obj/effect/overmap/ship/bearcat
	name = "FTV Bearcat"
	color = "#00ffff"
	start_x = 4
	start_y = 4
	sector_flags = OVERMAP_SECTOR_KNOWN|OVERMAP_SECTOR_IN_SPACE|OVERMAP_SECTOR_BASE
	vessel_mass = 5000
	max_speed = 1/(2 SECONDS)
	burn_delay = 2 SECONDS

	initial_generic_waypoints = list("nav_bearcat_below_bow", "nav_bearcat_below_starboardastern", "nav_bearcat_port_dock_shuttle")
	initial_restricted_waypoints = list(
		"Exploration Pod" = list("nav_bearcat_starboard_dock_pod"), //pod can only dock starboard-side, b/c there's only one door.
	)