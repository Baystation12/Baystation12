#include "hyperion_areas.dm"
#include "hyperion_jobs.dm"
#include "hyperion_access.dm"

/datum/map_template/ruin/exoplanet/hyperion
	name = "hyperion crashsite"
	id = "hyperior"
	description = "a crashed long range shuttle"
	suffixes = list("hyperioncrash/hyperion.dmm")
	cost = 2
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_NO_RADS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT
	apc_test_exempt_areas = list(
		// /area/map_template/colony/mineralprocessing = NO_SCRUBBER|NO_VENT
	)

/decl/submap_archetype/hyperioncrash
	descriptor = "hyperion crashsite"
	crew_jobs = list(
		/datum/job/submap/hyperion_pathfinder, 
		/datum/job/submap/hyperion_explorer
	)

/obj/effect/submap_landmark/joinable_submap/hyperion
	name = "Hypersion Crashsite"
	archetype = /decl/submap_archetype/hyperioncrash

/obj/effect/overmap/ship/landable/hyperion
	name = "long-range scout"
	desc = "A medium-sized shuttle used for long range exploration."
	color = "#bfff00"
	shuttle = "Hyperion"
	vessel_mass = 60000
	max_speed = 1/(6 SECONDS)
	burn_delay = 6 SECONDS
	fore_dir = NORTH
	vessel_size = SHIP_SIZE_LARGE

//////////////////////////
// /datum/shuttle/autodock/overmap/swordfish
// 	name = "Swordfish"
// 	warmup_time = 5
// 	dock_target = "bearcat_dock_port"
// 	current_location = "nav_hangar_bearcat_one"
// 	defer_initialisation = TRUE
// 	flags = SHUTTLE_FLAGS_PROCESS
// 	skill_needed = SKILL_BASIC
// 	ceiling_type = /turf/simulated/floor/shuttle_ceiling
// 	shuttle_area = list(/area/ship/scrap/broken_shuttle/cargo, /area/ship/scrap/broken_shuttle/cockpit, /area/ship/scrap/broken_shuttle/airlock, /area/ship/scrap/broken_shuttle/power)

/obj/effect/shuttle_landmark/hyperion/start
	name = "Hyperion Crashsite"
	// landmark_tag = "nav_hangar_bearcat_one"
	// docking_controller = "bearcat_dock_port"
	base_area = /area/ship/hyperion
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/machinery/computer/shuttle_control/explore/hyperion
	name = "hyperion control console"
	shuttle_tag = "Hyperion"