/mob/living/simple_animal/hostile/armalis
	name = "Vox Armalis"
	desc = "In truth, this scares you."

	icon = 'icons/mob/armalis.dmi'
	icon_state = "armalis_naked"
	icon_living = "armalis_naked"
	icon_dead = "armalis_naked_dead"

	health = 125
	maxHealth = 125
	resistance = 5

	response_help   = "pats"
	response_disarm = "pushes"
	response_harm   = "hits"

	attacktext = "reaped"
	attack_sound = 'sound/effects/bamf.ogg'
	melee_damage_lower = 15
	melee_damage_upper = 20

	min_gas = null
	max_gas = null

	speed = 2

	a_intent = I_HURT

	pixel_x = -5


/mob/living/simple_animal/hostile/armalis/armored
	icon_state = "armalis_armored"
	icon_living = "armalis_armored"
	icon_dead = "armalis_armored_dead"

	health = 175
	maxHealth = 175
	resistance = 8
	speed = 3