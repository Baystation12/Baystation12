
GLOBAL_LIST_EMPTY(colony_spawns)

/datum/spawnpoint/colonist
	display_name = "Colony Arrival Shuttle"
	restrict_job = list("Colonist","Colonist - Insurrectionist Sympathiser","Colonist - Insurrectionist Recruiter","Mayor","GCPD Officer","Chief of Police")
	msg = "has arrived on the colony"

/datum/spawnpoint/colonist/New()
	..()
	turfs = GLOB.colony_spawns

/obj/effect/landmark/start/colonist
	name = "Colonist"

/obj/effect/landmark/start/colonist/New()
	..()
	GLOB.colony_spawns += loc

/obj/effect/landmark/start/colonist/inniesympathiser
	name = "Colonist - Insurrectionist Sympathiser"

/obj/effect/landmark/start/colonist/innierecruiter
	name = "Colonist - Insurrectionist Recruiter"

/obj/effect/landmark/start/colonist/mayor
	name = "Mayor"

/obj/effect/landmark/start/colonist/police
	name = "GCPD Officer"

/obj/effect/landmark/start/colonist/cop
	name = "Chief of Police"

//UNSC Landmarks + datums//

GLOBAL_LIST_EMPTY(unsc_spawns)
GLOBAL_LIST_EMPTY(unsc_leader_spawns)

/datum/spawnpoint/unsc
	display_name = "UNSC Peacekeeping Ship"
	restrict_job = list("Marine")

/datum/spawnpoint/unsc/New()
	..()
	turfs = GLOB.unsc_spawns

/obj/effect/landmark/start/unsc
	name = "Marine"

/obj/effect/landmark/start/unsc/New()
	..()
	GLOB.unsc_spawns += loc

/datum/spawnpoint/unsc/leader
	display_name = "UNSC Peacekeeping Ship - Leader Quarters"
	restrict_job = list("Marine - Squad Leader")

/datum/spawnpoint/unsc/leader/New()
	..()
	turfs = GLOB.unsc_leader_spawns

/obj/effect/landmark/start/unsc/leader
	name = "Marine - Squad Leader"

/obj/effect/landmark/start/unsc/leader/New()
	..()
	GLOB.unsc_leader_spawns += loc
