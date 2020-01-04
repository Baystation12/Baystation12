
/* COVENANT BASE */

/obj/effect/overmap/ship/faction_base/cov
	name = "Vanguard's Mantle"
	icon_state = "base_cov"
	faction = "Covenant"
	defense_type = /obj/effect/overmap/ship/npc_ship/automated_defenses/cov
	overmap_spawn_near_me = list(/obj/effect/overmap/ship/covenant_corvette)
	base = 1

GLOBAL_LIST_EMPTY(covenant_base_spawns)

/datum/spawnpoint/cov_base
	display_name = "Covenant Base Spawns"
	restrict_job_type = list(\
		/datum/job/covenant/skirmminor,\
		/datum/job/covenant/skirmmajor,\
		/datum/job/covenant/skirmmurmillo,\
		/datum/job/covenant/skirmcommando,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_honour_guard,\
		/datum/job/covenant/sangheili_shipmaster,\
		/datum/job/covenant/lesser_prophet,\
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/kigyarmajor,
		/datum/job/covenant/unggoy_minor,\
		/datum/job/covenant/unggoy_major)

/datum/spawnpoint/cov_base/New()
	..()
	turfs = GLOB.covenant_base_spawns

/obj/effect/landmark/start/cov_base
	name = "Covenant Base Spawns"

/obj/effect/landmark/start/cov_base/New()
	..()
	GLOB.covenant_base_spawns += loc

/area/faction_base/cov
	name = "Covenant Faction Base"

/area/faction_base/cov_defense_platform
	name = "Covenant Defense Platform"

/area/faction_base/covenant_shuttle
	name = "Covenant Shuttle"
