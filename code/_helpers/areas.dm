/*
	List generation helpers
*/
/proc/get_filtered_areas(var/list/predicates)
	. = list()
	if(!predicates || !predicates.len)
		return
	for(var/area/A)
		if(!A.z)
			continue
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

/proc/is_not_space(var/area/A)
	. = !istype(A,/area/space)
