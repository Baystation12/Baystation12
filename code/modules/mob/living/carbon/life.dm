/mob/living/carbon/Life()
	if(!..())
		return

	UpdateStasis()

	// Increase germ_level regularly
	if(germ_level < GERM_LEVEL_AMBIENT && prob(30))	//if you're just standing there, you shouldn't get more germs beyond an ambient level
		germ_level++

	if(stat != DEAD && !InStasis())
		//Breathing, if applicable
		handle_breathing()

		//Mutations and radiation
		handle_mutations_and_radiation()

		//Chemicals in the body
		handle_chemicals_in_body()

		//Random events (vomiting etc)
		handle_random_events()

		//stuff in the stomach
		handle_stomach()

		// eye, ear, brain damages
		handle_disabilities()

		//all special effects, stunned, weakened, jitteryness, hallucination, sleeping, etc
		handle_statuses()

		handle_viruses()

		. = 1

		if(!client && !mind && species)
			species.handle_npc(src)
