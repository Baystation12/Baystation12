/mob/living/simple_animal/hostile/aquatic/shark
	name = "shark"
	desc = "A ferocious fish with many, many teeth."
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	maxHealth = 150
	health = 150
	natural_weapon = /obj/item/natural_weapon/bite/shark
	break_stuff_probability = 15
	faction = "sharks"

	meat_type = /obj/item/reagent_containers/food/snacks/fish/shark
	meat_amount = 5
	bone_amount = 15
	skin_amount = 15
	bone_material = MATERIAL_BONE_CARTILAGE
	skin_material = MATERIAL_SKIN_SHARK

/obj/item/natural_weapon/bite/shark
	force = 20
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
	natural_weapon = /obj/item/natural_weapon/bite/giantshark
	break_stuff_probability = 35

	meat_amount = 10
	bone_amount = 30
	skin_amount = 30

/obj/item/natural_weapon/bite/giantshark
	force = 40 