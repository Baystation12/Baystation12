/var/repository/area/area_repository = new()

/repository/area
	var/list/by_name_coords_cache_data
	var/list/by_name_cache_data
	var/list/by_z_level_cache_data

/repository/area/New()
	by_name_coords_cache_data 	= list()
	by_name_cache_data 			= list()
	by_z_level_cache_data 		= list()
	..()

/repository/area/proc/get_areas_by_name(var/list/area_predicates = /proc/is_not_space_area, var/with_coords = 1)
	if(with_coords)
		. = get_cache_entry(by_name_coords_cache_data, area_predicates)
	else
		. = get_cache_entry(by_name_cache_data, area_predicates)
	if(.)
		return
	. = get_areas_by_proc(/proc/group_areas_by_name, area_predicates, with_coords)
	if(with_coords)
		set_cache_entry(by_name_coords_cache_data, area_predicates, .)
	else
		set_cache_entry(by_name_cache_data, area_predicates, .)

/repository/area/proc/get_areas_by_z_level(var/list/area_predicates = /proc/is_not_space_area)
	. = get_cache_entry(by_z_level_cache_data, area_predicates)
	if(.)
		return
	. = get_areas_by_proc(/proc/group_areas_by_z_level, area_predicates)
	set_cache_entry(by_z_level_cache_data, area_predicates, .)

/repository/area/proc/get_areas_by_proc(var/area_group_proc, var/list/area_predicates, var/add_coords = 1)
	var/list/grouped_areas = call(area_group_proc)(area_predicates)
	grouped_areas = sortAssoc(grouped_areas)
	. = list()
	for(var/area_key in grouped_areas)
		var/list/list_of_areas = grouped_areas[area_key]
		list_of_areas = sortAtom(list_of_areas)
		for(var/area/A in list_of_areas)
			var/turf/picked = pick_area_turf(A)
			if(picked)
				if(add_coords)
					.["[A.name] \[[A.x],[A.y],[A.z]\]"] = A
				else
					.[A.name] = A

/repository/area/proc/get_cache_entry(var/list/cache_data, var/key)
	var/datum/cache_entry/cache_entry = cache_data[key]
	if(!cache_entry)
		cache_entry = new/datum/cache_entry
		cache_data[key] = cache_entry

	if(world.time < cache_entry.timestamp)
		return cache_entry.data

/repository/area/proc/set_cache_entry(var/list/cache_data, var/key, var/data)
	var/datum/cache_entry/cache_entry = cache_data[key]
	cache_entry.timestamp = world.time + 3 MINUTES
	cache_entry.data = data
