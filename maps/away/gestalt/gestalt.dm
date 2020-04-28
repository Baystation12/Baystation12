#define WEBHOOK_SUBMAP_LOADED_GESTALT "webhook_submap_gestalt"

#include "gestalt_areas.dm"
#include "gestalt_jobs.dm"

/datum/map_template/ruin/away_site/gestalt
	name = "Travelling Gestalt"
	id = "awaysite_gestalt"
	description = "Diona Gestalt with Thrusters"
	suffixes = list("gestalt/gestalt.dmm")
	cost = 0.5
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/gestalt_shuttle)
	area_usage_test_exempted_root_areas = list(/area/gestalt)

/obj/effect/overmap/visitable/ship/gestalt
	name = "Diona Gestalt"
	desc = "Sensor array detects an active diona gestalt."
	in_space = 1
	initial_generic_waypoints = list(
		"nav_gestalt_1",
	)

	initial_restricted_waypoints = list(
		"Gestalt Shuttle" = list("nav_hangar_gestalt"),
	)

/obj/effect/shuttle_landmark/nav_gestalt/nav1
	name = "East of diona gestalt"
	landmark_tag = "nav_gestalt_1"

/datum/shuttle/autodock/overmap/gestalt_shuttle
	name = "Gestalt Shuttle"
	move_time = 10
	shuttle_area = list(/area/gestalt/shuttle)
	dock_target = "gestalt_shuttle"
	current_location = "nav_hangar_gestalt"
	landmark_transition = "nav_transit_gestalt"
	range = 1
	fuel_consumption = 4
	ceiling_type = /turf/simulated/floor/diona/airless
	skill_needed = SKILL_NONE
	defer_initialisation = TRUE

/obj/effect/shuttle_landmark/gestalt_base/hangar/gestalt_shuttle
	name = "Gestalt Shuttle Docked"
	landmark_tag = "nav_hangar_gestalt"

/obj/effect/shuttle_landmark/transit/gestalt_base/gestalt_shuttle
	name = "In transit"
	landmark_tag = "nav_transit_gestalt"

/obj/machinery/computer/shuttle_control/explore/gestalt_shuttle
	name = "shuttle control console"
	shuttle_tag = "Gestalt Shuttle"

/obj/effect/overmap/visitable/ship/landable/gestalt
	name = "large biosignature"
	desc = "Sensor array detects an unusually large biological presence."
	shuttle = "Gestalt Shuttle"
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_SMALL

/obj/effect/submap_landmark/joinable_submap/gestalt
	archetype = /decl/submap_archetype/derelict/gestalt

/decl/webhook/submap_loaded/gestalt
	id = WEBHOOK_SUBMAP_LOADED_GESTALT

/decl/submap_archetype/derelict/gestalt
	descriptor = "Travelling Gestalt"
	map = "gestalt"
	crew_jobs = list(
		/datum/job/submap/gestalt_seedling,
	)
	whitelisted_species = list(SPECIES_DIONA)
	blacklisted_species = null
	call_webhook = WEBHOOK_SUBMAP_LOADED_GESTALT

/obj/machinery/power/smes/buildable/preset/gestalt
	uncreated_component_parts = list(/obj/item/weapon/stock_parts/smes_coil/super_capacity = 1)
	_input_maxed = TRUE
	_output_maxed = TRUE
	_input_on = TRUE
	_output_on = TRUE
	_fully_charged = TRUE

/turf/simulated/floor/diona/airless
	name = "biomass"
	icon = 'icons/turf/floors.dmi'
	initial_flooring = /decl/flooring/diona
	initial_gas = null

/turf/simulated/shuttle/wall/diona
	name = "biomass"
	desc = "A mass of small intertwined aliens forming a wall... creepy."
	icon = 'icons/turf/doona.dmi'
	icon_state = "1"

#undef WEBHOOK_SUBMAP_LOADED_GESTALT