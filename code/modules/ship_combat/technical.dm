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

/datum/controller/occupations/proc/LateSpawn(var/client/C, var/rank, var/return_location = 0, var/obj/machinery/space_battle/ship_core/core)
	//spawn at one of the latespawn locations


	var/datum/spawnpoint/spawnpos

	if(!C)
		CRASH("Null client passed to LateSpawn() proc!")

	var/mob/H = C.mob
	var/team = 0
	switch(rank)
		if("Team One Sailor")
			team = 1
		if("Team Two Sailor")
			team = 2
		if("Team Three Sailor")
			team = 3
		if("Team Four Sailor")
			team = 4
	if(team)
		sleep(0)
		for(var/obj/team_start/S in world)
			if(S.z == core.z && S.team == team)
				if(return_location)
					return get_turf(S)
				else
					if(H)
						H.forceMove(get_turf(S))
						return "has teleported into team [team]"
			else continue

	else if(C.prefs.spawnpoint)
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
