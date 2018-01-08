
/datum/map/innie_base
	allowed_jobs = list(/datum/job/Insurrectionist,/datum/job/Insurrectionist_leader,/datum/job/UNSC_assault,/datum/job/UNSC_Squad_Lead,/datum/job/UNSC_Team_Lead)

	allowed_spawns = list("Insurrectionist","Insurrectionist Leader","ODST Assault Squad Member","ODST Assault Squad Lead","ODST Assault Team Lead")

	default_spawn = "Insurrectionist"

//Ghost spawn landmarks//
/obj/effect/landmark/ghost_spawn/New()
	GLOB.latejoin_ghosts += loc

//Insurrectionist Landmarks + datums//

GLOBAL_LIST_EMPTY(Innie_turfs)

/datum/spawnpoint/insurrectionist
	display_name = "Insurrectionist"
	restrict_job = list("Insurrectionist")

/datum/spawnpoint/insurrectionist/New()
	..()
	turfs = GLOB.Innie_turfs

/obj/effect/landmark/start/Insurrectionist
	name = "Insurrectionist"

/obj/effect/landmark/start/Insurrectionist/New()
	..()
	GLOB.Innie_turfs += loc

/datum/spawnpoint/insurrectionist_Leader
	display_name = "Insurrectionist Leader"
	restrict_job = list("Insurrectionist Leader")

/datum/spawnpoint/insurrectionist_Leader/New()
	..()
	turfs = GLOB.Innie_turfs

/obj/effect/landmark/start/Insurrectionist_Leader
	name = "Insurrectionist Leader"

/obj/effect/landmark/start/Insurrectionist_Leader/New()
	..()
	GLOB.Innie_turfs += loc

//UNSC Landmarks + datums//

GLOBAL_LIST_EMPTY(UNSC_turfs)

/datum/spawnpoint/UNSC_A_S_M
	display_name = "ODST Assault Squad Member"
	restrict_job = list("ODST Assault Squad Member")

/datum/spawnpoint/UNSC_A_S_M/New()
	..()
	turfs = GLOB.UNSC_turfs

/obj/effect/landmark/start/UNSC_A_S_M
	name = "ODST Assault Squad Member"

/obj/effect/landmark/start/UNSC_A_S_M/New()
	..()
	GLOB.UNSC_turfs += loc

/datum/spawnpoint/UNSC_A_S_L
	display_name = "ODST Assault Squad Lead"
	restrict_job = list("ODST Assault Squad Lead")

/datum/spawnpoint/UNSC_A_S_L/New()
	..()
	turfs = GLOB.UNSC_turfs

/obj/effect/landmark/start/UNSC_A_S_L
	name = "ODST Assault Squad Lead"

/obj/effect/landmark/start/UNSC_A_S_L/New()
	..()
	GLOB.UNSC_turfs += loc

/datum/spawnpoint/UNSC_A_T_L
	display_name = "ODST Assault Team Lead"
	restrict_job = list("ODST Assault Team Lead")

/datum/spawnpoint/UNSC_A_T_L/New()
	..()
	turfs = GLOB.UNSC_turfs

/obj/effect/landmark/start/UNSC_A_T_L
	name = "ODST Assault Team Lead"

/obj/effect/landmark/start/UNSC_A_T_L/New()
	..()
	GLOB.UNSC_turfs += loc
