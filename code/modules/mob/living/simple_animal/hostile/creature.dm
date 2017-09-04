/mob/living/simple_animal/hostile/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/critter.dmi'
	speak_emote = list("gibbers")
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing-dead"
	health = 80
	maxHealth = 80
	melee_damage_lower = 25
	melee_damage_upper = 50
	attacktext = "chomped"
	attack_sound = 'sound/weapons/bite.ogg'
	faction = "creature"
	speed = 4

/mob/living/simple_animal/hostile/creature/cult
	faction = "cult"

	min_gas = null
	max_gas = null
	minbodytemp = 0

	supernatural = 1

/mob/living/simple_animal/hostile/creature/cult/cultify()
	return
