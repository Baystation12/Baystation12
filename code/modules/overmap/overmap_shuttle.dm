var/list/sector_shuttles = list()

#define waypoint_sector(waypoint) map_sectors["[waypoint.z]"]

/datum/shuttle/autodock/overmap
	warmup_time = 10

	var/obj/effect/shuttle_landmark/current_waypoint
	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.

	category = /datum/shuttle/autodock/overmap

/datum/shuttle/autodock/overmap/New(_name)
	current_waypoint = locate(current_waypoint)
	if(!istype(current_waypoint))
		CRASH("Shuttle '[name]' could not find its starting waypoint.")

	..(_name, current_waypoint)

	sector_shuttles += src

/datum/shuttle/autodock/overmap/Destroy()
	sector_shuttles -= src
	current_waypoint = null
	return ..()

/datum/shuttle/autodock/overmap/process_arrived()
	current_waypoint = next_waypoint
	..()

/datum/shuttle/autodock/overmap/proc/is_valid_landing(var/obj/effect/shuttle_landmark/A)
	if(A == current_waypoint)
		return 0 //already there
	if(!A.free())
		return 0
	return 1

/datum/shuttle/autodock/overmap/proc/can_go()
	if(!next_waypoint)
		return FALSE
	return get_dist(waypoint_sector(current_waypoint), waypoint_sector(next_waypoint)) <= range

/datum/shuttle/autodock/overmap/can_launch()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/can_force()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/proc/set_destination(var/obj/effect/shuttle_landmark/A)
	next_waypoint = A

/datum/shuttle/autodock/overmap/proc/get_possible_destinations()
	var/list/res = list()
	for (var/obj/effect/overmap/S in range(waypoint_sector(current_waypoint), range))
		for(var/obj/effect/shuttle_landmark/LZ in S.get_waypoints(src.name))
			if(is_valid_landing(LZ))
				res["[S.name] - [LZ.name]"] = LZ
	return res

/datum/shuttle/autodock/overmap/proc/get_location_name()
	return "[waypoint_sector(current_waypoint)] - [current_waypoint.name]"

/datum/shuttle/autodock/overmap/proc/get_destination_name()
	if(!next_waypoint)
		return "None"
	return "[waypoint_sector(next_waypoint)] - [next_waypoint.name]"
