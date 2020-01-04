
/* INNIE BASE */

/obj/effect/overmap/ship/faction_base/innie
	name = "Camp New Hope"
	icon_state = "base_innie"
	faction = "Insurrection"
	defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses/innie
	base = 1


GLOBAL_LIST_EMPTY(innie_base_spawns)

/datum/spawnpoint/innie_base
	display_name = "Innie Base Spawns"
	restrict_job_type = list(\
		/datum/job/ship_crew_innie,\
		/datum/job/ship_cap_innie,\
		/datum/job/URF_commando,\
		/datum/job/URF_commando_officer)

/datum/spawnpoint/innie_base/New()
	..()
	turfs = GLOB.innie_base_spawns

/obj/effect/landmark/start/innie_base
	name = "Innie Base Spawns"

/obj/effect/landmark/start/innie_base/New()
	..()
	GLOB.innie_base_spawns += loc

/area/faction_base/innie
	name = "Insurrectionist Faction Base"

/area/faction_base/innie_defense_platform
	name = "Insurrectionist Defense Platform"

/area/faction_base/innie_shuttle
	name = "Insurrectionist Shuttle"
