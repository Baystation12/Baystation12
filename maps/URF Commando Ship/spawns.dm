/*
GLOBAL_LIST_EMPTY(commando_spawn)

/datum/spawnpoint/commando_spawn
	display_name = "URF Commando"
	restrict_job = list("URF Commando")

/datum/spawnpoint/commando_spawn/New()
	..()
	turfs = GLOB.commando_spawn
*/
/obj/effect/landmark/start/commando_spawn
	name = "URF Commando"
/*
/obj/effect/landmark/start/commando_spawn/New()
	..()
	GLOB.commando_spawn += loc
*/

/*
GLOBAL_LIST_EMPTY(commando_officer_spawn)

/datum/spawnpoint/commando_officer_spawn
	display_name = "URF Commando Officer"
	restrict_job = list("URF Commando Officer")

/datum/spawnpoint/commando_officer_spawn/New()
	..()
	turfs = GLOB.commando_officer_spawn
*/
/obj/effect/landmark/start/commando_officer_spawn
	name = "URF Commando Officer"
/*
/obj/effect/landmark/start/commando_officer_spawn/New()
	..()
	GLOB.commando_officer_spawn += loc
*/