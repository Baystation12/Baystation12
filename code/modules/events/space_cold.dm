datum/event/space_cold/start()
	var/list/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in player_list)
		if(G.client && G.stat != DEAD && !G.species.get_virus_immune(G))
			candidates += G

	if(!candidates.len)
		return

	var/datum/disease2/disease/sniffle = new
	sniffle.max_stage = 3
	sniffle.makerandom(1)
	sniffle.spreadtype = "Airborne"

	var/victims = min(rand(1,3), candidates.len)
	while(victims)
		infect_virus2(pick_n_take(candidates),sniffle,1)
		victims--
