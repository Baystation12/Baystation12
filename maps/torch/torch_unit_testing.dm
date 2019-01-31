/datum/unit_test/station_wires_shall_be_connected
	exceptions = list(list(80, 107, 1, WEST))

/datum/map/torch
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/aquila/maintenance = NO_SCRUBBER|NO_VENT,
		/area/engineering/atmos/storage = NO_SCRUBBER|NO_VENT,
		/area/engineering/auxpower = NO_SCRUBBER|NO_VENT,
		/area/engineering/drone_fabrication = NO_SCRUBBER|NO_VENT,
		/area/engineering/engine_smes = NO_SCRUBBER|NO_VENT,
		/area/engineering/fuelbay = NO_SCRUBBER,
		/area/engineering/wastetank = NO_SCRUBBER,
		/area/hallway/primary/seconddeck/center = NO_SCRUBBER|NO_VENT,
		/area/holodeck = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/maintenance = NO_SCRUBBER|NO_VENT,
		/area/maintenance/auxsolarbridge = NO_SCRUBBER,
		/area/maintenance/auxsolarport = NO_SCRUBBER,
		/area/maintenance/auxsolarstarboard = NO_SCRUBBER,
		/area/maintenance/exterior = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/maintenance/firstdeck/foreport = NO_SCRUBBER,
		/area/maintenance/firstdeck/forestarboard = NO_SCRUBBER,
		/area/maintenance/incinerator = NO_SCRUBBER,
		/area/maintenance/seconddeck/aftport = NO_SCRUBBER|NO_VENT,
		/area/maintenance/seconddeck/forestarboard = NO_SCRUBBER,
		/area/maintenance/seconddeck/hallway = NO_SCRUBBER|NO_VENT,
		/area/maintenance/thirddeck/aftstarboard = NO_SCRUBBER|NO_VENT,
		/area/maintenance/fifthdeck/aftstarboard = NO_SCRUBBER,
		/area/maintenance/waterstore = 0,
		/area/maintenance/bluespace = NO_SCRUBBER,
		/area/mine/explored = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/mine/unexplored = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ninja_dojo = NO_SCRUBBER |NO_VENT | NO_APC,
		/area/outpost/abandoned = NO_SCRUBBER,
		/area/rescue_base = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/shield = NO_SCRUBBER|NO_VENT,
		/area/shuttle = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/shuttle/merchant = NO_SCRUBBER|NO_APC,
		/area/shuttle/petrov = 0,
		/area/shuttle/escape_pod6/station = NO_SCRUBBER|NO_APC,
		/area/shuttle/escape_pod7/station = NO_SCRUBBER|NO_APC,
		/area/shuttle/escape_pod8/station = NO_SCRUBBER|NO_APC,
		/area/shuttle/escape_pod9/station = NO_SCRUBBER|NO_APC,
		/area/shuttle/escape_pod10/station = NO_SCRUBBER|NO_APC,
		/area/shuttle/escape_pod11/station = NO_SCRUBBER|NO_APC,
		/area/skipjack_station = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/solar = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/storage = NO_SCRUBBER|NO_VENT,
		/area/storage/auxillary/port = 0,
		/area/storage/auxillary/starboard = 0,
		/area/storage/primary = 0,
		/area/storage/tech = 0,
		/area/storage/tools = 0,
		/area/supply = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/syndicate_station = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/thruster = NO_SCRUBBER,
		/area/turbolift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/turret_protected/ai = NO_SCRUBBER|NO_VENT,
		/area/turret_protected/ai_outer_chamber = NO_SCRUBBER|NO_VENT,
		/area/vacant = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/vacant/brig = NO_SCRUBBER|NO_VENT,
		/area/vacant/prototype/control = 0,
		/area/vacant/prototype/engine = 0,
		/area/vacant/cargo = NO_SCRUBBER|NO_VENT,
		/area/vacant/infirmary = NO_SCRUBBER|NO_VENT,
		/area/vacant/monitoring = NO_SCRUBBER|NO_VENT,
		/area/vacant/office = 0,
		/area/vacant/mess        = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet          = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/desert   = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/grass    = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/snow     = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/garbage  = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/shrouded = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet/chlorine = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/smugglers/base = NO_SCRUBBER,
		/area/smugglers/dorms = NO_SCRUBBER|NO_VENT,
		/area/smugglers/office = NO_SCRUBBER|NO_VENT,
		/area/bluespaceriver/underground = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/bluespaceriver/ground = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/casino/casino_cutter = NO_SCRUBBER|NO_VENT,
		/area/mobius_rift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/icarus/vessel = NO_APC,
		/area/icarus/open = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/hydrobase = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/hydrobase/station = NO_SCRUBBER,
		/area/map_template/marooned = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/shuttle/petrov/maint = NO_SCRUBBER,
		/area/vacant/bar = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/map_template/colony/mineralprocessing = NO_SCRUBBER|NO_VENT,
		/area/map_template/datacapsule = NO_SCRUBBER|NO_VENT|NO_APC
	)

	area_coherency_test_exempt_areas = list(
		/area/aquila/airlock,
		/area/space,
		/area/mine/explored,
		/area/mine/unexplored,
		/area/centcom/control,
		/area/maintenance/exterior,
		/area/exoplanet,
		/area/exoplanet/desert,
		/area/exoplanet/grass,
		/area/exoplanet/snow,
		/area/exoplanet/garbage,
		/area/exoplanet/shrouded,
		/area/exoplanet/chlorine,
		/area/icarus/vessel,
		/area/icarus/open
	)

	area_coherency_test_subarea_count = list()

	area_usage_test_exempted_areas = list(
		/area/AIsattele,
		/area/djstation,
		/area/outpost,
		/area/outpost/abandoned,
		/area/overmap,
		/area/shuttle/escape/centcom,
		/area/shuttle/escape,
		/area/security/prison,
		/area/shuttle/syndicate_elite/station,
		/area/shuttle/escape/centcom,
		/area/rnd/xenobiology/xenoflora_storage,
		/area/turbolift,
		/area/turbolift/start,
		/area/turbolift/bridge,
		/area/turbolift/firstdeck,
		/area/turbolift/seconddeck,
		/area/turbolift/thirddeck,
		/area/turbolift/fourthdeck,
		/area/template_noop
	)

	// not an away site? you probably want to be using area_usage_test_exempted_areas
	area_usage_test_exempted_root_areas = list(
		/area/casino,
		/area/constructionsite,
		/area/derelict,
		/area/lost_supply_base,
		/area/magshield,
		/area/mine,
		/area/ship,
		/area/smugglers,
		/area/slavers_base,
		/area/yacht,
		/area/bluespaceriver,
		/area/mobius_rift,
		/area/icarus,
		/area/errant_pisces,
		/area/lar_maria,
		/area/map_template,
		/area/unishi,
		/area/exoplanet
	)

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
