/mob/living/simple_animal/hostile/retaliate/aquatic
	icon = 'icons/mob/simple_animal/aquatic.dmi'
	meat_type = /obj/item/reagent_containers/food/snacks/fish
	turns_per_move = 5
	natural_weapon = /obj/item/natural_weapon/bite
	speed = 4
	mob_size = MOB_MEDIUM
	emote_see = list("gnashes")

	// They only really care if there's water around them or not.
	max_gas = list()
	min_gas = list()
	minbodytemp = 0

/mob/living/simple_animal/hostile/retaliate/aquatic/Life()
	if(!submerged())
		if(icon_state == icon_living)
			icon_state = "[icon_living]_dying"
		walk(src, 0)
		Paralyse(3)
	. = ..()

/mob/living/simple_animal/hostile/retaliate/aquatic/handle_atmos(var/atmos_suitable = 1)
	. = ..(atmos_suitable = submerged())

/mob/living/simple_animal/hostile/retaliate/aquatic/can_act()
	. = ..() && submerged()
