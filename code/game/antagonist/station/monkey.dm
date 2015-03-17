/datum/antagonist/monkey
	role_text = "Rabid Monkey"
	role_text_plural = "Rabid Monkeys"
	id = MODE_MONKEY

	// Notes towards a monkey mode to reduce snowflakes for downstream. Will not compile.

	for(var/datum/disease/D in M.viruses)
		if(istype(D, /datum/disease/jungle_fever))
			if (ticker.mode.config_tag == "monkey")
				return 2
			return 1