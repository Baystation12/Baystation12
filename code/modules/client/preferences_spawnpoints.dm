GLOBAL_VAR(spawntypes)

/proc/spawntypes()
	if(!GLOB.spawntypes)
		GLOB.spawntypes = list()
		for(var/type in typesof(/datum/spawnpoint)-/datum/spawnpoint)
			var/datum/spawnpoint/S = type
			var/display_name = initial(S.display_name)
			if((display_name in GLOB.using_map.allowed_spawns) || initial(S.always_visible))
				GLOB.spawntypes[display_name] = new S
	return GLOB.spawntypes

/datum/spawnpoint
	var/msg		  //Message to display on the arrivals computer.
	var/list/turfs   //List of turfs to spawn on.
	var/display_name //Name used in preference setup.
	var/always_visible = FALSE	// Whether this spawn point is always visible in selection, ignoring map-specific settings.
	var/restrict_spawn_faction
	var/list/restrict_job = null
	var/list/restrict_job_type = null
	var/list/disallow_job = null
	var/list/disallow_job_type = null
	var/disable_atmos_unsafe = 1
	var/list/unsafe_turfs

/datum/spawnpoint/proc/check_job_spawning(job)
	if(restrict_job && !(job in restrict_job))
		return 0

	if(disallow_job && (job in disallow_job))
		return 0

	//this is a bit hacky but its a convenience job
	var/datum/job/cur_job = job_master.GetJob(job)
	if(restrict_job_type && !(cur_job.type in restrict_job_type))
		return 0

	if(disallow_job_type && (cur_job.type in disallow_job_type))
		return 0

	if(restrict_spawn_faction && cur_job.spawn_faction != restrict_spawn_faction)
		return 0

	if(!turfs)
		return 0

	if(disable_atmos_unsafe)
		var/list/newly_dangerous_turfs = list()
		if(!unsafe_turfs)
			unsafe_turfs = list()
		if(turfs)
			for(var/turf/T in turfs)
				if(IsTurfAtmosUnsafe(T))
					newly_dangerous_turfs += T

			for(var/turf/T in unsafe_turfs)
				if(IsTurfAtmosSafe(T))
					unsafe_turfs -= T
					turfs += T

			unsafe_turfs.Add(newly_dangerous_turfs)
			if(newly_dangerous_turfs.len)
				message_admins("NOTICE: spawnpoint \'[src.type]\' has new atmos unsafe turfs.")

	if(!turfs.len)
		return 0

	return 1

#ifdef UNIT_TEST
/datum/spawnpoint/Del()
	crash_with("Spawn deleted: [log_info_line(src)]")
	..()

/datum/spawnpoint/Destroy()
	crash_with("Spawn destroyed: [log_info_line(src)]")
	. = ..()
#endif

/datum/spawnpoint/arrivals
	display_name = "Arrivals Shuttle"
	msg = "has arrived on the station"

/datum/spawnpoint/arrivals/New()
	..()
	turfs = GLOB.latejoin

/datum/spawnpoint/gateway
	display_name = "Gateway"
	msg = "has completed translation from offsite gateway"

/datum/spawnpoint/gateway/New()
	..()
	turfs = GLOB.latejoin_gateway

/datum/spawnpoint/cryo
	display_name = "Cryogenic Storage"
	msg = "has completed cryogenic revival"
	disallow_job = list("Cyborg")

/datum/spawnpoint/cryo/New()
	..()
	turfs = GLOB.latejoin_cryo

/datum/spawnpoint/cyborg
	display_name = "Cyborg Storage"
	msg = "has been activated from storage"
	restrict_job = list("Cyborg")

/datum/spawnpoint/cyborg/New()
	..()
	turfs = GLOB.latejoin_cyborg

/datum/spawnpoint/default
	display_name = DEFAULT_SPAWNPOINT_ID
	msg = "has arrived on the station"
	always_visible = TRUE

/datum/spawnpoint/default/New()
	..()
	turfs = GLOB.latejoin
