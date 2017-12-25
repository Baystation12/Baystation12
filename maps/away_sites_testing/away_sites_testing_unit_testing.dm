/datum/map/away_sites_testing
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/AIsattele = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/constructionsite = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/constructionsite/ai = NO_SCRUBBER|NO_VENT,
		/area/constructionsite/atmospherics = NO_SCRUBBER,
		/area/constructionsite/teleporter = NO_SCRUBBER,
		/area/derelict/ship = NO_SCRUBBER|NO_VENT,
		/area/djstation = NO_SCRUBBER|NO_APC,
		/area/mine/explored = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/mine/unexplored = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/outpost/abandoned = NO_SCRUBBER,
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/scrap/maintenance/engine/port = NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/maintenance/engine/starboard = NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/crew/hallway/port= NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/crew/hallway/starboard= NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/maintenance/hallway = NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/maintenance/lower = NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/maintenance/atmos = NO_SCRUBBER,
		/area/ship/scrap/escape_port = NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/escape_star = NO_SCRUBBER|NO_VENT,
		/area/ship/scrap/shuttle/lift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/scrap/command/hallway = NO_SCRUBBER|NO_VENT,
		/area/marooned/marooned_snow = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/marooned/marooned_hut = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/lost_supply_base/solar = NO_SCRUBBER,
		/area/smugglers/base = NO_SCRUBBER,
		/area/smugglers/dorms = NO_SCRUBBER|NO_VENT,
		/area/smugglers/office = NO_SCRUBBER|NO_VENT,
		/area/casino/casino_solar_control = NO_SCRUBBER,
		/area/casino/casino_maintenance = NO_SCRUBBER,
		/area/casino/casino_hangar = NO_SCRUBBER,
		/area/bluespaceriver/underground = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/bluespaceriver/ground = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/casino/casino_hangar = NO_SCRUBBER,
		/area/casino/casino_cutter = NO_SCRUBBER|NO_VENT,
		/area/slavers_base/hangar = NO_SCRUBBER
	)
	
	area_coherency_test_exempt_areas = list(
		/area/space,
		/area/mine/explored,
		/area/mine/unexplored,
		/area/marooned/marooned_snow
	)

	area_coherency_test_subarea_count = list(
		/area/constructionsite = 7,
		/area/constructionsite/maintenance = 14,
		/area/constructionsite/solar = 3,
	)

	area_usage_test_exempted_areas = list(
		/area/overmap,
		/area/template_noop,
		/area/centcom,
		/area/centcom/holding,
		/area/centcom/specops,
		/area/chapel,
		/area/hallway,
		/area/medical,
		/area/medical/virology,
		/area/medical/virologyaccess,
		/area/medical/virology,
		/area/security,
		/area/security/brig,
		/area/security/prison,
		/area/maintenance,
		/area/rnd,
		/area/rnd/xenobiology,
		/area/rnd/xenobiology/xenoflora,
		/area/rnd/xenobiology/xenoflora_storage,
		/area/shuttle,
		/area/shuttle/escape,
		/area/shuttle/escape/centcom,
		/area/shuttle/specops,
		/area/shuttle/specops/centcom,
		/area/shuttle/syndicate_elite,
		/area/shuttle/syndicate_elite/mothership,
		/area/shuttle/syndicate_elite/station,
		/area/skipjack_station,
		/area/skipjack_station/start,
		/area/supply,
		/area/syndicate_mothership,
		/area/syndicate_mothership/elite_squad,
		/area/wizard_station,
		/area/beach,
		/area/turbolift
	)

	area_usage_test_exempted_root_areas = list(
		/area/exoplanet,
		/area/map_template
	)
