var/list/sector_shuttles = list()

/datum/shuttle_waypoint/overmap
	var/obj/effect/overmap/sector

/datum/shuttle_waypoint/overmap/find_landmarks()
	. = ..()
	sector = map_sectors["[landmark_turf.z]"]
	if(!sector)
		CRASH("Overmap shuttle waypoint '[id]' did not have a sector.")

/datum/shuttle/autodock/overmap
	warmup_time = 10

	var/datum/shuttle_waypoint/overmap/current_waypoint
	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.

	category = /datum/shuttle/autodock/overmap

/datum/shuttle/autodock/overmap/New(_name)
	current_waypoint = waypoint_repository.waypoints[current_waypoint]
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

/datum/shuttle/autodock/overmap/proc/is_valid_landing(var/datum/shuttle_waypoint/overmap/A)
	if(A == current_waypoint)
		return 0 //already there
	if(!A.free())
		return 0
	return 1

/datum/shuttle/autodock/overmap/proc/can_go()
	var/datum/shuttle_waypoint/overmap/next = next_waypoint
	if(!istype(next))
		return FALSE
	return get_dist(current_waypoint.sector, next.sector) <= range

/datum/shuttle/autodock/overmap/can_launch()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/can_force()
	return ..() && can_go()

/datum/shuttle/autodock/overmap/proc/set_destination(var/datum/shuttle_waypoint/overmap/A)
	next_waypoint = A

/datum/shuttle/autodock/overmap/proc/get_possible_destinations()
	var/list/res = list() //TOOD get a list of waypoints instead
	for (var/obj/effect/overmap/S in range(current_waypoint.sector, range))
		for(var/datum/shuttle_waypoint/overmap/LZ in S.get_waypoints(src.name))
			if(is_valid_landing(LZ))
				res["[S.name] - [LZ.name]"] = LZ
	return res

//TODO nav landmark names
/datum/shuttle/autodock/overmap/proc/get_location_name()
	return "[current_sector] - [current_waypoint.name]"

/datum/shuttle/autodock/overmap/proc/get_destination_name()
	var/datum/shuttle_waypoint/overmap/next = next_waypoint
	if(!istype(next))
		return "None"
	return "[next.sector] - [next.name]"
