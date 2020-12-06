/mob/living/simple_animal/aquatic
	icon = 'icons/mob/aquatic.dmi'
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/fish
	turns_per_move = 5
	attacktext = "bitten"
	attack_sound = 'sound/weapons/bite.ogg'
	speed = 4
	mob_size = MOB_SMALL
	emote_see = list("glubs", "blubs", "bloops")

	// They only really care if there's water around them or not.
	max_gas = list()
	min_gas = list()
	minbodytemp = 0

/mob/living/simple_animal/aquatic/New()
	..()
	default_pixel_x = rand(-12,12)
	default_pixel_y = rand(-12,12)
	pixel_x = default_pixel_x
	pixel_y = default_pixel_y

/mob/living/simple_animal/aquatic/Life()
	if(!loc || !loc.is_flooded(1))
		if(icon_state == icon_living)
			icon_state = "[icon_living]_dying"
		SetStunned(3)
	. = ..()

/mob/living/simple_animal/aquatic/handle_atmos(var/atmos_suitable = 1)
	. = ..(atmos_suitable = (loc && loc.is_flooded(1)))
