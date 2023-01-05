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
	var/list/restrict_job = null
	var/list/disallow_job = null

/datum/spawnpoint/proc/check_job_spawning(job)

	if(job && !istext(job)) //Cuz checking job titles
		crash_with("Somebody tried to check job spawning not by job title.")
		return FALSE

	if(restrict_job && !(job in restrict_job))
		return 0

	if(disallow_job && (job in disallow_job))
		return 0

	return 1

/datum/spawnpoint/proc/can_spawn_here(mob/M, datum/job/job = null)
	. = TRUE
	if(job)
		var/job_spawning_check = any2bool(check_job_spawning(job.title))
		if(!job_spawning_check)
			to_chat(M, SPAN_WARNING("Your chosen spawnpoint ([display_name]) is unavailable for your chosen job ([job.title]). Spawning you at another spawn point instead."))
		. = . && job_spawning_check

/datum/spawnpoint/cryo/can_spawn_here(mob/M, datum/job/job = null)
	. = ..()

	if(.)
		var/list/spots = list()
		var/list/areas = list()
		for(var/turf/t in turfs)
			if(isturf(t))
				var/area/Ar = get_area(t)
				if(isarea(Ar) && !(Ar in areas))
					areas.Add(Ar)
		for(var/area/Area in areas)
			if(isarea(Area)) //equal if(A), but at the same time check isarea this shit
				for(var/obj/machinery/cryopod/C in Area)
					if(!C.occupant)
						spots += C
		var/Have_Availible_Place = any2bool(length(spots))
		if(M && !Have_Availible_Place)
			to_chat(M, SPAN_WARNING("No avalible cryopods to spawn at, spawning in another accessible spawnpoint."))
		. = . && Have_Availible_Place


//Called after mob is created, moved to a turf and equipped.
/datum/spawnpoint/proc/after_join(mob/victim)
	return

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
	disallow_job = list("Robot")

/datum/spawnpoint/cryo/New()
	..()
	turfs = GLOB.latejoin_cryo

/datum/spawnpoint/cyborg
	display_name = "Cyborg Storage"
	msg = "has been activated from storage"
	restrict_job = list("Robot")

/datum/spawnpoint/cyborg/New()
	..()
	turfs = GLOB.latejoin_cyborg

/datum/spawnpoint/default
	display_name = DEFAULT_SPAWNPOINT_ID
	msg = "has arrived on the station"
	always_visible = TRUE
