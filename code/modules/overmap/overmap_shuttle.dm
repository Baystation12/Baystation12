var/list/sector_shuttles = list()

/datum/shuttle/autodock/overmap
	warmup_time = 10

	var/obj/effect/shuttle_landmark/destination_landmark

	category = /datum/shuttle/autodock/overmap
	var/obj/effect/overmap/current_sector
	var/obj/effect/overmap/destination_sector //current destination sector
	var/range = 0	//how many overmap tiles can shuttle go, for picking destinations and returning.

/datum/shuttle/autodock/overmap/New(_name)
	..(_name)

	update_sector()
	sector_shuttles += src

/datum/shuttle/autodock/overmap/move(var/atom/destination)
	..()
	update_sector()

/datum/shuttle/autodock/overmap/proc/is_valid_landing(obj/effect/shuttle_landmark/A)
	if(!istype(A))
		return 0
	if(A == current_location)
		return 0 //already there
	if(!A.free())
		return 0
	return 1

/datum/shuttle/autodock/overmap/proc/can_go()
	if(!destination_sector)
		return
	update_sector()
	if(!current_sector)
		log_error("[name] is not on overmap-friendly zlevel.")
		return
	return get_dist(current_sector, destination_sector) <= range

/datum/shuttle/autodock/overmap/proc/update_sector()
	current_sector = map_sectors["[shuttle_area.z]"]

/datum/shuttle/autodock/overmap/proc/set_destination_landmark(obj/effect/shuttle_landmark/A)
	if(!A) return

	destination_landmark = A
	destination_sector = map_sectors["[A.z]"]

/datum/shuttle/autodock/overmap/proc/get_possible_destinations()
	var/list/res = list()
	update_sector()
	for (var/obj/effect/overmap/S in range(current_sector, range))
		var/i = 1
		for(var/obj/effect/shuttle_landmark/LZ in S.landing_spots)
			if(is_valid_landing(LZ))
				res["([i++]) [S.name] - [LZ.name]"] = LZ
	return res

//TODO nav landmark names
/datum/shuttle/autodock/overmap/proc/get_location_name()
	update_sector()
	return "[current_sector] - [current_location.name]"

/datum/shuttle/autodock/overmap/proc/get_destination_name()
	return destination_sector ? "[destination_sector] - [destination_landmark.name]": "None"

/datum/shuttle/autodock/overmap/get_destination()
	return destination_landmark

/datum/shuttle/autodock/overmap/get_docking_controller()
	return null //TODO implement nav datum

/datum/shuttle/autodock/overmap/get_dock_target()
	return null //TODO implement nav datum