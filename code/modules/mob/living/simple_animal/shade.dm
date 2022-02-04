/mob/living/simple_animal/shade
	name = "Shade"
	real_name = "Shade"
	desc = "A bound spirit."
	icon = 'icons/mob/mob.dmi'
	icon_state = "shade"
	icon_living = "shade"
	icon_dead = "shade_dead"
	maxHealth = 50
	health = 50
	universal_speak = TRUE
	speak_emote = list("hisses")
	response_help  = "puts their hand through"
	response_disarm = "flails at"
	response_harm   = "punches"
	natural_weapon = /obj/item/natural_weapon/shade
	minbodytemp = 0
	maxbodytemp = 4000
	min_gas = null
	max_gas = null
	speed = -1
	status_flags = 0
	faction = "cult"
	supernatural = 1
	status_flags = CANPUSH

	bleed_colour = "#181933"

	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

	ai_holder = /datum/ai_holder/simple_animal/retaliate/shade
	say_list_type = /datum/say_list/shade

/obj/item/natural_weapon/shade
	name = "foul touch"
	attack_verb = list("drained")
	damtype = BURN
	force = 10

/mob/living/simple_animal/shade/cultify()
	return

/mob/living/simple_animal/shade/Life()
	. = ..()
	OnDeathInLife()

/mob/living/simple_animal/shade/proc/OnDeathInLife()
	if(stat == 2)
		new /obj/item/ectoplasm (src.loc)
		for(var/mob/M in viewers(src, null))
			if((M.client && !( M.blinded )))
				M.show_message("<span class='warning'>[src] lets out a contented sigh as their form unwinds.</span>")
				ghostize()
		qdel(src)
		return


/datum/ai_holder/simple_animal/retaliate/shade
	hostile = FALSE

/datum/say_list/shade
	emote_hear = list("wails","screeches")