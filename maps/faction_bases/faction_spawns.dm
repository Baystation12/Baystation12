


/* COVENANT BASE */

GLOBAL_LIST_EMPTY(covenant_base_spawns)

/datum/spawnpoint/cov_base
	display_name = "Covenant Base Spawns"
	restrict_job_type = list(\
		/datum/job/covenant/skirmminor,\
		/datum/job/covenant/skirmmajor,\
		/datum/job/covenant/skirmmurmillo,\
		/datum/job/covenant/skirmcommando,\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_honour_guard,\
		/datum/job/covenant/sangheili_shipmaster,\
		/datum/job/covenant/lesser_prophet,\
		/datum/job/covenant/kigyarminor,\
		/datum/job/covenant/kigyarmajor,
		/datum/job/covenant/kigyarcorvette/captain,\
		/datum/job/covenant/unggoy_minor,\
		/datum/job/covenant/unggoy_major)

/datum/spawnpoint/cov_base/New()
	..()
	turfs = GLOB.covenant_base_spawns

/obj/effect/landmark/start/cov_base
	name = "Covenant Base Spawns"

/obj/effect/landmark/start/cov_base/New()
	..()
	GLOB.covenant_base_spawns += loc



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



/* INNIE BASE */

GLOBAL_LIST_EMPTY(innie_base_spawns)

/datum/spawnpoint/innie_base
	display_name = "Innie Base Spawns"
	restrict_job_type = list(\
		/datum/job/ship_crew_innie,\
		/datum/job/ship_cap_innie,\
		/datum/job/URF_commando,\
		/datum/job/URF_commando_officer)

/datum/spawnpoint/innie_base/New()
	..()
	turfs = GLOB.innie_base_spawns

/obj/effect/landmark/start/innie_base
	name = "Innie Base Spawns"

/obj/effect/landmark/start/innie_base/New()
	..()
	GLOB.innie_base_spawns += loc