#if !defined(ALL_SHIP_JOBS)
	#define ALL_SHIP_JOBS list() //A define so things don't throw errors due to missing define
#endif

/datum/map/unsc_frigate
	allowed_jobs = ALL_SHIP_JOBS
	allowed_spawns = list("UNSC Frigate")
