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

/datum/spawnpoint/proc/check_job_spawning(var/datum/job/job_datum, var/joined_late = 0)

	if(!job_datum)
		return "invalid job (NULL)"

	if(restrict_job && !(job_datum.title in restrict_job))
		return "restricted job"

	if(disallow_job && (job_datum.title in disallow_job))
		return "disallowed job"

	//dont worry about checking this for now
	/*
	if(joined_late && !job_datum.latejoin_at_spawnpoints)
		return "attempting to latespawn when job latespawning not allowed"
		*/

	if(restrict_job_type && !(job_datum.type in restrict_job_type))
		return "restricted job type"

	if(disallow_job_type && (job_datum.type in disallow_job_type))
		return "disallowed job type"

	if(restrict_spawn_faction && job_datum.spawn_faction != restrict_spawn_faction)
		return "restricted spawn faction"

	if(!turfs)
		return "no turfs generated"

	if(disable_atmos_unsafe)
		var/list/newly_dangerous_turfs = list()
		if(!unsafe_turfs)
			unsafe_turfs = list()
		if(turfs)
			var/list/unsafe_reasons = list()
			for(var/turf/T in turfs)
				var/list/new_reasons = IsTurfAtmosUnsafe(T, 1)
				if(new_reasons.len)
					newly_dangerous_turfs += T
				unsafe_reasons |= new_reasons
			turfs -= newly_dangerous_turfs

			for(var/turf/T in unsafe_turfs)
				if(IsTurfAtmosSafe(T))
					unsafe_turfs -= T
					turfs += T

			unsafe_turfs.Add(newly_dangerous_turfs)
			if(newly_dangerous_turfs.len)
				message_admins("NOTICE: spawnpoint \'[src.type]\' has new atmos unsafe turfs, disabling spawns for those turfs ([english_list(unsafe_reasons)]).")

	//check if there are any valid turfs for this spawnpoint
	if(!turfs.len)
		//see if there is special handling for this job and spawn combo
		var/turf/spawnturf = get_spawn_turf(job_datum.title)
		if(!spawnturf)
			return "no valid turfs detected"

	return 0

/datum/spawnpoint/proc/get_spawn_turf(var/rank)
	if(turfs && turfs.len)
		return pick(turfs)

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
	turfs = GLOB.start_turfs

/datum/spawnpoint/default/get_spawn_turf(var/rank)
	var/obj/S = get_job_landmark(rank)
	if(S)
		return S.loc
	else
		return ..()

/datum/spawnpoint/default/proc/get_job_landmark(var/rank)
	var/list/loc_list = list()
	for(var/obj/effect/landmark/start/sloc in landmarks_list)
		if(sloc.name != rank)	continue
		if(locate(/mob/living) in sloc.loc)	continue
		loc_list += sloc
	if(loc_list.len)
		return pick(loc_list)
	else
		return locate("start*[rank]") // use old stype
