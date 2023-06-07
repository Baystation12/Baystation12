/mob/living/simple_animal/hostile/bluespace
	name = "bluespace figment"
	desc = "A fragmented spectre from another dimension."
	icon = 'icons/mob/simple_animal/bluespace.dmi'
	icon_state = "figment"
	icon_living = "figment"
	icon_dead = "figment_dead"
	faction = "bluespace"
	speak_emote = list("echoes")
	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"
	maxHealth = 65
	health = 65
	ai_holder = /datum/ai_holder/simple_animal/melee/bluespace
	say_list = /datum/say_list/bluespace
	natural_weapon = /obj/item/natural_weapon/bluespace
	light_color = "#4da6ff"
	light_outer_range = 2
	light_max_bright = 1
	bleed_colour = "#0000ff"

/mob/living/simple_animal/hostile/bluespace/Process_Spacemove()
	return 1

/obj/item/natural_weapon/bluespace
	name = "fractal touch"
	attack_verb = list("slashed", "phased through", "drained")
	hitsound = 'sound/hallucinations/growl1.ogg'
	force = 15
	sharp = TRUE
	edge = TRUE

/mob/living/simple_animal/hostile/bluespace/death()
	..(null, "fizzles into nothingness.")
	playsound(src.loc, 'sound/magic/summon_carp.ogg', 50, 1)
	qdel(src)
	return

/datum/ai_holder/simple_animal/melee/bluespace
	speak_chance = 5
	wander = TRUE

/datum/say_list/bluespace
	emote_hear = list("wails","screeches")
	emote_see = list("warps in an out of reality", "flickers", "stops suddenly")

//passive variant
/mob/living/simple_animal/hostile/bluespace/neutral
	ai_holder = /datum/ai_holder/simple_animal/passive/bluespace
	density = FALSE

/datum/ai_holder/simple_animal/passive/bluespace
	speak_chance = 5
	wander = TRUE
