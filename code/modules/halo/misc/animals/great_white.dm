/mob/living/simple_animal/hostile/great_white
	name = "great white shark"
	desc = "Apex underwater predator."
	icon = 'code/modules/halo/misc/animals/animal_big.dmi'
	icon_state = "greatwhite_above"
	icon_living = "greatwhite_above"
	icon_dead = "greatwhite_dead"
	meat_amount = 6
	speed = 4
	mob_size = MOB_LARGE
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	health = 200
	maxHealth = 200

	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	harm_intent_damage = 5
	melee_damage_lower = 35
	melee_damage_upper = 45
