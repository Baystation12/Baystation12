/datum/unit_test/areas_shall_be_coherent
	name = "AREA: Areas shall be coherent"

/datum/unit_test/areas_shall_be_coherent/start_test()
	var/incoherent_areas = 0
	for(var/area/A)
		if(!A.contents.len)
			continue
		if(A.type in GLOB.using_map.area_coherency_test_exempt_areas)
			continue
		var/list/area_turfs = list()
		for(var/turf/T in A)
			area_turfs += T

		var/actual_number_of_sub_areas = 0
		var/expected_number_of_sub_areas = (A.type in GLOB.using_map.area_coherency_test_subarea_count) ? GLOB.using_map.area_coherency_test_subarea_count[A.type] : 1
		do
			actual_number_of_sub_areas++
			area_turfs -= get_turfs_fill(area_turfs[1])
		while(area_turfs.len)

		if(actual_number_of_sub_areas != expected_number_of_sub_areas)
			incoherent_areas++
			log_bad("[log_info_line(A)] is incoherent. Expected [expected_number_of_sub_areas] subarea\s, fill gave [actual_number_of_sub_areas].")

	if(incoherent_areas)
		fail("Found [incoherent_areas] incoherent area\s.")
	else
		pass("All areas are coherent.")

	return 1

#define SHOULD_CHECK_TURF(turf_to_check) if(turf_to_check && turf_to_check.loc == T.loc && !(turf_to_check in .)) { turfs_to_check.Push(turf_to_check) }
/datum/unit_test/areas_shall_be_coherent/proc/get_turfs_fill(var/turf/origin)
	. = list()
	var/datum/stack/turfs_to_check = new()
	turfs_to_check.Push(origin)
	while(!turfs_to_check.is_empty())
		var/turf/T = turfs_to_check.Pop()
		. |= T
		var/turf/neighbour
		for(var/direction in GLOB.cardinal)
			neighbour = get_step(T, direction)
			SHOULD_CHECK_TURF(neighbour)
#ifdef MULTIZAS
		neighbour = GetAbove(T)
		SHOULD_CHECK_TURF(neighbour)
		neighbour = GetBelow(T)
		SHOULD_CHECK_TURF(neighbour)
#endif

#undef SHOULD_CHECK_TURF

/datum/unit_test/areas_shall_be_pure
	name = "AREA: Areas shall be pure"

/datum/unit_test/areas_shall_be_pure/start_test()
	var/impure_areas = 0
	for(var/area/A)
		if(!A.contents.len)
			continue
		if(A.type in GLOB.using_map.area_purity_test_exempt_areas)
			continue
		if(A.name != initial(A.name))
			log_bad("[log_info_line(A)] has an edited name.")
			impure_areas++

	if(impure_areas)
		fail("Found [impure_areas] impure area\s.")
	else
		pass("All areas are pure.")

	return 1

/datum/unit_test/areas_shall_be_used
	name = "AREA: Areas shall be used"

/datum/unit_test/areas_shall_be_used/start_test()
	var/unused_areas = 0
	for(var/area_type in subtypesof(/area))
		if(area_type in GLOB.using_map.area_usage_test_exempted_areas)
			continue
		if(is_path_in_list(area_type, GLOB.using_map.area_usage_test_exempted_root_areas))
			continue
		var/area/located_area = locate(area_type)
		if(located_area && !located_area.z)
			log_bad("[log_info_line(located_area)] is unused.")
			unused_areas++

	if(unused_areas)
		fail("Found [unused_areas] unused area\s.")
	else
		pass("All areas are used.")
	return 1