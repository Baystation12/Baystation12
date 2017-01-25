//making this separate from /obj/effect/landmark until that mess can be dealt with
/obj/effect/shuttle_landmark
	name = "Nav Point"
	icon = 'icons/effects/effects.dmi'
	icon_state = "energynet"
	anchored = 1
	unacidable = 1
	simulated = 0
	//invisibility = 101

	var/landmark_tag
	var/docking_target = null
	var/datum/computer/file/embedded_program/docking/docking_controller

/obj/effect/shuttle_landmark/New()
	..()
	tag = landmark_tag //since tags cannot be set at compile time

/obj/effect/shuttle_landmark/initialize()
	if(docking_controller)
		var/docking_tag = docking_controller
		var/obj/machinery/embedded_controller/C = locate(docking_tag)
		if(istype(C))
			docking_controller = C.program
		if(!istype(docking_controller))
			log_error("Could not find docking controller for shuttle waypoint '[name]', docking tag was '[docking_tag]'.")

//Can shuttle go here without doing weird stuff?
/obj/effect/shuttle_landmark/proc/free(var/shuttle)
	return TRUE 

	//TODO: scan a footprint around the landmark shaped like the shuttle area, for other shuttle areas and the edge of the map
	//Also maybe look for structural turfs with density
