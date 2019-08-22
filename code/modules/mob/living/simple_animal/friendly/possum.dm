/mob/living/simple_animal/opossum
	name = "opossum"
	real_name = "opossum"
	desc = "It's an opossum, a small scavenging marsupial."
	icon_state = "possum"
	item_state = "possum"
	icon_living = "possum"
	icon_dead = "possum_dead"
	icon = 'icons/mob/simple_animal/possum.dmi'
	speak = list("Hiss!","Aaa!","Aaa?")
	speak_emote = list("hisses")
	emote_hear = list("hisses")
	emote_see = list("forages for trash", "lounges")
	pass_flags = PASS_FLAG_TABLE
	speak_chance = 1
	turns_per_move = 3
	see_in_dark = 6
	maxHealth = 50
	health = 50
	response_help = "pets"
	response_disarm = "gently pushes aside"
	response_harm = "stamps on"
	density = 0
	minbodytemp = 223
	maxbodytemp = 323
	universal_speak = FALSE
	universal_understand = TRUE
	mob_size = MOB_SMALL
	possession_candidate = 1
	can_escape = TRUE
	can_pull_size = ITEM_SIZE_SMALL
	can_pull_mobs = MOB_PULL_SMALLER
	var/is_angry = FALSE 

/mob/living/simple_animal/opossum/Life()
	. = ..()
	if(. && !ckey && stat != DEAD && prob(1))
		resting = (stat == UNCONSCIOUS)
		if(!resting)
			wander = initial(wander)
			speak_chance = initial(speak_chance)
			set_stat(CONSCIOUS)
			if(prob(10))
				is_angry = TRUE
		else
			wander = FALSE
			speak_chance = 0
			set_stat(UNCONSCIOUS)
			is_angry = FALSE
		update_icon()

/mob/living/simple_animal/opossum/adjustBruteLoss(damage)
	. = ..()
	if(damage >= 3)
		respond_to_damage()

/mob/living/simple_animal/opossum/adjustFireLoss(damage)
	. = ..()
	if(damage >= 3)
		respond_to_damage()

/mob/living/simple_animal/opossum/lay_down()
	. = ..()
	update_icon()

/mob/living/simple_animal/opossum/proc/respond_to_damage()
	if(!resting && stat == CONSCIOUS)
		if(!is_angry)
			is_angry = TRUE
			custom_emote(src, "hisses!")
		else
			resting = TRUE
			custom_emote(src, "dies!")
		update_icon()

/mob/living/simple_animal/opossum/on_update_icon()
	
	if(stat == DEAD || (resting && is_angry))
		icon_state = icon_dead
	else if(resting || stat == UNCONSCIOUS)
		icon_state = "[icon_living]_sleep"
	else if(is_angry)
		icon_state = "[icon_living]_aaa"
	else
		icon_state = icon_living

/mob/living/simple_animal/opossum/Initialize()
	. = ..()
	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_animal/opossum/poppy
	name = "Poppy the Safety Possum"
	desc = "It's an opossum, a small scavenging marsupial. It's wearing appropriate personal protective equipment, though."
	icon = 'icons/mob/simple_animal/poppy_possum.dmi'
	var/aaa_words = list("delaminat", "meteor", "fire", "breach")

/mob/living/simple_animal/opossum/poppy/hear_broadcast(datum/language/language, mob/speaker, speaker_name, message)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_keywords, message), rand(1 SECOND, 3 SECONDS))

/mob/living/simple_animal/opossum/poppy/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	. = ..()
	addtimer(CALLBACK(src, .proc/check_keywords, message), rand(1 SECOND, 3 SECONDS))

/mob/living/simple_animal/opossum/poppy/proc/check_keywords(var/message)
	if(!client && stat == CONSCIOUS)
		message = lowertext(message)
		for(var/aaa in aaa_words)
			if(findtext(message, aaa))
				respond_to_damage()
				return
