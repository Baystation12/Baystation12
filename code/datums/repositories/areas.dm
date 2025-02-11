var/global/repository/area/area_repository = new()

/repository/area
	var/list/by_name_coords_cache_data
	var/list/by_name_cache_data
	var/list/by_z_level_cache_data

/repository/area/New()
	by_name_coords_cache_data = list()
	by_name_cache_data        = list()
	by_z_level_cache_data     = list()
	..()

/repository/area/proc/get_areas_by_name(list/area_predicates = GLOBAL_PROC_REF(is_not_space_area))
	return priv_get_cached_areas(by_name_cache_data, GLOBAL_PROC_REF(group_areas_by_z_level), area_predicates, GLOBAL_PROC_REF(get_name))

/repository/area/proc/get_areas_by_name_and_coords(list/area_predicates = GLOBAL_PROC_REF(is_not_space_area))
	return priv_get_cached_areas(by_name_coords_cache_data, GLOBAL_PROC_REF(group_areas_by_z_level), area_predicates, GLOBAL_PROC_REF(get_name_and_coordinates))

/repository/area/proc/get_areas_by_z_level(list/area_predicates = GLOBAL_PROC_REF(is_not_space_area))
	return priv_get_cached_areas(by_z_level_cache_data, GLOBAL_PROC_REF(group_areas_by_z_level), area_predicates, GLOBAL_PROC_REF(get_name_and_coordinates))

/repository/area/proc/priv_get_cached_areas(list/area_cache, area_group_proc, list/area_predicates, naming_proc)
	. = get_cache_entry(area_cache, area_predicates)
	if(.)
		return
	. = priv_get_areas_by_proc(area_group_proc, area_predicates, naming_proc)
	set_cache_entry(area_cache, area_predicates, .)

/repository/area/proc/priv_get_areas_by_proc(area_group_proc, list/area_predicates, naming_proc)
	var/list/grouped_areas = call(area_group_proc)(area_predicates)
	grouped_areas = sortAssoc(grouped_areas)
	. = list()
	for(var/area_key in grouped_areas)
		var/list/list_of_areas = grouped_areas[area_key]
		list_of_areas = sortAtom(list_of_areas)
		for(var/area/A in list_of_areas)
			if(A.has_turfs())
				.[call(naming_proc)(A)] = A

/repository/area/proc/get_cache_entry(list/cache_data, key)
	var/datum/cache_entry/cache_entry = cache_data[key]
	if(!cache_entry)
		cache_entry = new/datum/cache_entry
		cache_data[key] = cache_entry

	if(world.time < cache_entry.timestamp)
		return cache_entry.data

/repository/area/proc/set_cache_entry(list/cache_data, key, data)
	var/datum/cache_entry/cache_entry = cache_data[key]
	cache_entry.timestamp = world.time + 3 MINUTES
	cache_entry.data = data
