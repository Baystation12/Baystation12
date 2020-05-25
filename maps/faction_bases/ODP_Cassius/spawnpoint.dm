
/datum/spawnpoint/unsc_base
	restrict_job_type = list(\
	/datum/job/unsc/marine,
	/datum/job/unsc/marine/specialist,
	/datum/job/unsc/marine/squad_leader,
	/datum/job/unsc/commanding_officer,
	/datum/job/unsc/executive_officer,
	/datum/job/unsc/oni/research,
	/datum/job/unsc/odst,
	/datum/job/unsc/odst/squad_leader)

GLOBAL_LIST_EMPTY(unsc_base_fallback_spawns)

/datum/spawnpoint/unsc_base_fallback
	display_name = "UNSC Base Fallback Spawns"
	restrict_job_type = list(\
	/datum/job/unsc/marine,
	/datum/job/unsc/marine/specialist,
	/datum/job/unsc/marine/squad_leader,
	/datum/job/unsc/commanding_officer,
	/datum/job/unsc/executive_officer,
		/datum/job/unsc/oni/research,
	/datum/job/unsc/odst,
	/datum/job/unsc/odst/squad_leader)

/datum/spawnpoint/unsc_base_fallback/New()
	..()
	turfs = GLOB.unsc_base_fallback_spawns

/obj/effect/landmark/start/unsc_base_fallback
	name = "UNSC Base Fallback Spawns"

/obj/effect/landmark/start/unsc_base_fallback/New()
	..()
	GLOB.unsc_base_fallback_spawns += loc
