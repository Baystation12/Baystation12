/datum/unit_test/shuttle
	name = "SHUTTLE template"
	async = 0

/datum/unit_test/shuttle/shuttles_shall_have_a_name
	name = "SHUTTLE - Shuttles shall have a name"

/datum/unit_test/shuttle/shuttles_shall_have_a_name/start_test()
	var/failed_shuttles = 0
	for(var/datum/shuttle/shuttle in shuttle_controller.shuttles)
		if(!shuttle.name)
			failed_shuttles++

	if(failed_shuttles)
		fail("[failed_shuttles] nameless shuttle\s")
	else
		pass("All shuttles are named.")
	return 1

/datum/unit_test/shuttle/shuttles_shall_use_mapped_areas
	name = "SHUTTLE - Shuttles shall use mapped areas"

/datum/unit_test/shuttle/shuttles_shall_use_mapped_areas/start_test()
	var/failed_shuttles = 0
	for(var/shuttle_name in shuttle_controller.shuttles)
		var/datum/shuttle/shuttle = shuttle_controller.shuttles[shuttle_name]
		var/failed = FALSE
		if(istype(shuttle, /datum/shuttle/ferry))
			var/datum/shuttle/ferry/f = shuttle
			if(!f.shuttle_area || !f.shuttle_area.x)
				log_bad("[f.name]: Invalid shuttle area.")

		else if(istype(shuttle, /datum/shuttle/multi_shuttle))
			var/datum/shuttle/multi_shuttle/ms = shuttle
			if(!ms.origin || !ms.origin.x)
				log_bad("[ms.name]: Invalid origin area.")
				failed = TRUE
			if(!ms.interim || !ms.interim.x)
				log_bad("[ms.name]: Invalid interim area.")
				failed = TRUE
			for(var/destination in ms.destinations)
				var/area/destination_area = ms.destinations[destination]
				if(!(destination_area && destination_area.x))
					log_bad("[ms.name] - [destination]: Invalid destination area.")
					failed = TRUE
		else
			log_bad("[shuttle_name] was of an unchecked shuttle type.")
			failed = TRUE

		if(failed)
			failed_shuttles++

	if(failed_shuttles)
		fail("Found [failed_shuttles] bad shuttle\s.")
	else
		pass("All shuttles had proper areas.")

	return 1

/datum/unit_test/shuttle/shuttles_shall_use_equally_sized_areas
	name = "SHUTTLE - Shuttles shall use equally sized areas"

/datum/unit_test/shuttle/shuttles_shall_use_equally_sized_areas/start_test()
	var/failed_shuttles = 0
	for(var/shuttle_name in shuttle_controller.shuttles)
		var/datum/shuttle/shuttle = shuttle_controller.shuttles[shuttle_name]
		var/failed = FALSE
		if(istype(shuttle, /datum/shuttle/multi_shuttle))
			var/datum/shuttle/multi_shuttle/ms = shuttle
			if(is_bad_area_size(ms, ms.origin, ms.interim))
				failed = TRUE
			for(var/destination in ms.destinations)
				if(is_bad_area_size(ms, ms.origin, ms.destinations[destination]))
					failed = TRUE
		if(failed)
			failed_shuttles++

	if(failed_shuttles)
		fail("Found [failed_shuttles] bad shuttle\s.")
	else
		pass("All shuttles had proper area sizes.")

	return 1

/datum/unit_test/shuttle/shuttles_shall_use_unique_areas
	name = "SHUTTLE - Shuttles shall use unique areas"

#define SHUTTLE_NAME_AID(shuttle) "[shuttle] ([shuttle.type])"

/datum/unit_test/shuttle/shuttles_shall_use_unique_areas/start_test()
	var/list/shuttle_areas = list()
	for(var/shuttle_name in shuttle_controller.shuttles)
		var/datum/shuttle/shuttle = shuttle_controller.shuttles[shuttle_name]
		if(istype(shuttle, /datum/shuttle/ferry))
			var/datum/shuttle/ferry/f = shuttle
			group_by(shuttle_areas, f.shuttle_area.type, SHUTTLE_NAME_AID(f))
			//TODO sector_shuttles
		else if(istype(shuttle, /datum/shuttle/multi_shuttle))
			var/datum/shuttle/multi_shuttle/ms = shuttle
			group_by(shuttle_areas, ms.origin.type, SHUTTLE_NAME_AID(ms))
			group_by(shuttle_areas, ms.interim.type, SHUTTLE_NAME_AID(ms))
			for(var/destination in ms.destinations)
				var/area/dest_area = ms.destinations[destination]
				group_by(shuttle_areas, dest_area.type, SHUTTLE_NAME_AID(ms))

	var/number_of_issues = number_of_issues(shuttle_areas, "Shuttle Areas")
	if(number_of_issues)
		fail("[number_of_issues] duplicate shuttle area re-use\s exist.")
	else
		pass("All used shuttle areas are unique.")
	return 1

#undef SHUTTLE_NAME_AID

/datum/unit_test/shuttle/shuttles_shall_use_equally_sized_areas/proc/is_bad_area_size(var/shuttle, var/area/main_area, var/area/checked_area)
	var/main_size = 0
	var/checked_size = 0
	for(var/turf/T in main_area)
		main_size++
	for(var/turf/T in checked_area)
		checked_size++
	if(main_size == checked_size)
		return FALSE

	log_bad("[shuttle]: [main_area.type] had a size of [main_size] but [checked_area.type] had a size of [checked_size].")
	return TRUE
