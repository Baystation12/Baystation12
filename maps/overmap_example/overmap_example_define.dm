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
		/area/turbolift = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/ship/scrap/maintenance/lower = NO_VENT,
		/area/ship/scrap/maintenance/lower = NO_VENT,
		/area/ship/scrap/maintenance/atmos = NO_SCRUBBER,
		/area/ship/scrap/crew/hallway/port = NO_SCRUBBER,
		/area/ship/scrap/crew/hallway/port = NO_VENT,
		/area/ship/scrap/crew/hallway/starboard = NO_SCRUBBER,
		/area/ship/scrap/crew/hallway/starboard = NO_VENT,
		/area/ship/scrap/maintenance/engine/port = NO_SCRUBBER,
		/area/ship/scrap/maintenance/engine/port = NO_VENT,
		/area/ship/scrap/maintenance/engine/starboard = NO_SCRUBBER,
		/area/ship/scrap/maintenance/engine/starboard = NO_VENT,
		/area/ship/scrap/shuttle/outgoing = NO_APC,
		/area/ship/scrap/shuttle/outgoing = NO_SCRUBBER,
		/area/ship/scrap/shuttle/outgoing = NO_VENT,
		/area/sector/shuttle/outgoing2 = NO_APC,
		/area/sector/shuttle/outgoing2 = NO_SCRUBBER,
		/area/sector/shuttle/outgoing2 = NO_VENT,
		/area/exoplanet/grass = NO_APC,
		/area/exoplanet/grass = NO_SCRUBBER,
		/area/exoplanet/grass = NO_VENT,
	)
