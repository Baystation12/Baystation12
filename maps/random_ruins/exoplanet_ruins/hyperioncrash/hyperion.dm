#include "hyperion_areas.dm"
#include "hyperion_jobs.dm"
#include "hyperion_access.dm"

/datum/map_template/ruin/exoplanet/hyperion
	name = "hyperion crashsite"
	id = "hyperion"
	description = "a crashed long range shuttle"
	suffixes = list("hyperioncrash/hyperion.dmm")
	cost = 2
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS | TEMPLATE_FLAG_NO_RADS
	ruin_tags = RUIN_HUMAN|RUIN_HABITAT
	apc_test_exempt_areas = list(
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
	
/obj/effect/shuttle_landmark/hyperion/start
	name = "Hyperion Crashsite"
	base_area = /area/ship/hyperion
	movable_flags = MOVABLE_FLAG_EFFECTMOVE

/obj/machinery/computer/shuttle_control/explore/hyperion
	name = "hyperion control console"
	shuttle_tag = "Hyperion"