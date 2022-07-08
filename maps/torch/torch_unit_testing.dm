/datum/map/torch
	// Unit test exemptions
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/exoplanet = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/engineering/atmos/storage = NO_SCRUBBER|NO_VENT,
		/area/engineering/auxpower = NO_SCRUBBER|NO_VENT,
		/area/engineering/engine_smes = NO_SCRUBBER|NO_VENT,
		/area/engineering/fuelbay = NO_SCRUBBER|NO_VENT,
		/area/engineering/wastetank = NO_SCRUBBER|NO_VENT,
		/area/hallway/primary/seconddeck/center = NO_SCRUBBER|NO_VENT,
		/area/holodeck = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/maintenance = NO_SCRUBBER|NO_VENT,
		/area/maintenance/auxsolarbridge = NO_SCRUBBER|NO_VENT,
		/area/maintenance/auxsolarport = NO_SCRUBBER|NO_VENT,
		/area/maintenance/auxsolarstarboard = NO_SCRUBBER|NO_VENT,
		/area/torchexterior = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/maintenance/firstdeck/foreport = NO_SCRUBBER|NO_VENT,
		/area/maintenance/firstdeck/forestarboard = NO_SCRUBBER|NO_VENT,
		/area/maintenance/incinerator = NO_SCRUBBER,
		/area/maintenance/disposal = NO_SCRUBBER,
		/area/maintenance/seconddeck/aftport = NO_SCRUBBER|NO_VENT,
		/area/maintenance/seconddeck/forestarboard = NO_SCRUBBER|NO_VENT,
		/area/maintenance/thirddeck/aftstarboard = NO_SCRUBBER|NO_VENT,
		/area/maintenance/fifthdeck/aftstarboard = NO_SCRUBBER|NO_VENT,
		/area/maintenance/waterstore = 0,
		/area/shield = NO_SCRUBBER|NO_VENT,
		/area/shuttle = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/shuttle/merchant = NO_SCRUBBER|NO_APC,
		/area/shuttle/petrov = 0,
		/area/shuttle/petrov/maint = NO_SCRUBBER|NO_VENT,
		/area/shuttle/escape_pod6/station = NO_SCRUBBER|NO_APC|NO_VENT,
		/area/shuttle/escape_pod7/station = NO_SCRUBBER|NO_APC|NO_VENT,
		/area/shuttle/escape_pod8/station = NO_SCRUBBER|NO_APC|NO_VENT,
		/area/shuttle/escape_pod9/station = NO_SCRUBBER|NO_APC|NO_VENT,
		/area/shuttle/escape_pod10/station = NO_SCRUBBER|NO_APC|NO_VENT,
		/area/shuttle/escape_pod11/station = NO_SCRUBBER|NO_APC|NO_VENT,
		/area/solar = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/storage = NO_SCRUBBER|NO_VENT,
		/area/storage/auxillary/port = 0,
		/area/storage/auxillary/starboard = 0,
		/area/storage/primary = 0,
		/area/storage/tech = 0,
		/area/storage/tools = 0,
		/area/supply = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/thruster = NO_SCRUBBER,
		/area/turbolift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/turret_protected/ai = NO_SCRUBBER|NO_VENT,
		/area/turret_protected/ai_outer_chamber = NO_SCRUBBER|NO_VENT,
		/area/vacant/bar = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/vacant = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/vacant/brig = NO_SCRUBBER|NO_VENT,
		/area/vacant/prototype/control = 0,
		/area/vacant/prototype/engine = 0,
		/area/vacant/cargo = NO_SCRUBBER|NO_VENT,
		/area/vacant/infirmary = NO_SCRUBBER|NO_VENT,
		/area/vacant/monitoring = NO_SCRUBBER|NO_VENT,
		/area/vacant/mess = NO_SCRUBBER|NO_VENT|NO_APC,
	)

	area_coherency_test_exempt_areas = list(
		/area/aquila/airlock,
		/area/centcom/control,
		/area/torchexterior,
		/area/space
	)

	area_usage_test_exempted_areas = list(
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

/datum/unit_test/zas_area_test/ai_chamber
	name = "ZAS: AI Chamber"
	area_path = /area/turret_protected/ai

/datum/unit_test/zas_area_test/cargo_bay
	name = "ZAS: Cargo Bay"
	area_path = /area/quartermaster/storage

/datum/unit_test/zas_area_test/supply_centcomm
	name = "ZAS: Supply Shuttle (CentComm)"
	area_path = /area/supply/dock

/datum/unit_test/zas_area_test/xenobio
	name = "ZAS: Xenobiology"
	area_path = /area/rnd/xenobiology
