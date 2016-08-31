/obj/team_start
	name = "team start"
	invisibility = 101
	density = 0
	anchored = 1
	var/team = 0
	var/active = 1

	New()
		..()
		var/area/ship_battle/A = get_area(src)
		if(A && istype(A))
			team = A.team

/datum/controller/occupations/proc/LateSpawn(var/client/C, var/rank, var/return_location = 0)
	//spawn at one of the latespawn locations


	var/datum/spawnpoint/spawnpos

	if(!C)
		CRASH("Null client passed to LateSpawn() proc!")

	var/mob/H = C.mob
	var/datum/job/space_battle/job = GetJob(rank)
	for(var/obj/team_start/S in world)
		var/area/ship_battle/A = get_area(S)
		if(A && istype(A))
			if(A.team == job.team)
				if(return_location)
					return get_turf(S)
				else
					if(H)
						H.forceMove(get_turf(S))
						return "has teleported into team [job.team]"

	spawnpos = spawntypes[C.prefs.spawnpoint]

	if(spawnpos && istype(spawnpos))
		if(spawnpos.check_job_spawning(rank))
			if(return_location)
				return pick(spawnpos.turfs)
			else
				if(H)
					H.forceMove(pick(spawnpos.turfs))
				return spawnpos.msg
		else
			if(return_location)
				return pick(latejoin)
			else
				if(H)
					H << "Your chosen spawnpoint ([spawnpos.display_name]) is unavailable for your chosen job. Spawning you at the default spawn point instead."
					H.forceMove(pick(latejoin))
				return "has teleported nearby."
	else
		if(return_location)
			return pick(latejoin)
		else
			if(H)
				H.forceMove(pick(latejoin))
			return "has teleported nearby."
