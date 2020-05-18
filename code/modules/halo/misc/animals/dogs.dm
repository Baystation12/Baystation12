/mob/living/simple_animal/dog
	name = "\improper Dog"
	real_name ="Dog"
	desc = "It's a dog."
	icon = 'code/modules/halo/misc/animals/dogs.dmi'
	icon_state = "german_shep"
	icon_living = "german_shep"
	icon_dead = "german_shep_dead"
	speak = list("Bark!","Arf!","Bork!")
	speak_emote = list("barks", "woofs")
	emote_hear = list("barks", "woofs", "yaps","pants")
	emote_see = list("shakes its head", "shivers")
	speak_chance = 1
	turns_per_move = 10
	response_help  = "pets"
	response_disarm = "bops"
	response_harm   = "kicks"
	see_in_dark = 5
	pass_flags = PASSTABLE
	mob_size = MOB_MEDIUM

/mob/living/simple_animal/dog/New()
	. = ..()
	if(prob(50))
		icon_state = "german_shep2"
		icon_living = "german_shep2"
		icon_dead = "german_shep2_dead"


/mob/living/simple_animal/dog/battledog
	name = "\improper Dog"
	desc = "It's a battledog."
	icon_state = "battle_gshep"
	icon_living = "battle_gshep"
	icon_dead = "battle_gshep_d"
	pass_flags = PASSTABLE
	mob_size = MOB_MEDIUM

	speak = list("Bark!","Arf!","Bork!")

/mob/living/simple_animal/dog/pmc
	name = "\improper Dog"
	desc = "It's a battledog. This has a black pelt and sports a fancy, white beret with a blue insignia. Better not anger a potential veteran, this one looks like he could get out of a room with your forearm."
	icon_state = "pmc_gshep"
	icon_living = "pmc_gshep"
	icon_dead = "pmc_gshep_d"
	pass_flags = PASSTABLE
	mob_size = MOB_MEDIUM

	speak = list("Bark!","Arf!","Bork!")

/mob/living/simple_animal/dog/odst
	name = "\improper ODST Dog"
	desc = "This is an ODST Dog. Commonly referred to as ODSD, which stands for Orbital Drop Shock Dog. Helljumping has never been so badass until the squad got the opportunity to bring a pack of dogs for the trip."
	icon_state = "odst_gshep"
	icon_living = "odst_gshep"
	icon_dead = "odst_gshep_d"
	faction = "UNSC"
	pass_flags = PASSTABLE
	mob_size = MOB_MEDIUM

	speak = list("Bark!","Arf!","Bork!")

//Thanks to Fingerspitzengefühl#9389 on discord for the sprites.