/mob/living/simple_animal/hostile/battledog
	name = "\improper Combat Dog"
	real_name = "Dog"
	faction = "UNSC"
	desc = "It's a battledog trained to take down man sized targets."
	icon = 'code/modules/halo/unsc/dogs.dmi'
	icon_state = "battle_gshep"
	icon_living = "battle_gshep"
	icon_dead = "battle_gshep_d"
	speak = list("Bark!","Arf!","Bork!")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks", "woofs", "yaps","pants")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 10
	speed = 4
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	see_in_dark = 5
	pass_flags = PASSTABLE
	mob_size = MOB_MEDIUM

	health = 75
	maxHealth = 75

	attacktext = "mauls"
	attack_sound = 'sound/weapons/bite.ogg'

	harm_intent_damage = 5
	melee_damage_lower = 35
	melee_damage_upper = 45
	combat_tier = 1

/mob/living/simple_animal/hostile/battledog/pmc
	name = "\improper Veteran Combat Dog"
	desc = "It's a battledog trained to take down man sized targets. This has a black pelt and sports a fancy, white beret with a blue insignia. Better not anger a potential veteran, this one looks like he could get out of a room with your forearm."
	icon_state = "pmc_gshep"
	icon_living = "pmc_gshep"
	icon_dead = "pmc_gshep_d"
	resistance = 5
	health = 125
	maxHealth = 125
	pass_flags = PASSTABLE
	mob_size = MOB_MEDIUM
	combat_tier = 2

	speak = list("Bark!","Arf!","Bork!")

/mob/living/simple_animal/hostile/battledog/odst
	name = "\improper Advanced Combat Dog"
	desc = "This is an ODST Dog. Commonly referred to as ODSD, which stands for Orbital Drop Shock Dog. Helljumping has never been so badass until the squad got the opportunity to bring a pack of dogs for the trip."
	icon_state = "odst_gshep"
	icon_living = "odst_gshep"
	icon_dead = "odst_gshep_d"
	pass_flags = PASSTABLE
	mob_size = MOB_MEDIUM
	resistance = 10
	health = 125
	maxHealth = 125
	combat_tier = 3

	speak = list("Bark!","Arf!","Bork!")

//Thanks to Fingerspitzengefühl#9389 on discord for the sprites.