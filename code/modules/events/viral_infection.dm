datum/event/viral_infection
	var/list/viruses = list()

datum/event/viral_infection/setup()
	announceWhen = rand(0, 3000)
	endWhen = announceWhen + 1
	
	//generate 1-3 viruses. This way there's an upper limit on how many individual diseases need to be cured if many people are initially infected
	var/num_diseases = rand(1,3)
	for (var/i=0, i < num_diseases, i++)
		var/datum/disease2/disease/D = new /datum/disease2/disease
		
		var/greater = 0 //whether the disease is of the greater or lesser variety
		if (severity >= EVENT_LEVEL_MAJOR && prob(50))
			greater = 1
		D.makerandom(greater)
		viruses += D

datum/event/viral_infection/announce()
	command_announcement.Announce("Confirmed outbreak of level five biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert", new_sound = 'sound/AI/outbreak5.ogg')

datum/event/viral_infection/start()
	if(!viruses.len) return

	var/list/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in player_list)
		if(G.client && G.stat != DEAD)
			candidates += G
	if(!candidates.len)	return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

	severity = max(EVENT_LEVEL_MUNDANE, severity - 1)
	var/actual_severity = severity * rand(1, 3)
	while(actual_severity > 0 && candidates.len)
		infect_mob(candidates[1], pick(viruses))
		candidates.Remove(candidates[1])
		actual_severity--
