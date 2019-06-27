/mob/living/simple_animal/hostile/jaguar
	name = "jaguar"
	desc = "Don't go in the tall grass."
	icon = 'code/modules/halo/misc/animals/animal_big.dmi'
	icon_state = "jaguar"
	icon_living = "jaguar"
	icon_dead = "jaguar_dead"
	meat_amount = 4
	speed = 3
	mob_size = MOB_LARGE
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	health = 100
	maxHealth = 100

	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 40
