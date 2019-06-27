/mob/living/simple_animal/hostile/alligator
	name = "alligator"
	desc = "Living off refuse with no natural predators deep underground has let it grow huge."
	icon = 'code/modules/halo/misc/animals/animal_big.dmi'
	icon_state = "alligator"
	icon_living = "alligator"
	icon_dead = "alligator_dead"
	meat_amount = 4
	speed = 6
	mob_size = MOB_LARGE
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	health = 125
	maxHealth = 125

	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	harm_intent_damage = 5
	melee_damage_lower = 35
	melee_damage_upper = 45
