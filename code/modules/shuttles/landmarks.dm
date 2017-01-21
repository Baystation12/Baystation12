//making this separate from /obj/effect/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "nav point"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	unacidable = 1
	simulated = 0
	//invisibility = 101

/datum/shuttle_waypoint
	var/id = null
	var/name = "Nav Point"
	var/x_offset = 0 //so that waypoints for different shuttles can use the same landmarks
	var/y_offset = 0
	var/docking_target = null

	var/turf/landmark_turf
	var/datum/computer/file/embedded_program/docking/docking_controller

/datum/shuttle_waypoint/New()
	if(docking_controller)
		var/docking_tag = docking_controller
		var/obj/machinery/embedded_controller/C = locate(docking_tag)
		if(istype(C))
			docking_controller = C.program
		if(!istype(docking_controller))
			log_error("Could not find docking controller for shuttle waypoint '[id]', docking tag was '[docking_tag]'.")

	if(id in waypoint_repository.waypoints)
		CRASH("Waypoint repository already has a waypoint with id '[id]'.")
	waypoint_repository.waypoints[id] = src

/datum/shuttle_waypoint/proc/find_landmarks()
	var/landmark_tag = landmark_turf
	var/obj/effect/shuttle_landmark/landmark = locate(landmark_tag)
	if(landmark)
		landmark_turf = locate(landmark.x + x_offset, landmark.y + y_offset, landmark.z)
	if(!landmark_turf)
		CRASH("Could not find landmark_turf for shuttle waypoint '[id]', landmark tag was '[landmark_tag]'.")

	return landmark

/datum/shuttle_waypoint/Destroy()
	waypoint_repository.waypoints -= id
	return ..()

//Can shuttle go here without doing weird stuff?
/datum/shuttle_waypoint/proc/free()
	return TRUE 

	//TODO: scan a footprint around the landmark shaped like the shuttle area, for other shuttle areas and the edge of the map
	//Also maybe look for structural turfs with density
