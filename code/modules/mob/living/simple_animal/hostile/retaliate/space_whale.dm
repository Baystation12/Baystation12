/mob/living/simple_animal/hostile/retaliate/space_whale
	name = "space whale"
	desc = "A majestic spaceborne cetacean. A true sight to behold."
	icon = 'icons/mob/simple_animal/space_whale.dmi'
	icon_state = "alive"
	icon_dead = "dead"

	health = 250
	maxHealth = 250
	meat_amount = 60
	skin_amount = 15

	min_gas = null
	max_gas = null
	minbodytemp = 0

	turns_per_move = 10
	attack_delay = 2 SECONDS
	move_to_delay = 2 SECONDS

	mob_size = MOB_LARGE
	mob_bump_flag = HEAVY
	mob_swap_flags = HEAVY
	mob_push_flags = ALLMOBS
	can_escape = TRUE

	faction = "whales"
	natural_weapon = /obj/item/natural_weapon/whalebone
	response_help = "strokes"
	response_disarm = "bumps"
	response_harm = "strikes"

	natural_armor = list(melee = ARMOR_MELEE_RESISTANT,
						bullet = ARMOR_BALLISTIC_SMALL)

	var/chosen_color
	var/species_colors = list(COLOR_COMMAND_BLUE, COLOR_PURPLE, COLOR_DARK_BLUE_GRAY, COLOR_PALE_PINK)
	var/mob/living/simple_animal/passive/juvenile_space_whale/baby

	ai_holder = /datum/ai_holder/simple_animal/retaliate
	say_list_type = /datum/say_list/space_whale

/obj/item/natural_weapon/whalebone
	name = "head"
	attack_verb = list("ramed")
	force = 37

/mob/living/simple_animal/hostile/retaliate/space_whale/Initialize()
	. = ..()
	if(prob(1))
		name = "Moby Dick"
		return
	if(prob(2))
		color = pick(species_colors)

/mob/living/simple_animal/hostile/retaliate/space_whale/set_dir()
	..()
	switch(dir)
		if(NORTH, SOUTH)
			bound_height = 128
			bound_width = 64
		if(EAST, WEST)
			bound_height = 64
			bound_width = 128

// /mob/living/simple_animal/hostile/retaliate/space_whale/Retaliate() //So they dont become hostile when spawned and thrown in migration event.
// 	if(!(health < (maxHealth - 5)))
// 		return
// 	..()

// /mob/living/simple_animal/hostile/retaliate/space_whale/ValidTarget(var/mob/M)
// 	. = ..()
// 	if(istype(M, /mob/living/simple_animal/passive/juvenile_space_whale))
// 		return FALSE

/mob/living/simple_animal/hostile/retaliate/space_whale/Allow_Spacemove()
	return TRUE

/datum/say_list/space_whale
	emote_hear = list("vocalises", "sings", "hums")
	emote_see = list("flaps around", "rolls")
