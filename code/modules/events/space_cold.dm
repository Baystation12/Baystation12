datum/event/space_cold/start()
	var/list/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in GLOB.player_list)
		if(G.client && G.stat != DEAD && !G.species.get_virus_immune(G))
			candidates += G

	if(!candidates.len)
		return

	var/datum/disease2/disease/sniffle = new
	if(prob(60))
		sniffle.max_stage = 3
		sniffle.makerandom(VIRUS_MILD)
		sniffle.spreadtype = "Airborne"
	else
		if(prob(75))
			sniffle.max_stage = 3
			sniffle.makerandom(VIRUS_COMMON)
			sniffle.spreadtype = "Airborne"
		else
			if(prob(75))
				sniffle.max_stage = 3
				sniffle.makerandom(VIRUS_ENGINEERED)
				if(prob(50))
					sniffle.spreadtype = "Airborne"
				else
					sniffle.spreadtype = "Contact"
			else
				sniffle.max_stage = 4
				sniffle.makerandom(VIRUS_ENGINEERED)
				if(prob(25))
					sniffle.spreadtype = "Airborne"
				else
					sniffle.spreadtype = "Contact"

	var/victims = min(rand(1,3), candidates.len)
	while(victims)
		infect_virus2(pick_n_take(candidates),sniffle,1)
		victims--
