/mob/living/simple_animal/hostile/velociraptor
	name = "velociraptor"
	desc = "Don't go in the tall grass."
	icon = 'code/modules/halo/misc/animals/animal_big.dmi'
	icon_state = "velociraptor"
	icon_living = "velociraptor"
	icon_dead = "velociraptor_dead"
	meat_amount = 2
	speed = 1
	mob_size = MOB_LARGE
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat

	health = 75
	maxHealth = 75

	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'

	harm_intent_damage = 5
	melee_damage_lower = 20
	melee_damage_upper = 25
