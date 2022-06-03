/mob/living/simple_animal/passive/juvenile_space_whale
	name = "juvenile space whale"
	desc = "A majestic spaceborne cetacean. This one is a little baby."
	icon = 'icons/mob/simple_animal/juvenile_space_whale.dmi'
	icon_state = "alive"
	icon_dead = "dead"

	health = 80
	maxHealth = 80
	meat_amount = 25
	skin_amount = 6

	min_gas = null
	max_gas = null
	minbodytemp = 0

	turns_per_move = 4

	mob_size = MOB_MEDIUM
	mob_bump_flag = HEAVY
	mob_swap_flags = HEAVY
	mob_push_flags = ALLMOBS
	can_escape = TRUE

	faction = "whales"
	response_help = "strokes"
	response_disarm = "bumps"
	response_harm = "strikes"

	natural_armor = list(melee = ARMOR_MELEE_SMALL,
						bullet = ARMOR_BALLISTIC_MINOR)

	var/mob/living/simple_animal/hostile/retaliate/space_whale/parent

	ai_holder = /datum/ai_holder/simple_animal/passive
	say_list_type = /datum/say_list/juvenile_space_whale

/mob/living/simple_animal/passive/juvenile_space_whale/New()
	..()
	var/mob/living/simple_animal/hostile/retaliate/space_whale/W = locate() in viewers(src, 7)
	if(W && !parent && !W.baby)
		W.baby = src
		parent = W
		color = parent.color

/mob/living/simple_animal/passive/juvenile_space_whale/Life()
	. = ..()
	if(!.)
		return FALSE
	if(parent && parent.stat != DEAD)
		if(parent.stance == STANCE_IDLE && (pulledby || length(grabbed_by)))
			var/enemies = pulledby ? list(pulledby) : grabbed_by
			parent.ai_holder.attackers += enemies
		if(health < (maxHealth - 5))
			walk_to(src, parent, 1, 1 SECONDS)
			if(parent.stance == STANCE_IDLE && ai_holder.attackers.len)
				parent.ai_holder.react_to_attack(pick(ai_holder.attackers))
		else if(get_dist(src.loc, parent.loc) > 5)
			walk_to(src, parent, 4, 3 SECONDS)

/mob/living/simple_animal/passive/juvenile_space_whale/set_dir()
	..()
	switch(dir)
		if(NORTH, SOUTH)
			bound_height = 64
			bound_width = 32
		if(EAST, WEST)
			bound_height = 32
			bound_width = 64

/mob/living/simple_animal/passive/juvenile_space_whale/Allow_Spacemove()
	return TRUE

/datum/say_list/juvenile_space_whale
	emote_hear = list("vocalises", "sings", "hums")
	emote_see = list("flaps around", "rolls")
