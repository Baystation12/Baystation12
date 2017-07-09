/*
	List generation helpers
*/
/proc/get_filtered_areas(var/list/predicates = list(/proc/is_area_with_turf))
	. = list()
	if(!predicates)
		return
	if(!islist(predicates))
		predicates = list(predicates)
	for(var/area/A)
		if(all_predicates_true(list(A), predicates))
			. += A

/proc/get_area_turfs(var/area/A, var/list/predicates)
	. = new/list()
	A = istype(A) ? A : locate(A)
	if(!A)
		return
	for(var/turf/T in A.contents)
		if(!predicates || all_predicates_true(list(T), predicates))
			. += T

/proc/get_subarea_turfs(var/area/A, var/list/predicates)
	. = new/list()
	A = istype(A) ? A.type : A
	if(!A)
		return
	for(var/sub_area_type in typesof(A))
		var/area/sub_area = locate(sub_area_type)
		for(var/turf/T in sub_area.contents)
			if(!predicates || all_predicates_true(list(T), predicates))
				. += T

/proc/group_areas_by_name(var/list/predicates)
	. = list()
	for(var/area/A in get_filtered_areas(predicates))
		group_by(., A.name, A)

/proc/group_areas_by_z_level(var/list/predicates)
	. = list()
	for(var/area/A in get_filtered_areas(predicates))
		group_by(., num2text(A.z), A)

/*
	Pick helpers
*/
/proc/pick_subarea_turf(var/areatype, var/list/predicates)
	var/list/turfs = get_subarea_turfs(areatype, predicates)
	if(turfs && turfs.len)
		return pick(turfs)

/proc/pick_area_turf(var/areatype, var/list/predicates)
	var/list/turfs = get_area_turfs(areatype, predicates)
	if(turfs && turfs.len)
		return pick(turfs)

/proc/pick_area(var/list/predicates)
	var/list/areas = get_filtered_areas(predicates)
	if(areas && areas.len)
		. = pick(areas)

/proc/pick_area_and_turf(var/list/area_predicates, var/list/turf_predicates)
	var/area/A = pick_area(area_predicates)
	if(!A)
		return
	return pick_area_turf(A, turf_predicates)

/*
	Predicate Helpers
*/
/proc/is_station_area(var/area/A)
	. = isStationLevel(A.z)

/proc/is_contact_area(var/area/A)
	. = isContactLevel(A.z)

/proc/is_player_area(var/area/A)
	. = isPlayerLevel(A.z)

/proc/is_not_space_area(var/area/A)
	. = !istype(A,/area/space)

/proc/is_not_shuttle_area(var/area/A)
	. = !istype(A,/area/shuttle)

/proc/is_area_with_turf(var/area/A)
	. = isnum(A.x)

/proc/is_area_without_turf(var/area/A)
	. = !is_area_with_turf(A)

/proc/is_coherent_area(var/area/A)
	return !is_type_in_list(A, GLOB.using_map.area_coherency_test_exempt_areas)

/var/list/is_station_but_not_space_or_shuttle_area = list(/proc/is_station_area, /proc/is_not_space_area, /proc/is_not_shuttle_area)

/var/list/is_contact_but_not_space_or_shuttle_area = list(/proc/is_contact_area, /proc/is_not_space_area, /proc/is_not_shuttle_area)

/var/list/is_player_but_not_space_or_shuttle_area = list(/proc/is_player_area, /proc/is_not_space_area, /proc/is_not_shuttle_area)


/*
	Misc Helpers
*/
#define teleportlocs area_repository.get_areas_by_name_and_coords(is_player_but_not_space_or_shuttle_area)
#define stationlocs area_repository.get_areas_by_name(is_player_but_not_space_or_shuttle_area)

