/mob/living/simple_animal/hostile/aquatic/shark
	name = "shark"
	desc = "A ferocious fish with many, many teeth."
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	maxHealth = 150
	health = 150
	harm_intent_damage = 8
	melee_damage_lower = 15
	melee_damage_upper = 30
	break_stuff_probability = 15
	faction = "sharks"
	melee_damage_flags = DAM_SHARP

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/fish/shark
	meat_amount = 5
	bone_amount = 15
	skin_amount = 15
	bone_material = MATERIAL_BONE_CARTILAGE
	skin_material = MATERIAL_SKIN_SHARK

/mob/living/simple_animal/hostile/aquatic/shark/huge
	name = "gigacretoxyrhina"
	desc = "That is a lot of shark."
	icon = 'icons/mob/simple_animal/spaceshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	turns_per_move = 2
	move_to_delay = 2
	attack_same = 1
	speed = 0
	mob_size = MOB_LARGE
	pixel_x = -16
	health = 400
	maxHealth = 400
	harm_intent_damage = 5
	melee_damage_lower = 30
	melee_damage_upper = 50
	break_stuff_probability = 35

	meat_amount = 10
	bone_amount = 30
	skin_amount = 30