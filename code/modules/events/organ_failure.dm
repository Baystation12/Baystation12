datum/event/organ_failure
	var/severity = 1

datum/event/organ_failure/setup()
	announceWhen = rand(0, 300)
	endWhen = announceWhen + 1
	severity = rand(1, 3)

datum/event/organ_failure/announce()
	command_alert("Confirmed outbreak of level [rand(3,7)] biohazard aboard [station_name()]. All personnel must contain the outbreak.", "Biohazard Alert")
	world << sound('sound/AI/outbreak5.ogg')

datum/event/organ_failure/start()
	var/list/candidates = list()	//list of candidate keys
	for(var/mob/living/carbon/human/G in player_list)
		if(G.mind && G.mind.current && G.mind.current.stat != DEAD && G.health > 70)
			candidates += G
	if(!candidates.len)	return
	candidates = shuffle(candidates)//Incorporating Donkie's list shuffle

	while(severity > 0 && candidates.len)
		var/mob/living/carbon/human/C = candidates[1]

		var/acute = prob(15)
		if (prob(75))
			//internal organ infection
			var/O = pick(C.internal_organs)
			var/datum/organ/internal/I = C.internal_organs[O]
			
			if (acute)
				I.germ_level = max(INFECTION_LEVEL_TWO, I.germ_level)
			else
				I.germ_level = max(rand(INFECTION_LEVEL_ONE,INFECTION_LEVEL_ONE*2), I.germ_level)
		else
			//external organ infection
			var/datum/organ/external/O = pick(C.organs)
			
			if (acute)
				O.germ_level = max(INFECTION_LEVEL_TWO, O.germ_level)
			else
				O.germ_level = max(rand(INFECTION_LEVEL_ONE,INFECTION_LEVEL_ONE*2), O.germ_level)
			
			C.bad_external_organs |= O

		severity--
