
/mob/living/simple_animal/hostile/covenant/elite/getRollDist()
	. = ..()
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_EASY)
			return 2
		if(DIFFICULTY_NORMAL)
			return 2
		if(DIFFICULTY_HEROIC)
			return 3
		if(DIFFICULTY_LEGENDARY)
			return 4

mob/living/simple_animal/hostile/covenant/elite/getPerRollDelay()
	. = ..()
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_EASY)
			return 2
		if(DIFFICULTY_NORMAL)
			return 1
		if(DIFFICULTY_HEROIC)
			return 0
		if(DIFFICULTY_LEGENDARY)
			return -1

mob/living/simple_animal/hostile/covenant/elite/apply_difficulty_setting()
	. = ..()
	//apply difficulty
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_HEROIC)
			if(shield_max)
				shield_max += 50
		if(DIFFICULTY_LEGENDARY)
			if(shield_max)
				shield_max += 100
				recharge_rate *= 2
