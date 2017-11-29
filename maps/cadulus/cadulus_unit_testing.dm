/datum/map/cadulus
	// Unit test exemptions
	apc_test_exempt_areas = list(
//		/area/AIsattele = NO_SCRUBBER|NO_VENT|NO_APC,
//		/area/vacant/office = 0
	)

	area_coherency_test_exempt_areas = list(
		/area/space,
		/area/mine/explored,
		/area/mine/unexplored,
		/area/centcom/control,
		/area/maintenance/exterior,
		/area/exoplanet,
		/area/exoplanet/desert,
		/area/exoplanet/grass,
		/area/exoplanet/snow,
		/area/exoplanet/garbage
	)

	area_coherency_test_subarea_count = list(
//			/area/constructionsite = 7,
//			/area/constructionsite/maintenance = 14,
//			/area/solar/constructionsite = 3,
	)

	area_usage_test_exempted_areas = list(
		/area/overmap,
//		/area/shuttle/escape/centcom,
//		/area/shuttle/escape,
//		/area/turbolift,
//		/area/security/prison,
//		/area/shuttle/syndicate_elite/station,
//		/area/shuttle/escape/centcom,
//		/area/rnd/xenobiology/xenoflora_storage,
//		/area/turbolift,
//		/area/turbolift/start,
//		/area/turbolift/bridge,
//		/area/turbolift/firstdeck,
//		/area/turbolift/seconddeck,
//		/area/turbolift/thirddeck,
//		/area/turbolift/fourthdeck,
		/area/exoplanet,
		/area/exoplanet/desert,
		/area/exoplanet/grass,
		/area/exoplanet/snow,
		/area/exoplanet/garbage
	)
/*
/datum/unit_test/zas_area_test/ai_chamber
	name = "ZAS: AI Chamber"
	area_path = /area/turret_protected/ai

/datum/unit_test/zas_area_test/cargo_bay
	name = "ZAS: Cargo Bay"
	area_path = /area/quartermaster/storage

datum/unit_test/zas_area_test/supply_centcomm
	name = "ZAS: Supply Shuttle (CentComm)"
	area_path = /area/supply/dock

datum/unit_test/zas_area_test/virology
	name = "ZAS: Virology"
	area_path = /area/medical/virology

datum/unit_test/zas_area_test/xenobio
	name = "ZAS: Xenobiology"
	area_path = /area/rnd/xenobiology
*/
