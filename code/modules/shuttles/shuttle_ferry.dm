

/datum/shuttle/autodock/ferry
	var/location = 0	//0 = at area_station, 1 = at area_offsite
	var/direction = 0	//0 = going to station, 1 = going to offsite.

	var/obj/effect/shuttle_landmark/landmark_station
	var/obj/effect/shuttle_landmark/landmark_offsite
	var/dock_target_station
	var/dock_target_offsite

	category = /datum/shuttle/autodock/ferry

	//Temporary
	var/docking_controller_tag //TODO replace with nav datum
	var/datum/computer/file/embedded_program/docking/docking_controller

/datum/shuttle/autodock/ferry/New(_name)
	if(landmark_station)
		landmark_station = locate(landmark_station)
	if(landmark_offsite)
		landmark_offsite = locate(landmark_offsite)

	..(_name, get_location_landmark(location))

	get_docking_controller()

//Gets the shuttle landmark associated with the given location (defaults to current location)
/datum/shuttle/autodock/ferry/proc/get_location_landmark(location_id = null)
	if (isnull(location_id))
		location_id = location

	if (!location_id)
		return landmark_station
	return landmark_offsite

/datum/shuttle/autodock/ferry/short_jump(var/destination)
	direction = !location
	..()

/datum/shuttle/autodock/ferry/long_jump(var/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	direction = !location
	..()

/datum/shuttle/autodock/ferry/move(var/atom/destination)
	..()

	if (destination == landmark_station) location = 0
	if (destination == landmark_offsite) location = 1
	//if (destination == landmark_transition) //do nothing, retain the previous location until the long_jump completes

/datum/shuttle/autodock/ferry/get_destination()
	return get_location_landmark(!location) //go to where we are not

/datum/shuttle/autodock/ferry/get_docking_controller()
	. = locate(docking_controller_tag)
	docking_controller = . //Temporary

/datum/shuttle/autodock/ferry/get_dock_target()
	if (!location)	//station
		return dock_target_station
	return dock_target_offsite
