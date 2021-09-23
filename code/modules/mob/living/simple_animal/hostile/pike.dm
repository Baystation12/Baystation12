/mob/living/simple_animal/hostile/carp/pike
	name = "space pike"
	desc = "A bigger, angrier cousin of the space carp."
	icon = 'icons/mob/simple_animal/spaceshark.dmi'
	icon_state = "shark"
	icon_living = "shark"
	icon_dead = "shark_dead"
	turns_per_move = 2
	move_to_delay = 2
	attack_same = 1
	speed = 1
	mob_size = MOB_LARGE

	pixel_x = -16

	health = 150
	maxHealth = 150

	harm_intent_damage = 5
	natural_weapon = /obj/item/natural_weapon/bite/pike
	can_escape = TRUE

	break_stuff_probability = 55

	meat_amount = 10
	bone_amount = 20
	skin_amount = 20

/obj/item/natural_weapon/bite/pike
	force = 25

/mob/living/simple_animal/hostile/carp/pike/carp_randomify()
	return

/mob/living/simple_animal/hostile/carp/pike/on_update_icon()
	return
