/obj/effect/overmap/ship/bearcat
	name = "CSV Bearcat"
	color = "#00FFFF"
	landing_spots = list("nav_outgoing", "nav_pod", "nav_incoming")
	start_x = 4
	start_y = 4
	base = 1

/obj/machinery/computer/shuttle_control/explore/bearcat
	name = "exploration shuttle console"
	shuttle_tag = "Exploration"

/datum/shuttle/autodock/overmap/exploration
	name = "Exploration"
	shuttle_area = /area/ship/scrap/shuttle/outgoing
	current_location = "nav_outgoing"
	//transit_direction = NORTH