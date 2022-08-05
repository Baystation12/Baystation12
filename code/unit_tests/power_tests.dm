/datum/unit_test/roundstart_cable_connectivity
	name = "POWER: Roundstart Cables that are Connected Share Powernets"

/datum/unit_test/roundstart_cable_connectivity/proc/find_connected_neighbours(var/obj/structure/cable/C)
	. = list()
	if(C.d1 != 0)
		. += get_connected_neighbours(C, C.d1)
	if(C.d2 != 0)
		. += get_connected_neighbours(C, C.d2)

/datum/unit_test/roundstart_cable_connectivity/proc/get_connected_neighbours(var/obj/structure/cable/self, var/dir)
	var/turf/T = get_step(get_turf(self), dir)
	var/reverse = GLOB.reverse_dir[dir]

	. = list() //can have multiple connected neighbours for a dir, e.g. Y-junctions
	for(var/obj/structure/cable/other in T)
		if(other.d1 == reverse || other.d2 == reverse)
			. += other

/datum/unit_test/roundstart_cable_connectivity/start_test()
	var/failed = 0
	var/list/found_cables = list()

	//there is a cable list, but for testing purposes we search every cable in the world
	for(var/obj/structure/cable/C in world)
		if(C in found_cables)
			continue
		var/list/to_search = list(C)
		var/list/searched = list()
		while(to_search.len)
			var/obj/structure/cable/next = to_search[to_search.len]
			to_search.len--
			searched += next
			for(var/obj/structure/cable/other in get_connected_neighbours(next))
				if(other in searched)
					continue
				if(next.powernet != other.powernet)
					fail("Cable at ([next.x], [next.y], [next.z]) did not share powernet with connected neighbour at ([other.x], [other.y], [other.z])")
					failed++
				to_search += other

		found_cables += searched

	if(failed)
		fail("Found [failed] bad cables.")
	else
		pass("All connected roundstart cables have matching powernets.")

	return 1


/datum/unit_test/areas_apc_uniqueness
	name = "POWER: Each area should have at most one APC."

/datum/unit_test/areas_apc_uniqueness/start_test()
	var/failure = ""
	for(var/area/A in world)
		var/obj/machinery/power/apc/found_apc = null
		for(var/obj/machinery/power/apc/APC in A)
			if(!found_apc)
				found_apc = APC
				continue
			if(failure)
				failure = "[failure]\n"
			failure = "[failure]Duplicated APCs in area: [A.name]. #1: [log_info_line(found_apc)]  #2: [log_info_line(APC)]"

	if(failure)
		fail(failure)
	else
		pass("No areas with duplicated APCs have been found.")
	return 1

/datum/unit_test/area_power_tally_accuracy
	name = "POWER: All areas must have accurate power use values."

/datum/unit_test/area_power_tally_accuracy/start_test()
	var/failed = FALSE
	var/list/channel_names = list("equip", "light", "environ")
	for(var/area/A in world)
		var/list/old_values = list(A.used_equip, A.used_light, A.used_environ)
		A.retally_power()
		var/list/new_values = list(A.used_equip, A.used_light, A.used_environ)
		for(var/i in 1 to length(old_values))
			if(abs(old_values[i] - new_values[i]) > 1) // Round because there can in fact be roundoff error here apparently.
				failed = TRUE
				log_bad("The area [A.name] had improper power use values on the [channel_names[i]] channel: was [old_values[i]] but should be [new_values[i]].")

	if(failed)
		fail("At least one area had improper power use values")
	else
		pass("All areas had accurate power use values.")
	return 1