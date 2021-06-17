/datum/unit_test/generic_shuttle_landmarks_shall_not_appear_in_restricted_list
	name = "SHUTTLE: Generic shuttle landmarks shall not appear in the restricted landmark list."

/datum/unit_test/generic_shuttle_landmarks_shall_not_appear_in_restricted_list/start_test()
	var/fail = FALSE

	for(var/obj/effect/overmap/visitable/sector in world)
		var/list/failures = list()
		for(var/generic in sector.initial_generic_waypoints)
			for(var/shuttle in sector.initial_restricted_waypoints)
				if(generic == sector.initial_restricted_waypoints[shuttle])
					failures += generic
					break
			if(length(failures))
				log_bad("The sector [log_info_line(sector)] has the following generic landmarks also appearing on the restricted list: [english_list(failures)]")
				fail = TRUE

	if (fail)
		fail("Some sector landmark lists were misconfigured.")
	else
		pass("All sector landmark lists were configured properly.")
	return 1