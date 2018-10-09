GLOBAL_LIST_EMPTY(prowlerodst_crew_spawns)

/datum/spawnpoint/prowlerodst_crew
	display_name = "UNSC Aegis Ship Crew Spawn"
	restrict_job = list("UNSC Aegis Ship Crew","UNSC Aegis Commanding Officer")

/datum/spawnpoint/prowlerodst_crew/New()
	..()
	turfs = GLOB.prowlerodst_crew_spawns

/obj/effect/landmark/start/prowlerodst_crew
	name = "UNSC Aegis Ship Crew Spawn"

/obj/effect/landmark/start/prowlerodst_crew/New()
	..()
	GLOB.prowlerodst_crew_spawns += loc


//UNSC Aegis ODST Spawnpoints

GLOBAL_LIST_EMPTY(prowlerodst_odst_spawns)

/datum/spawnpoint/prowlerodst_odst
	display_name = "UNSC Aegis ODST Spawn"
	restrict_job = list("''ONI'' Orbital Drop Shock Trooper")

/datum/spawnpoint/prowlerodst_odst/New()
	..()
	turfs = GLOB.prowlerodst_odst_spawns

/obj/effect/landmark/start/prowlerodst_odst
	name = "UNSC Aegis ODST Spawn"

/obj/effect/landmark/start/prowlerodst_odst/New()
	..()
	GLOB.prowlerodst_odst_spawns += loc


GLOBAL_LIST_EMPTY(prowlerodst_ftl_spawns)


GLOBAL_LIST_EMPTY(prowlerodst_officer_spawns)

/datum/spawnpoint/prowlerodst_officer
	display_name = "UNSC Aegis ODST Officer Spawn"
	restrict_job = list("''ONI'' Orbital Drop Shock Trooper Officer")

/datum/spawnpoint/prowlerodst_officer/New()
	..()
	turfs = GLOB.prowlerodst_officer_spawns

/obj/effect/landmark/start/prowlerodst_officer
	name = "UNSC Aegis ODST Officer Spawn"

/obj/effect/landmark/start/prowlerodst_officer/New()
	..()
	GLOB.prowlerodst_officer_spawns += loc