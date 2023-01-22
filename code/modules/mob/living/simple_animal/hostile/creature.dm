/mob/living/simple_animal/hostile/creature
	name = "creature"
	desc = "A sanity-destroying otherthing."
	icon = 'icons/mob/simple_animal/critter.dmi'
	speak_emote = list("невнятно бормочет")
	icon_state = "otherthing"
	icon_living = "otherthing"
	icon_dead = "otherthing-dead"
	health = 100
	maxHealth = 100
	natural_weapon = /obj/item/natural_weapon/bite/strong
	faction = "creature"
	speed = 4
	supernatural = 1

/mob/living/simple_animal/hostile/creature/cult
	faction = "cult"
	min_gas = null
	max_gas = null
	minbodytemp = 0

/mob/living/simple_animal/hostile/creature/cult/cultify()
	return
