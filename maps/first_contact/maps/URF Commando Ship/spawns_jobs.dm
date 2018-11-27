GLOBAL_LIST_EMPTY(commando_spawns)

/datum/spawnpoint/commando_spawn
	display_name = "Commando Spawn"
	restrict_job = list("URF Commando - Rifleman")

/datum/spawnpoint/commando_spawn/New()
	..()
	turfs = GLOB.commando_spawns

/obj/effect/landmark/start/commando_spawn
	name = "Commando Spawn"

/obj/effect/landmark/start/commando_spawn/New()
	..()
	GLOB.commando_spawns += loc

GLOBAL_LIST_EMPTY(commando_officer_spawns)

/datum/spawnpoint/commando_officer_spawn
	display_name = "Commando Officer Spawn"
	restrict_job = list("URF Commando Officer")

/datum/spawnpoint/commando_officer_spawn/New()
	..()
	turfs = GLOB.commando_officer_spawns

/obj/effect/landmark/start/commando_officer_spawn
	name = "Commando Officer Spawn"

/obj/effect/landmark/start/commando_officer_spawn/New()
	..()
	GLOB.commando_officer_spawns += loc

