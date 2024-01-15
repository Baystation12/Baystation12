/datum/map/sierra
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/engineering/auxpower = NO_SCRUBBER|NO_VENT,
		/area/crucian_hangar/start = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/holodeck = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/maintenance = NO_SCRUBBER|NO_VENT,
		/area/maintenance/exterior = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/maintenance/compactor = 0,
		/area/maintenance/cistern = 0,
		/area/turret_protected/ai_cyborg_station = 0,
		/area/turret_protected/ai = NO_SCRUBBER|NO_VENT,
		/area/turret_protected/ai_maint = NO_SCRUBBER|NO_VENT,
		/area/maintenance/fourthdeck/aft = 0,
		/area/maintenance/waterstore = 0,
		/area/maintenance/abandoned_hydroponics = 0,
		/area/maintenance/firstdeck/aftport = 0,
		/area/maintenance/incinerator = 0,
		/area/maintenance/thirddeck/aftstarboard = 0,
		/area/maintenance/thirddeck/port = 0,
		/area/maintenance/thirddeck/aftport = 0,
		/area/maintenance/thirddeck/foreport = 0,
		/area/maintenance/seconddeck/hangar = 0,
		/area/maintenance/seconddeck/aftstarboard = 0,
		/area/maintenance/substation/seconddeck = 0,
		/area/maintenance/substation/bridgedeck = 0,
		/area/maintenance/firstdeck/foreport = 0,
		/area/maintenance/firstdeck/centralport = 0,
		/area/maintenance/firstdeck/forestarboard = 0,
		/area/shuttle = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/shuttle/petrov = 0,
		/area/solar = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/storage = NO_SCRUBBER|NO_VENT,
		/area/storage/eva = 0,
		/area/storage/auxillary/port = 0,
		/area/storage/primary = 0,
		/area/storage/tech = 0,
		/area/supply = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/thruster = NO_SCRUBBER,
		/area/turbolift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/vacant = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/vacant/bar = NO_APC,
		/area/vacant/gambling = 0,
		/area/vacant/mess = NO_APC,
		/area/vacant/utility = 0,
		/area/vacant/dormintories = 0,
		/area/vacant/cargo = NO_SCRUBBER|NO_VENT,
		/area/vacant/infirmary = NO_SCRUBBER|NO_VENT,
		/area/vacant/monitoring = NO_SCRUBBER|NO_VENT,
		/area/vacant/prototype = 0,
		/area/vacant/storage = NO_SCRUBBER|NO_VENT,
		/area/rnd/xenobiology/atmos  = NO_SCRUBBER|NO_VENT,
		/area/rnd/xenobiology/cell_1 = NO_APC,
		/area/rnd/xenobiology/cell_2 = NO_APC,
		/area/rnd/xenobiology/cell_3 = NO_APC,
		/area/rnd/xenobiology/cell_4 = NO_APC
	)

	area_coherency_test_exempt_areas = list(
		/area/space,
		/area/centcom/control,
		/area/maintenance/exterior,
	)

	area_usage_test_exempted_areas = list(
		/area/overmap,
		/area/shuttle/escape/centcom,
		/area/shuttle/escape,
		/area/security/prison,
		/area/syndicate_elite_squad,
		/area/shuttle/syndicate_elite,
		/area/shuttle/syndicate_elite/station,
		/area/shuttle/syndicate_elite/mothership,
		/area/shuttle/escape/centcom,
		/area/rnd/xenobiology/xenoflora_storage,
		/area/turbolift,
		/area/turbolift/start,
		/area/turbolift/firstdeck,
		/area/turbolift/seconddeck,
		/area/turbolift/thirddeck,
		/area/turbolift/fourthdeck,
		/area/turbolift/bridgedeck,
		/area/beach,
		/area/template_noop,
		/area/bluespace_interlude,
		/area/bluespace_interlude/platform,
		/area/bluespace_interlude/surroundings,
		/area/rnd/xenobiology/cell_1,
		/area/rnd/xenobiology/cell_2,
		/area/rnd/xenobiology/cell_3,
		/area/rnd/xenobiology/cell_4
	)

/datum/unit_test/zas_area_test/ai_chamber
	name = "ZAS: AI Chamber"
	area_path = /area/turret_protected/ai

/datum/unit_test/zas_area_test/cargo_bay
	name = "ZAS: Cargo Bay"
	area_path = /area/quartermaster/storage

/datum/unit_test/zas_area_test/supply_centcomm
	name = "ZAS: Supply Shuttle (CentComm)"
	area_path = /area/supply/dock

/*
/datum/unit_test/zas_area_test/virology
	name = "ZAS: Virology"
	area_path = /area/medical/virology
*/

/datum/unit_test/zas_area_test/xenobio
	name = "ZAS: Xenobiology"
	area_path = /area/rnd/xenobiology
