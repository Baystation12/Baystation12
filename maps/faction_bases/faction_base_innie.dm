#include "faction_base.dm"

/* INNIE BASE */
//Placeholders to deter runtimes
/obj/effect/overmap/ship/urf_flagship

/obj/effect/overmap/ship/faction_base/innie
	name = "Camp New Hope"
	icon_state = "base_innie"
	faction = "Insurrection"
	defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses/innie
	overmap_spawn_near_me = list(/obj/effect/overmap/ship/urf_flagship)
	base = 1


GLOBAL_LIST_EMPTY(innie_base_spawns)

/datum/spawnpoint/innie_base
	display_name = "Innie Base Spawns"
	restrict_job_type = list(
		/datum/job/geminus_innie,
		/datum/job/geminus_innie/officer,
		/datum/job/geminus_innie/commander,
		/datum/job/geminus_innie/orion_defector,
		/datum/job/geminus_x52/researcher,
		/datum/job/geminus_x52/research_director,
		/datum/job/insurrectionist_ai,
		/datum/job/soe_commando,
		/datum/job/soe_commando_officer)

/datum/spawnpoint/innie_base/New()
	..()
	turfs = GLOB.innie_base_spawns

GLOBAL_LIST_EMPTY(innie_base_fallback_spawns)

/datum/spawnpoint/innie_base_fallback
	display_name = "Innie Base Fallback Spawns"
	restrict_job_type = list(\
		/datum/job/geminus_innie,\
		/datum/job/geminus_innie/officer,\
		/datum/job/geminus_innie/commander,\
		/datum/job/geminus_innie/orion_defector,\
		/datum/job/geminus_x52/researcher,\
		/datum/job/geminus_x52/research_director,\
		/datum/job/insurrectionist_ai,\
		/datum/job/soe_commando,\
		/datum/job/soe_commando_officer,\
		)

/datum/spawnpoint/innie_base_fallback/New()
	..()
	turfs = GLOB.innie_base_fallback_spawns

/obj/effect/landmark/start/innie_base
	name = "Innie Base Spawns"

/obj/effect/landmark/start/innie_base/New()
	..()
	GLOB.innie_base_spawns += loc

/obj/effect/landmark/start/innie_base_fallback
	name = "Innie Base Fallback Spawns"

/obj/effect/landmark/start/innie_base_fallback/New()
	..()
	GLOB.innie_base_fallback_spawns += loc

/area/faction_base/innie
	name = "Insurrectionist Faction Base"

/area/faction_base/innie_defense_platform
	name = "Insurrectionist Defense Platform"

/area/faction_base/innie_shuttle
	name = "Insurrectionist Shuttle"
