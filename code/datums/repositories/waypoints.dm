/var/repository/waypoint/waypoint_repository = new()

/repository/waypoint
	var/list/waypoints = list()

/repository/waypoint/proc/initialize_waypoints()
	var/list/landmarks = list()
	var/list/docking_controllers = list()
	for(var/wp_type in subtypesof(/datum/shuttle_waypoint))
		var/datum/shuttle_waypoint/WP = wp_type
		if(initial(WP.id))
			WP = new wp_type
			landmarks |= WP.find_landmarks()
			if(WP.docking_controller)
				docking_controllers |= WP.docking_controller.master

	//remove all landmarks once initialization is complete
	for(var/obj/effect/shuttle_landmark/landmark in landmarks)
		qdel(landmark)

	//remove all docking controller tags
	for(var/obj/machinery/embedded_controller/C in docking_controllers)
		C.tag = null
