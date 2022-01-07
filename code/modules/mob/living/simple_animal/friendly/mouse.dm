/mob/living/simple_animal/passive/mouse
	name = "mouse"
	real_name = "mouse"
	desc = "It's a small rodent."
	icon = 'icons/mob/simple_animal/mouse.dmi'
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
	minbodytemp = 223
	maxbodytemp = 323
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
	ai_holder = /datum/ai_holder/simple_animal/passive/mouse
	say_list_type = /datum/say_list/mouse
	var/body_color = list(
		"brown" = MATERIAL_SKIN_FUR,
		"gray" = MATERIAL_SKIN_FUR_GRAY,
		"white" = MATERIAL_SKIN_FUR_WHITE
	)


/mob/living/simple_animal/passive/mouse/Initialize()
	. = ..()
	if (islist(body_color))
		var/picked_color = pick(body_color)
		skin_material = body_color[picked_color]
		body_color = picked_color
		desc = "It's a small [body_color] rodent."
	if (!body_color)
		return INITIALIZE_HINT_QDEL
	icon_state = "mouse_[body_color]"
	item_state = "mouse_[body_color]"
	icon_living = "mouse_[body_color]"
	icon_dead = "mouse_[body_color]_dead"
	if (name == "mouse")
		name = "mouse ([sequential_id(/mob/living/simple_animal/passive/mouse)])"
	real_name = name
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide


/mob/living/simple_animal/passive/mouse/Life()
	. = ..()
	if (!.)
		return FALSE
	if (prob(ai_holder.speak_chance))
		playsound(src, 'sound/effects/mousesqueek.ogg', 1)
	if (!ckey && stat == CONSCIOUS && prob(0.5))
		set_stat(UNCONSCIOUS)
		icon_state = "mouse_[body_color]_sleep"
		set_wander(FALSE)
		ai_holder.speak_chance = 0
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


/mob/living/simple_animal/passive/mouse/proc/splat()
	icon_dead = "mouse_[body_color]_splat"
	adjustBruteLoss(maxHealth)
	death()


/mob/living/simple_animal/passive/mouse/Crossed(atom/movable/movable)
	if (isliving(movable))
		var/mob/living/living = movable
		if (living.mob_size > MOB_SMALL)
			living.playsound_local(get_turf(src), 'sound/effects/mousesqueek.ogg', 1)
			to_chat(living, SPAN_WARNING("[icon2html(src, living)] Squeek!"))
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


/mob/living/simple_animal/passive/mouse/tom
	name = "Tom"
	body_color = "brown"
	icon_state = "mouse_brown"
	desc = "Jerry is not amused."
	gender = MALE


/datum/ai_holder/simple_animal/passive/mouse
	speak_chance = 1


/datum/say_list/mouse
	speak = list("Squeek!", "SQUEEK!", "Squeek?")
	emote_hear = list("squeeks", "squeaks", "squiks")
	emote_see = list("runs in a circle", "shakes", "scritches at something")
