/*GLOBAL_LIST_EMPTY(oni_aegis_spawns)

/datum/spawnpoint/oni_aegis
	display_name = "ONI Aegis Spawns"
	restrict_job_type = list(/datum/job/ONI_Spartan_II,/datum/job/ONI_Spartan_II_Commander)

/datum/spawnpoint/oni_aegis_spawns/New()
	..()
	turfs = GLOB.oni_aegis_spawns
*/
/obj/effect/landmark/start/oni_aegis
	name = "ONI Aegis Spawns"
/*
/obj/effect/landmark/start/oni_aegis/New()
	..()
	GLOB.oni_aegis_spawns += loc
*/
