/datum/map_template
	var/const/NO_APC = 1
	var/const/NO_VENT = 2
	var/const/NO_SCRUBBER = 4

	var/list/area_usage_test_exempted_areas = list()
	var/list/area_usage_test_exempted_root_areas = list()
	var/list/apc_test_exempt_areas = list()
	var/list/area_coherency_test_exempt_areas = list()
	var/list/area_coherency_test_subarea_count = list()

/datum/map_template/New(var/list/paths = null, var/rename = null)
	..()
	GLOB.using_map.area_usage_test_exempted_areas |= area_usage_test_exempted_areas
	GLOB.using_map.area_usage_test_exempted_root_areas |= area_usage_test_exempted_root_areas
	GLOB.using_map.apc_test_exempt_areas |= apc_test_exempt_areas
	GLOB.using_map.area_coherency_test_exempt_areas |= area_coherency_test_exempt_areas
	GLOB.using_map.area_coherency_test_subarea_count |= area_coherency_test_subarea_count