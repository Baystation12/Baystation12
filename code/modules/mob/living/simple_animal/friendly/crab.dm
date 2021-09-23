//Look Sir, free crabs!
/mob/living/simple_animal/passive/crab
	name = "crab"
	desc = "A hard-shelled crustacean. Seems quite content to lounge around all the time."
	icon_state = "crab"
	icon_living = "crab"
	icon_dead = "crab_dead"
	mob_size = MOB_SMALL
	speak_emote = list("clicks")
	turns_per_move = 5
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "stomps"
	friendly = "pinches"
	possession_candidate = 1
	can_escape = TRUE //snip snip
	pass_flags = PASS_FLAG_TABLE
	natural_armor = list(
		melee = ARMOR_MELEE_KNIVES
	)
	density = FALSE

	meat_amount =   3
	skin_material = MATERIAL_SKIN_CHITIN
	skin_amount =   10
	bone_material = null
	bone_amount =   0

	var/obj/item/inventory_head
	var/obj/item/inventory_mask

	ai_holder_type = /datum/ai_holder/simple_animal/passive/crab
	say_list_type = /datum/say_list/crab

/mob/living/simple_animal/crab/Life()
	. = ..()
	if(!.)
		return FALSE
	//CRAB movement
	if(!ckey && !stat)
		if(isturf(src.loc) && !resting && !buckled)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				Move(get_step(src,pick(4,8)))
				turns_since_move = 0
	regenerate_icons()

//COFFEE! SQUEEEEEEEEE!
/mob/living/simple_animal/crab/Coffee
	name = "Coffee"
	real_name = "Coffee"
	desc = "It's Coffee, the other pet!"


/datum/ai_holder/simple_animal/passive/crab
	speak_chance = 1


/datum/say_list/crab
	emote_hear = list("clicks")
	emote_see = list("clacks")
