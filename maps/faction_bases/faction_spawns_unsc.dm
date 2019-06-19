
/* UNSC BASE */

GLOBAL_LIST_EMPTY(unsc_base_spawns)

/datum/spawnpoint/unsc_base
	display_name = "UNSC Base Spawns"
	restrict_job_type = list(\
		/datum/job/bertelsODST,\
		/datum/job/bertelsODSTO,\
		/datum/job/unsc_ship_marineplatoon,\
		/datum/job/bertelsunsc_ship_marine,\
		/datum/job/unsc_ship_iwo,\
		/datum/job/unscbertels_xo,\
		/datum/job/unscbertels_co,\
		/datum/job/unscbertels_medical_crew,\
		/datum/job/unscbertels_ship_crew,\
)

/datum/spawnpoint/unsc_base/New()
	..()
	turfs = GLOB.unsc_base_spawns

/obj/effect/landmark/start/unsc_base
	name = "UNSC Base Spawns"

/obj/effect/landmark/start/unsc_base/New()
	..()
	GLOB.unsc_base_spawns += loc
