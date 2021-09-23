/mob/living/simple_animal/passive/opossum
	name = "opossum"
	real_name = "opossum"
	desc = "It's an opossum, a small scavenging marsupial."
	icon_state = "possum"
	item_state = "possum"
	icon_living = "possum"
	icon_dead = "possum_dead"
	icon = 'icons/mob/simple_animal/possum.dmi'
	speak_emote = list("hisses")
	pass_flags = PASS_FLAG_TABLE
	turns_per_move = 3
	see_in_dark = 6
	maxHealth = 50
	health = 50
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "stamps on"
	density = FALSE
	minbodytemp = 223
	maxbodytemp = 323
	universal_speak = FALSE
	universal_understand = TRUE
	holder_type = /obj/item/holder/possum
	mob_size = MOB_SMALL
	possession_candidate = 1
	can_escape = TRUE
	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER
	var/is_angry = FALSE

	ai_holder_type = /datum/ai_holder/simple_animal/passive/opossum
	say_list_type = /datum/say_list/opossum

/mob/living/simple_animal/passive/opossum/Life()
	. = ..()
	if(. && !ckey && stat != DEAD && prob(1))
		resting = (stat == UNCONSCIOUS)
		if(!resting)
			set_wander(initial(ai_holder.wander))
			ai_holder.speak_chance = initial(ai_holder.speak_chance)
			set_stat(CONSCIOUS)
			if(prob(10))
				is_angry = TRUE
		else
			set_wander(FALSE)
			ai_holder.speak_chance = 0
			set_stat(UNCONSCIOUS)
			is_angry = FALSE
		update_icon()

/mob/living/simple_animal/passive/opossum/adjustBruteLoss(damage)
	. = ..()
	if(damage >= 3)
		respond_to_damage()

/mob/living/simple_animal/passive/opossum/adjustFireLoss(damage)
	. = ..()
	if(damage >= 3)
		respond_to_damage()

/mob/living/simple_animal/passive/opossum/lay_down()
	. = ..()
	update_icon()

/mob/living/simple_animal/passive/opossum/proc/respond_to_damage()
	if(!resting && stat == CONSCIOUS)
		if(!is_angry)
			is_angry = TRUE
			custom_emote(src, "hisses!")
		else
			resting = TRUE
			custom_emote(src, "dies!")
		update_icon()

/mob/living/simple_animal/passive/opossum/on_update_icon()

	if(stat == DEAD || (resting && is_angry))
		icon_state = icon_dead
	else if(resting || stat == UNCONSCIOUS)
		icon_state = "[icon_living]_sleep"
	else if(is_angry)
		icon_state = "[icon_living]_aaa"
	else
		icon_state = icon_living

/mob/living/simple_animal/passive/opossum/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_animal/passive/opossum/poppy
	name = "Poppy the Safety Possum"
	desc = "It's an opossum, a small scavenging marsupial. It's wearing appropriate personal protective equipment, though."
	icon_state = "poppy"
	item_state = "poppy"
	icon_living = "poppy"
	icon_dead = "poppy_dead"
	holder_type = /obj/item/holder/possum/poppy
	var/aaa_words = list("delaminat", "meteor", "fire", "breach")

/mob/living/simple_animal/passive/opossum/poppy/hear_broadcast(datum/language/language, mob/speaker, speaker_name, message)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_keywords, message), rand(1 SECOND, 3 SECONDS))

/mob/living/simple_animal/passive/opossum/poppy/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_keywords, message), rand(1 SECOND, 3 SECONDS))

/mob/living/simple_animal/passive/opossum/poppy/proc/check_keywords(var/message)
	if(!client && stat == CONSCIOUS)
		message = lowertext(message)
		for(var/aaa in aaa_words)
			if(findtext(message, aaa))
				respond_to_damage()
				return

/datum/ai_holder/simple_animal/passive/opossum
	speak_chance = 1

/datum/say_list/opossum
	speak = list("Hiss!","Aaa!","Aaa?")
	emote_hear = list("hisses")
	emote_see = list("forages for trash", "lounges")
