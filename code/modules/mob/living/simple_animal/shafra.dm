/mob/living/simple_animal/shafra
	name = "Shafra"
	real_name = "Shafra"
	desc = "A Bogani Hunting Dog"
	icon = 'icons/mob/shafra.dmi'
	icon_state = "shafra"
	icon_living = "shafra"
	icon_dead = "shafra_dead"
	maxHealth = 100
	health = 100
	universal_speak = 1
	speak_emote = list("harks")
	emote_hear = list("growls")
	response_help  = "barks"
	response_disarm = "shoves"
	response_harm   = "mauls"
	melee_damage_lower = 25
	melee_damage_upper = 35
	attacktext = "mauls and claws with all its might!"
	minbodytemp = 90
	maxbodytemp = 1000

	speed = 2