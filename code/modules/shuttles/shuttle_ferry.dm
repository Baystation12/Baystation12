

/datum/shuttle/autodock/ferry
	var/location = 0	//0 = at area_station, 1 = at area_offsite
	var/direction = 0	//0 = going to station, 1 = going to offsite.

	var/obj/effect/shuttle_landmark/waypoint_station  //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.
	var/obj/effect/shuttle_landmark/waypoint_offsite  //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.

	category = /datum/shuttle/autodock/ferry

/datum/shuttle/autodock/ferry/New(_name)
	if(waypoint_station)
		waypoint_station = SSshuttle.get_landmark(waypoint_station)
	if(waypoint_offsite)
		waypoint_offsite = SSshuttle.get_landmark(waypoint_offsite)

	..(_name, get_location_waypoint(location))

	next_location = get_location_waypoint(!location)

//Gets the shuttle landmark associated with the given location (defaults to current location)
/datum/shuttle/autodock/ferry/proc/get_location_waypoint(location_id = null)
	if (isnull(location_id))
		location_id = location

	if (!location_id)
		return waypoint_station
	return waypoint_offsite

/datum/shuttle/autodock/ferry/short_jump(var/destination)
	direction = !location
	..()

/datum/shuttle/autodock/ferry/long_jump(var/destination, var/obj/effect/shuttle_landmark/interim, var/travel_time)
	direction = !location
	..()

/datum/shuttle/autodock/ferry/shuttle_moved()
	..()

	if (next_location == waypoint_station) location = 0
	if (next_location == waypoint_offsite) location = 1

/datum/shuttle/autodock/ferry/process_arrived()
	..()
	next_location = get_location_waypoint(!location)
