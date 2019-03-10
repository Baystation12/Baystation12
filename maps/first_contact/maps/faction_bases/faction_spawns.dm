


/* COVENANT BASE */

GLOBAL_LIST_EMPTY(covenant_base_spawns)

/datum/spawnpoint/cov_base
	display_name = "Covenant Base Spawns"
	restrict_job_type = list(\
		/datum/job/covenant/sangheili_minor,\
		/datum/job/covenant/sangheili_major,\
		/datum/job/covenant/sangheili_ultra,\
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
		/datum/job/ODST,\
		/datum/job/ODSTO,\
		/datum/job/UNSC_ship/commander,\
		/datum/job/UNSC_ship/exo,\
		/datum/job/UNSC_ship/cag,\
		/datum/job/UNSC_ship/bridge,
		/datum/job/UNSC_ship/mechanic_chief,\
		/datum/job/UNSC_ship/mechanic,\
		/datum/job/UNSC_ship/logistics_chief,\
		/datum/job/UNSC_ship/logistics,\
		/datum/job/UNSC_ship/marine_co,\
		/datum/job/UNSC_ship/marine_xo,\
		/datum/job/UNSC_ship/marine_sl,\
		/datum/job/UNSC_ship/weapons,\
		/datum/job/UNSC_ship/marine,\
		/datum/job/UNSC_ship/marine/driver,\
		/datum/job/UNSC_ship/medical_chief,\
		/datum/job/UNSC_ship/medical,\
		/datum/job/UNSC_ship/security_chief,\
		/datum/job/UNSC_ship/unsc_security,\
		/datum/job/UNSC_ship/ops_chief,\
		/datum/job/UNSC_ship/ops,\
		/datum/job/UNSC_ship/cmdr_wing,\
		/datum/job/UNSC_ship/cmdr_sqr,\
		/datum/job/UNSC_ship/pilot,\
		/datum/job/UNSC_ship/ai,\
		/datum/job/UNSC_ship/gunnery_chief,\
		/datum/job/UNSC_ship/gunnery,\
		/datum/job/UNSC_ship/technician_chief,\
		/datum/job/UNSC_ship/technician)

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