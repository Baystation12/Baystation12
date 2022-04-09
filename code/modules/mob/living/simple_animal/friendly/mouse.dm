/mob/living/simple_animal/passive/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	speak_emote = list("squeeks","squeeks","squiks")
	pass_flags = PASS_FLAG_TABLE
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	density = FALSE
	minbodytemp = 223		//Below -50 Degrees Celsius
	maxbodytemp = 323	//Above 50 Degrees Celsius
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/holder/mouse
	mob_size = MOB_MINISCULE
	possession_candidate = 1
	can_escape = TRUE
	can_pull_size = ITEM_SIZE_TINY
	can_pull_mobs = MOB_PULL_NONE

	meat_amount =   1
	bone_amount =   1
	skin_amount =   1
	skin_material = MATERIAL_SKIN_FUR

	var/body_color //brown, gray and white, leave blank for random

	ai_holder = /datum/ai_holder/simple_animal/passive/mouse
	say_list_type = /datum/say_list/mouse

/mob/living/simple_animal/passive/mouse/Life()
	. = ..()
	if(!.)
		return FALSE
	if(prob(ai_holder.speak_chance))
		for(var/mob/M in view())
			sound_to(M, 'sound/effects/mousesqueek.ogg')

	if(!ckey && stat == CONSCIOUS && prob(0.5))
		set_stat(UNCONSCIOUS)
		icon_state = "mouse_[body_color]_sleep"
		set_wander(FALSE)
		ai_holder.speak_chance = 0
		//snuffles
	else if(stat == UNCONSCIOUS)
		if(ckey || prob(1))
			set_stat(CONSCIOUS)
			icon_state = "mouse_[body_color]"
			set_wander(TRUE)
		else if(prob(5))
			audible_emote("snuffles.")

/mob/living/simple_animal/passive/mouse/lay_down()
	..()
	icon_state = resting ? "mouse_[body_color]_sleep" : "mouse_[body_color]"

/mob/living/simple_animal/passive/mouse/New()
	..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

	if(name == initial(name))
		name = "[name] ([sequential_id(/mob/living/simple_animal/passive/mouse)])"
	real_name = name

	if(!body_color)
		body_color = pick( list("brown","gray","white") )

	icon_state = "mouse_[body_color]"
	item_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"
	desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."

/mob/living/simple_animal/passive/mouse/Initialize()
	. = ..()
	switch(body_color)
		if("gray")
			skin_material = MATERIAL_SKIN_FUR_GRAY
		if("white")
			skin_material = MATERIAL_SKIN_FUR_WHITE

/mob/living/simple_animal/passive/mouse/proc/splat()
	icon_dead = "mouse_[body_color]_splat"
	adjustBruteLoss(maxHealth)  // Enough damage to kill
	src.death()

/mob/living/simple_animal/passive/mouse/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			to_chat(M, "<span class='warning'>[icon2html(src, M)] Squeek!</span>")
			sound_to(M, 'sound/effects/mousesqueek.ogg')
	..()

/*
 * Mouse types
 */

/mob/living/simple_animal/passive/mouse/white
	body_color = "white"
	icon_state = "mouse_white"

/mob/living/simple_animal/passive/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"

/mob/living/simple_animal/passive/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"

//TOM IS ALIVE! SQUEEEEEEEE~K :)
/mob/living/simple_animal/passive/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."

/mob/living/simple_animal/passive/mouse/brown/Tom/New()
	..()
	// Change my name back, don't want to be named Tom (666)
	SetName(initial(name))
	real_name = name

/datum/ai_holder/simple_animal/passive/mouse
	speak_chance = 1

/datum/say_list/mouse
	speak = list("Squeek!","SQUEEK!","Squeek?")
	emote_hear = list("squeeks","squeaks","squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
