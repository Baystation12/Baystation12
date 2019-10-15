
/datum/faction/random_criminal
	defender_mob_types = list(\
		/mob/living/simple_animal/hostile/syndicate = 3,\
		/mob/living/simple_animal/hostile/syndicate/ranged = 1,\
		/mob/living/simple_animal/hostile/syndicate/ranged/space = 1)

/datum/faction/random_criminal/New()
	name = "[random_syndicate_name()]"
	GLOB.criminal_factions.Add(src)
	GLOB.criminal_factions_by_name[name] = src
	. = ..()

	/*
	switch(pick(1,2,3))
		if(1)
			defender_mob_types = list(\
				/mob/living/simple_animal/hostile/russian = 3,\
				/mob/living/simple_animal/hostile/russian/ranged,\
				/mob/living/simple_animal/hostile/bear = 2)
		if(2)
			defender_mob_types = list(\
				/mob/living/simple_animal/hostile/pirate = 3,\
				/mob/living/simple_animal/hostile/pirate/ranged,\
				/mob/living/simple_animal/hostile/carp = 2)
		if(3)
			defender_mob_types = list(\
				/mob/living/simple_animal/hostile/syndicate = 3,\
				/mob/living/simple_animal/hostile/syndicate/melee = 2,\
				/mob/living/simple_animal/hostile/syndicate/melee/space = 2,\
				/mob/living/simple_animal/hostile/syndicate/ranged = 1,\
				/mob/living/simple_animal/hostile/syndicate/ranged/space = 1)
*/