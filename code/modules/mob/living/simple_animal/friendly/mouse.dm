/mob/living/simple_animal/passive/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	icon_state = "mouse_gray"
	item_state = "mouse_gray"
	icon_living = "mouse_gray"
	icon_dead = "mouse_gray_dead"
	speak_emote = list("squeeks", "squeeks", "squiks")
	pass_flags = PASS_FLAG_TABLE
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 5
	health = 5
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stamps on"
	density = FALSE
	minbodytemp = T0C - 50
	maxbodytemp = T0C + 50
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/holder/mouse
	mob_size = MOB_MINISCULE
	possession_candidate = TRUE
	can_escape = TRUE
	can_pull_size = ITEM_SIZE_TINY
	can_pull_mobs = MOB_PULL_NONE
	meat_amount = 1
	bone_amount = 1
	skin_amount = 1
	skin_material = MATERIAL_SKIN_FUR
	ai_holder = /datum/ai_holder/simple_animal/passive/mouse
	say_list_type = /datum/say_list/mouse

	//brown, gray and white, leave blank for random
	var/body_color


/mob/living/simple_animal/passive/mouse/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide
	if (!body_color)
		body_color = pick(list("brown", "gray", "white"))
	switch (body_color)
		if ("gray")
			skin_material = MATERIAL_SKIN_FUR_GRAY
		if ("white")
			skin_material = MATERIAL_SKIN_FUR_WHITE
	if (name == "mouse")
		name = "[name] ([sequential_id(/mob/living/simple_animal/passive/mouse)])"
		desc = "It's a small [body_color] rodent, often seen hiding in maintenance areas and making a nuisance of itself."
	real_name = name
	icon_state = "mouse_[body_color]"
	item_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"


/mob/living/simple_animal/passive/mouse/Life()
	. = ..()
	if (!.)
		return FALSE
	if (prob(ai_holder.speak_chance))
		for(var/mob/M in view())
			sound_to(M, 'sound/effects/mousesqueek.ogg')
	if (!ckey && stat == CONSCIOUS && prob(0.5))
		set_stat(UNCONSCIOUS)
		icon_state = "mouse_[body_color]_sleep"
		set_wander(FALSE)
		ai_holder.speak_chance = 0
		//snuffles
	else if (stat == UNCONSCIOUS)
		if (ckey || prob(1))
			set_stat(CONSCIOUS)
			icon_state = "mouse_[body_color]"
			set_wander(TRUE)
		else if (prob(5))
			audible_emote("snuffles.")


/mob/living/simple_animal/passive/mouse/lay_down()
	..()
	icon_state = resting ? "mouse_[body_color]_sleep" : "mouse_[body_color]"


/mob/living/simple_animal/passive/mouse/Crossed(atom/movable/movable)
	if (ishuman(movable))
		if (!stat)
			to_chat(movable, SPAN_WARNING("[icon2html(src, movable)] Squeek!"))
			sound_to(movable, 'sound/effects/mousesqueek.ogg')
	..()


/mob/living/simple_animal/passive/mouse/white
	body_color = "white"
	icon_state = "mouse_white"


/mob/living/simple_animal/passive/mouse/gray
	body_color = "gray"
	icon_state = "mouse_gray"


/mob/living/simple_animal/passive/mouse/brown
	body_color = "brown"
	icon_state = "mouse_brown"


/mob/living/simple_animal/passive/mouse/brown/Tom
	name = "Tom"
	desc = "Jerry the cat is not amused."

/mob/living/simple_animal/passive/mouse/rat
	name = "rat"
	desc = "A large rodent, often seen in maintenance areas."
	body_color = "rat"
	icon_state = "mouse_rat"
	maxHealth = 20
	health = 20

	ai_holder = /datum/ai_holder/simple_animal/melee/evasive

/mob/living/simple_animal/passive/mouse/rat/chill
	ai_holder = /datum/ai_holder/simple_animal/passive/mouse

/datum/ai_holder/simple_animal/passive/mouse
	speak_chance = 1


/datum/say_list/mouse
	speak = list("Squeek!", "SQUEEK!", "Squeek?")
	emote_hear = list("squeeks", "squeaks", "squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
