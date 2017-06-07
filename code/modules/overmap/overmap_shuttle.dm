var/list/sector_shuttles = list()

/datum/shuttle/ferry/overmap
	warmup_time = 10
	category = /datum/shuttle/ferry/overmap
	var/list/shuttle_size   // x y dimensions for shuttle
	var/obj/effect/overmap/current_location
	var/obj/effect/overmap/destination //current destination sector
	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.

/datum/shuttle/ferry/overmap/New(_name, shuttle_area, s_range)
	..(_name)
	area_station = shuttle_area
	set_destination_area(shuttle_area)
	range = s_range
	update_location()
	shuttle_size = area_station.get_dimensions()
	sector_shuttles += src

/datum/shuttle/ferry/overmap/move(var/area/origin,var/area/destination)
	..()
	update_location()

/datum/shuttle/ferry/overmap/proc/is_valid_landing(area/A)
	if(!istype(A))
		return 0
	if(!A.free())
		return 0
	var/locked = A.is_shuttle_locked()
	if(locked)
		if(locked != name)
			return 0
	var/lz_size = A.get_dimensions()
	if(lz_size["x"] >= shuttle_size["x"] && lz_size["y"] >= shuttle_size["y"])
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
	current_location = map_sectors["[location ? area_offsite.z : area_station.z]"]

/datum/shuttle/ferry/overmap/proc/set_destination_area(area/A)
	if(!A)
		return
	destination = map_sectors["[A.z]"]
	if(location)
		area_offsite = get_location_area(location)
		area_station = A
	else
		area_station = get_location_area(location)
		area_offsite = A

/datum/shuttle/ferry/overmap/proc/get_possible_destinations()
	var/list/res = list()
	update_location()
	for (var/obj/effect/overmap/S in range(current_location, range))
		for(var/A in S.landing_areas)
			var/area/LZ = locate(A)
			if(is_valid_landing(LZ))
				res["[S.name] - [LZ.name]"] = LZ
	return res

/datum/shuttle/ferry/overmap/proc/get_location_name()
	update_location()
	var/area/A = get_location_area(location)
	return "[location] - [A.name]"

/datum/shuttle/ferry/overmap/proc/get_destination_name()
	var/area/A = get_location_area(!location)
	return destination ? "[destination] - [A.name]": "None"