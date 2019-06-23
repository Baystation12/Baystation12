/*
GLOBAL_LIST_EMPTY(commando_spawn)

/datum/spawnpoint/commando_spawn
	display_name = "SOE Commando"
	restrict_job = list("SOE Commando")

/datum/spawnpoint/commando_spawn/New()
	..()
	turfs = GLOB.commando_spawn
*/
/obj/effect/landmark/start/commando_spawn
	name = "SOE Commando"
/*
/obj/effect/landmark/start/commando_spawn/New()
	..()
	GLOB.commando_spawn += loc
*/

/*
GLOBAL_LIST_EMPTY(commando_officer_spawn)

/datum/spawnpoint/commando_officer_spawn
	display_name = "SOE Commando Officer"
	restrict_job = list("SOE Commando Officer")

/datum/spawnpoint/commando_officer_spawn/New()
	..()
	turfs = GLOB.commando_officer_spawn
*/
/obj/effect/landmark/start/commando_officer_spawn
	name = "SOE Commando Officer"
/*
/obj/effect/landmark/start/commando_officer_spawn/New()
	..()
	GLOB.commando_officer_spawn += loc
*/
/obj/effect/landmark/start/commando_captain_spawn
	name = "SOE Commando Captain"
/*
/obj/effect/landmark/start/commando_captain_spawn/New()
	..()
	GLOB.commando_captain_spawn += loc
*/