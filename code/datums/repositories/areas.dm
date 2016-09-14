/var/repository/area/area_repository = new()

/repository/area
	var/list/cache_data

/repository/area/New()
	cache_data = list()
	..()

/repository/area/proc/get_areas_by_name(var/list/area_predicates = /proc/is_area_with_turf)
	var/datum/cache_entry/cache_entry = cache_data[area_predicates]
	if(!cache_entry)
		cache_entry = new/datum/cache_entry
		cache_data[area_predicates] = cache_entry

	if(world.time < cache_entry.timestamp)
		return cache_entry.data

	var/list/areas_by_name = list()
	for(var/area/A in get_filtered_areas(islist(area_predicates) ? area_predicates : list(area_predicates)))
		group_by(areas_by_name, A.name, A)

	. = list()
	for(var/area_name in areas_by_name)
		var/list/areas_in_group = areas_by_name[area_name]
		var/is_singular = areas_in_group.len == 1
		for(var/i = 1 to areas_in_group.len)
			var/area/A = areas_in_group[i]
			var/turf/picked = pick_area_turf(A.type)
			if (picked)
				.[is_singular ? A.name : "[A.name] ([i])"] = A
	. = sortAssoc(.)

	cache_entry.timestamp = world.time + 1 MINUTE
	cache_entry.data = .
