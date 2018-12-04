#include "colony_areas.dm"
#include "colony_jobs.dm"
#include "colony_access.dm"

/datum/map_template/ruin/exoplanet/playablecolony
	name = "established colony"
	id = "playablecolony"
	description = "a fully functional colony of rednecked frontier hicks"
	suffixes = list("playablecolony/colony.dmm")
	cost = 2
	template_flags = TEMPLATE_FLAG_CLEAR_CONTENTS | TEMPLATE_FLAG_NO_RUINS

/decl/submap_archetype/playablecolony
	descriptor = "playable colony"
	crew_jobs = list(
		/datum/job/submap/colonist,
		/datum/job/submap/colonist_doc,
		/datum/job/submap/colonist_law,
		/datum/job/submap/colonist_boss
	)

/decl/hierarchy/outfit/job/colonist
	name = OUTFIT_JOB_NAME("Colonist")
	id_type = null
	pda_type = null

/obj/effect/submap_landmark/joinable_submap/colony
	name = "Established Colony"
	archetype = /decl/submap_archetype/playablecolony
