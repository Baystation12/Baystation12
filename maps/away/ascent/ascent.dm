#define ASCENT_COLONY_SHIP_NAME "\improper Ascent seedship"

#include "ascent_areas.dm"
#include "ascent_shuttles.dm"
#include "ascent_jobs.dm"
#include "ascent_atoms.dm"

// Map template data.
/datum/map_template/ruin/away_site/ascent_seedship
	name = ASCENT_COLONY_SHIP_NAME
	id = "awaysite_ascent_seedship"
	description = "A small Ascent colony ship."
	suffixes = list("ascent/ascent-1.dmm")
	cost = INFINITY
	shuttles_to_initialise = list(/datum/shuttle/autodock/overmap/ascent, /datum/shuttle/autodock/overmap/ascent/two)

// Overmap objects.
/obj/effect/overmap/ship/ascent_seedship
	name = ASCENT_COLONY_SHIP_NAME
	desc = "Wake signature indicates a small to medium sized vessel of unknown design."
	vessel_mass = 6500
	max_speed = 1/(1 SECOND)
	initial_restricted_waypoints = list(
		"Trichoptera" = list("nav_hangar_ascent_one"),
		"Lepidoptera" = list("nav_hangar_ascent_two")
	)

/obj/effect/submap_landmark/joinable_submap/ascent_seedship
	name = ASCENT_COLONY_SHIP_NAME
	archetype = /decl/submap_archetype/ascent_seedship
	submap_datum_type = /datum/submap/ascent
