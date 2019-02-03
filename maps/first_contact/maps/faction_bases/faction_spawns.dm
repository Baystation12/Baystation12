
GLOBAL_LIST_EMPTY(covenant_base_spawns)

/datum/spawnpoint/cov_base
	display_name =  "Covenant Base Spawns"
	//restrict_job = list()

/datum/spawnpoint/cov_base/New()
	..()
	turfs = GLOB.covenant_base_spawns

/obj/effect/landmark/start/cov_base
	name = "Covenant Base Spawns"

/obj/effect/landmark/start/cov_base/New()
	..()
	GLOB.covenant_base_spawns += loc

GLOBAL_LIST_EMPTY(unsc_base_spawns)

/datum/spawnpoint/unsc_base
	display_name =  "UNSC Base Spawns"
//	restrict_job = list()

/datum/spawnpoint/unsc_base/New()
	..()
	turfs = GLOB.unsc_base_spawns

/obj/effect/landmark/start/unsc_base
	name = "UNSC Base Spawns"

/obj/effect/landmark/start/unsc_base/New()
	..()
	GLOB.unsc_base_spawns += loc

GLOBAL_LIST_EMPTY(innie_base_spawns)

/datum/spawnpoint/innie_base
	display_name =  "Innie Base Spawns"
//	restrict_job = list()

/datum/spawnpoint/innie_base/New()
	..()
	turfs = GLOB.unsc_base_spawns

/obj/effect/landmark/start/innie_base
	name = "Innie Base Spawns"

/obj/effect/landmark/start/innie_base/New()
	..()
	GLOB.unsc_base_spawns += loc