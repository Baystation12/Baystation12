/datum/unit_test/areas_shall_be_coherent
	name = "AREA: Areas shall be coherent"

/datum/unit_test/areas_shall_be_coherent/start_test()
	var/incoherent_areas = 0
	for(var/area/A)
		if(!A.contents.len)
			continue
		if(A.type in using_map.area_coherency_test_exempt_areas)
			continue
		var/list/area_turfs = list()
		for(var/turf/T in A)
			area_turfs += T
		var/list/filled_turfs =	get_turfs_fill(area_turfs[1])

		if(area_turfs.len != filled_turfs.len)
			incoherent_areas++
			log_bad("[A] ([A.type]) \[[A.x]-[A.y]-[A.z]\] is incoherent. Expected [area_turfs.len] turf\s, fill gave [filled_turfs.len].")

	if(incoherent_areas)
		fail("Found [incoherent_areas] incoherent area\s.")
	else
		pass("All areas were coherent.")

	return 1

/datum/unit_test/areas_shall_be_coherent/proc/get_turfs_fill(var/turf/origin)
	. = list()
	var/datum/stack/turfs_to_check = new()
	turfs_to_check.Push(origin)
	while(!turfs_to_check.is_empty())
		var/turf/T = turfs_to_check.Pop()
		. |= T
		for(var/direction in cardinal)
			var/turf/neighbour = get_step(T, direction)
			if(neighbour && neighbour.loc == T.loc && !(neighbour in .))
				turfs_to_check.Push(neighbour)

/datum/unit_test/areas_shall_be_pure
	name = "AREA: Areas shall be pure"

/datum/unit_test/areas_shall_be_pure/start_test()
	var/impure_areas = 0
	for(var/area/A)
		if(!A.contents.len)
			continue
		if(A.name != initial(A.name))
			log_bad("[A] has an edited name.")
			impure_areas++

	if(impure_areas)
		fail("Found [impure_areas] impure area\s.")
	else
		pass("All areas were pure.")

	return 1
