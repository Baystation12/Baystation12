GLOBAL_LIST_EMPTY(commando_spawns)

/datum/spawnpoint/commando_spawn
	display_name = "Commando Spawn"
	restrict_job = list("URF Commando")

/datum/spawnpoint/corvetteodst_crewmedical/New()
	..()
	turfs = GLOB.commando_spawns

/obj/effect/landmark/start/commando_spawn
	name = "Commando Spawn"

/obj/effect/landmark/start/commando_spawn/New()
	..()
	GLOB.commando_spawns += loc