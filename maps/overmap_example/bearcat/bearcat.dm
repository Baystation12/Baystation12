/obj/effect/overmap/ship/bearcat
	name = "CSV Bearcat"
	color = "#00FFFF"
	start_x = 4
	start_y = 4
	base = 1

	generic_waypoints = list("outgoing", "incoming")
	restricted_waypoints = list(
		//no real reason to have this restricted, just for example purposes
		"Exploration Pod" = list("bearcat_below")
	)

/obj/machinery/computer/shuttle_control/explore/bearcat
	name = "exploration shuttle console"
	shuttle_tag = "Exploration"

/datum/shuttle/autodock/overmap/exploration
	name = "Exploration"
	shuttle_area = /area/ship/scrap/shuttle/outgoing
	current_waypoint = "outgoing"
	//transit_direction = NORTH

/datum/shuttle_waypoint/overmap/docking_arm_port
	name = "Bearcat Port-side Docking Arm"
	id = "outgoing"
	landmark_tag = "nav_outgoing"

/datum/shuttle_waypoint/overmap/docking_arm_starboard
	name = "Bearcat Starboard-side Docking Arm"
	id = "incoming"
	landmark_tag = "nav_incoming"

/datum/shuttle_waypoint/overmap/below_deck
	name = "Near CSV Bearcat"
	id = "bearcat_below"
	landmark_tag = "nav_pod"
