
/* UNSC BASE */
/*
/obj/effect/overmap/ship/faction_base/unsc
	name = "Deviance Station"
	icon_state = "base_unsc"
	faction = "UNSC"
	defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses/unsc
	overmap_spawn_near_me = list(/obj/effect/overmap/ship/unsclightbrigade)
	base = 1
*/
GLOBAL_LIST_EMPTY(unsc_base_spawns)

/datum/spawnpoint/unsc_base
	display_name = "UNSC Base Spawns"
	restrict_job_type = list(\
	/datum/job/unsc/crew,\
	/datum/job/unsc/medical,\
	/datum/job/unsc/marine,\
	/datum/job/unsc/marine/specialist,\
	/datum/job/unsc/marine/squad_leader,\
	/datum/job/unsc/commanding_officer,\
	/datum/job/unsc/executive_officer,\
	/datum/job/unsc/oni/research,\
	/datum/job/unsc/odst,\
	/datum/job/unsc/odst/squad_leader)

/datum/spawnpoint/unsc_base/New()
	..()
	turfs = GLOB.unsc_base_spawns

/obj/effect/landmark/start/unsc_base
	name = "UNSC Base Spawns"

/obj/effect/landmark/start/unsc_base/New()
	..()
	GLOB.unsc_base_spawns += loc

/*
/area/faction_base/unsc_defense_platform
	name = "UNSC Defense Platform"
	icon_state = "firingrange"

/area/faction_base/unsc_shuttle
	name = "UNSC Shuttle"
	icon_state = "shuttle"
*/

GLOBAL_LIST_EMPTY(unsc_base_fallback_spawns)

/datum/spawnpoint/unsc_base_fallback
	display_name = "UNSC Base Fallback Spawns"
	restrict_job_type = list(\
	/datum/job/unsc/marine,\
	/datum/job/unsc/marine/specialist,\
	/datum/job/unsc/marine/squad_leader,\
	/datum/job/unsc/commanding_officer,\
	/datum/job/unsc/executive_officer,\
	/datum/job/unsc/oni/research,\
	/datum/job/unsc/odst,\
	/datum/job/unsc/odst/squad_leader)

/datum/spawnpoint/unsc_base_fallback/New()
	..()
	turfs = GLOB.unsc_base_fallback_spawns

/obj/effect/landmark/start/unsc_base_fallback
	name = "UNSC Base Fallback Spawns"

/obj/effect/landmark/start/unsc_base_fallback/New()
	..()
	GLOB.unsc_base_fallback_spawns += loc