
/mob/living/simple_animal/hostile/covenant/grunt/major/apply_difficulty_setting()
	. = ..()
	//apply difficulty
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_LEGENDARY)
			possible_weapons = list(/obj/item/weapon/gun/energy/plasmarifle)

/mob/living/simple_animal/hostile/covenant/grunt/heavy/apply_difficulty_setting()
	. = ..()
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_LEGENDARY)
			//always spawn with fuel rod launcher
			possible_weapons = list(/obj/item/weapon/gun/projectile/fuel_rod)

/mob/living/simple_animal/hostile/covenant/grunt/ultra/apply_difficulty_setting()
	. = ..()
	//apply difficulty
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_HEROIC)
			shield_max += 25
		if(DIFFICULTY_LEGENDARY)
			shield_max += 50
			recharge_rate *= 2
			possible_weapons = list(/obj/item/weapon/gun/energy/plasmarepeater)

mob/living/simple_animal/hostile/covenant/grunt/getPerRollDelay()
	. = ..()
	switch(GLOB.difficulty_level)
		if(DIFFICULTY_EASY)
			return 3
		if(DIFFICULTY_NORMAL)
			return 2
		if(DIFFICULTY_HEROIC)
			return 1
		if(DIFFICULTY_LEGENDARY)
			return 0
