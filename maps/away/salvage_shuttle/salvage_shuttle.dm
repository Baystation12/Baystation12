#include "./code/areas.dm"
#include "./code/jobs.dm"
#include "./code/radio.dm"
#include "./code/shuttle.dm"
#include "./code/objects.dm"

/datum/map_template/ruin/away_site/salvage_ship
	name =  "Salvage Shuttle"
	id = "awaysite_crab"
	description = "Salvage Shuttle"
	suffixes = list("salvage_shuttle/salvage_shuttle.dmm")
	spawn_cost = 0.5
	player_cost = 2
	accessibility_weight = 10
	spawn_weight = 0.67
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/salvage_shuttle)

	area_usage_test_exempted_root_areas = list(
		/area/salvage_shuttle,
		/area/derelict_cargo_ship
	)

	apc_test_exempt_areas = list(
		/area/salvage_shuttle/net = NO_SCRUBBER|NO_VENT|NO_APC,
		/area/derelict_cargo_ship/maintenance = NO_SCRUBBER|NO_VENT,
		/area/derelict_cargo_ship/cockpit = NO_VENT
	)

/obj/submap_landmark/joinable_submap/salvage_ship
	name =  "Salvage Shuttle"
	archetype = /singleton/submap_archetype/salvage_ship

/singleton/submap_archetype/salvage_ship
	descriptor = "Independent Salvage Shuttle"
	map = "Salvage Shuttle"
	crew_jobs = list(/datum/job/submap/independent_salvager)

/obj/overmap/visitable/sector/salvage_site
	name = "Active Salvage Site"
	desc = "Small traces of ship debris detected. Signature indicates current or very recent activity on site."
	icon_state = "event"
	hide_from_reports = TRUE
	sensor_visibility = 15

	initial_generic_waypoints = list(
		"nav_salvage_shuttle_1",
		"nav_salvage_shuttle_2",
		"nav_salvage_shuttle_3"
	)

	initial_restricted_waypoints = list(
		"ISV Crab" = list("nav_salvage_shuttle_crab")
	)
