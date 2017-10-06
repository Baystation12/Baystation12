#define waypoint_sector(waypoint) map_sectors["[waypoint.z]"]

/datum/shuttle/autodock/overmap
	warmup_time = 10

	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.

	category = /datum/shuttle/autodock/overmap

/datum/shuttle/autodock/overmap/proc/can_go()
	if(!next_location)
		return FALSE
	if(moving_status == SHUTTLE_INTRANSIT)
		return FALSE //already going somewhere, current_location may be an intransit location instead of in a sector
	return get_dist(waypoint_sector(current_location), waypoint_sector(next_location)) <= range

/datum/shuttle/autodock/overmap/can_launch()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/can_force()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/proc/set_destination(var/obj/effect/shuttle_landmark/A)
	if(A != current_location)
		next_location = A

/datum/shuttle/autodock/overmap/proc/get_possible_destinations()
	var/list/res = list()
	for (var/obj/effect/overmap/S in range(waypoint_sector(current_location), range))
		for(var/obj/effect/shuttle_landmark/LZ in S.get_waypoints(src.name))
			if(LZ.is_valid(src))
				res["[S.name] - [LZ.name]"] = LZ
	return res

/datum/shuttle/autodock/overmap/proc/get_location_name()
	if(moving_status == SHUTTLE_INTRANSIT)
		return "In transit"
	return "[waypoint_sector(current_location)] - [current_location]"

/datum/shuttle/autodock/overmap/proc/get_destination_name()
	if(!next_location)
		return "None"
	return "[waypoint_sector(next_location)] - [next_location]"
