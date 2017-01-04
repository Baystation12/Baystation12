var/list/sector_shuttles = list()

/datum/shuttle/ferry/overmap
	warmup_time = 10
	location = 0
	category = /datum/shuttle/ferry/overmap
	var/obj/effect/overmap/current_location
	var/obj/effect/overmap/destination //current destination sector
	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.

/datum/shuttle/ferry/overmap/New(_name)
	..(_name)
	if(!landmark_station)
		log_debug("<span class='danger>[name]: has no home landmark</span>")
		CRASH("Shuttle \"[name]\" has no home landmark.")
	set_destination_landmark(landmark_station)
	update_location()
	sector_shuttles += src

/datum/shuttle/ferry/overmap/move(var/area/origin,var/area/destination)
	..()
	update_location()

/datum/shuttle/ferry/overmap/proc/is_valid_landing(obj/effect/shuttle_nav/A)
	if(!istype(A))
		return 0
	if(A == get_location_landmark())
		return 0 //already there
	if(!A.free())
		return 0
	return 1

/datum/shuttle/ferry/overmap/proc/can_go()
	if(!destination)
		return
	update_location()
	if(!current_location)
		log_error("[name] is not on overmap-friendly zlevel.")
		return
	return get_dist(current_location, destination) <= range

/datum/shuttle/ferry/overmap/proc/update_location()
	current_location = map_sectors["[shuttle_area.z]"]

/datum/shuttle/ferry/overmap/proc/set_destination_landmark(obj/effect/shuttle_nav/A)
	if(!A)
		return
	destination = map_sectors["[A.z]"]

	//TODO, factor out the code common to overmap shuttles and ferry shuttles
	//so that we don't have to do stuff like this.
	if(location)
		landmark_offsite = get_location_landmark()
		landmark_station = A
	else
		landmark_station = get_location_landmark()
		landmark_offsite = A

/datum/shuttle/ferry/overmap/proc/get_possible_destinations()
	var/list/res = list()
	update_location()
	for (var/obj/effect/overmap/S in range(current_location, range))
		var/i = 1
		for(var/obj/effect/shuttle_nav/LZ in S.landing_spots)
			if(is_valid_landing(LZ))
				res["([i++]) [S.name] - [LZ.name]"] = LZ
	return res

//TODO nav landmark names
/datum/shuttle/ferry/overmap/proc/get_location_name()
	update_location()
	var/obj/effect/shuttle_nav/A = get_location_landmark()
	return "[location] - [A.name]"

/datum/shuttle/ferry/overmap/proc/get_destination_name()
	var/obj/effect/shuttle_nav/A = get_location_landmark(!location)
	return destination ? "[destination] - [A.name]": "None"