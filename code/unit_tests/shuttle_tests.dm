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
			if(!f.area_offsite || !f.area_offsite.x)
				log_bad("[f.name]: Invalid offsite area.")
				failed = TRUE
			if(!f.area_station || !f.area_station.x)
				log_bad("[f.name]: Invalid station area.")
				failed = TRUE
			if(initial(f.area_transition) && (!f.area_transition || f.area_transition == 0))
				log_bad("[f.name]: Invalid area transition.")
				failed = TRUE

		else if(istype(shuttle, /datum/shuttle/multi_shuttle))
			var/datum/shuttle/multi_shuttle/ms = shuttle
			if(!ms.origin || !ms.origin.x)
				log_bad("[ms.name]: Invalid origin area.")
				failed = TRUE
			if(!ms.interim || !ms.interim.x)
				log_bad("[ms.name]: Invalid interim area.")
				failed = TRUE
			for(var/destination in ms.destinations)
				if(!ms.destinations[destination])
					log_bad("[ms.name] - [destination]: Invalid destination area.")
					failed = TRUE
		else
			log_bad("[shuttle_name] was of an unchecked shuttle type.")
			failed = TRUE

		if(failed)
			failed_shuttles++

	if(failed_shuttles)
		pass("Found [failed_shuttles] bad shuttle\s.")
	else
		pass("All shuttles had proper areas.")

	return 1
