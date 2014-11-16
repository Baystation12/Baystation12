datum/event/viral_infection/setup()
	announceWhen = rand(0, 3000)
	endWhen = announceWhen + 1

datum/event/viral_infection/announce()
	command_announcement.Announce("Confirmed outbreak of level five biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak5.ogg')

datum/event/viral_infection/start()
	var/list/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in player_list)
		if(G.client && G.stat != DEAD)
			candidates += G
	if(!candidates.len)	return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

	severity = severity == 1 ? 1 : severity - 1
	var/actual_severity = severity * rand(1, 3)
	while(actual_severity > 0 && candidates.len)
		infect_mob_random_lesser(candidates[1])
		candidates.Remove(candidates[1])
		actual_severity--
