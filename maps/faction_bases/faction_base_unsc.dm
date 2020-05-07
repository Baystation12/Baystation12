
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
	restrict_job_type = list()

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
