/datum/map/overmap_example
	name = "Overmap Example"
	full_name = "The Overmap Example"
	path = "overmap_example"

	station_name  = "CSV Bearcat"
	station_short = "Bearcat"

	evac_controller_type = /datum/evacuation_controller/starship
	lobby_icon = 'maps/overmap_example/overmap_example_lobby.dmi'

	allowed_spawns = list("Arrivals Shuttle")
	use_overmap = 1

	num_exoplanets = 1

/datum/map/overmap_example
	apc_test_exempt_areas = list(
		/area/space = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/unscfrigate = NO_SCRUBBER|NO_VENT,
		/area/unscfrigate/logistics = NO_SCRUBBER|NO_VENT,
		/area/unscfrigate/medbay = NO_SCRUBBER|NO_VENT,
		/area/unscfrigate/medbay/surgery1 = 0,
		/area/unscfrigate/medbay/surgery2 = 0,
		/area/unscfrigate/medbay/patient2 = 0,
		/area/unscfrigate/medbay/recovery = NO_VENT,
		/area/unscfrigate/medbay/exam = 0,
		/area/unscfrigate/medbay/patient1 = 0,
		/area/unscfrigate/logistics/hangar_aftstarb = NO_SCRUBBER,
		/area/unscfrigate/logistics/hangar_forestarb = NO_SCRUBBER,
		/area/unscfrigate/medbay/surgeryprep = NO_SCRUBBER,
		/area/unscfrigate/logistics/hangar_aftport = NO_SCRUBBER,
		/area/unscfrigate/logistics/hangar_foreport = NO_SCRUBBER,
		/area/unscfrigate/hangar_starb = NO_SCRUBBER,
		/area/unscfrigate/central = NO_SCRUBBER|NO_VENT,
		/area/unscfrigate/hangar_port = NO_SCRUBBER,
		/area/unscfrigate/tcomms = NO_SCRUBBER,
		/area/unscfrigate/bridge = NO_SCRUBBER,
		/area/unscfrigate/mac/cannon = NO_SCRUBBER|NO_VENT,
		/area/turbolift = NO_SCRUBBER|NO_VENT|NO_APC
	)