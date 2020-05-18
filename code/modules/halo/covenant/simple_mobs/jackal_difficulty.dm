
mob/living/simple_animal/hostile/covenant/jackal/shield/apply_difficulty_setting()
	//apply difficulty
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_HEROIC)
			if(shield_max)
				shield_max += 200
		if(DIFFICULTY_LEGENDARY)
			if(shield_max)
				shield_max += 400
				recharge_rate *= 2
