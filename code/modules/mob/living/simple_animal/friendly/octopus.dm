/mob/living/simple_animal/octopus
	name = "cephalapod"
	real_name = "space octopus"
	desc = "It's a small spaceborne octopus."
	icon_state = "octo"
	item_state = "octo"
	icon_living = "octo"
	icon_dead = "octo_dead"
	speak = list("Blug!","Glubber!","Blab?")
	speak_emote = list("babbles","blorps","blarps")
	emote_hear = list("babbles","blorps","blarps")
	emote_see = list("wriggles its tentacles", "pulsates", "schlepps")
	pass_flags = PASS_FLAG_TABLE
	speak_chance = 1
	turns_per_move = 5
	see_in_dark = 6
	maxHealth = 50
	health = 50
	//placeholder until I add more exotic meats with varying degrees of toxicity
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/carpmeat
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "stomps on"
	density = 0
//	var/body_color //brown, gray and white, leave blank for random
	minbodytemp = 223		//Below -50 Degrees Celcius
	maxbodytemp = 323	//Above 50 Degrees Celcius
	universal_speak = 0
	universal_understand = 1
	holder_type = /obj/item/weapon/holder/mouse
	mob_size = MOB_SMALL
	possession_candidate = 1
	can_escape = 1
	var/footstep = 1
	can_pull_size = ITEM_SIZE_TINY
	can_pull_mobs = MOB_PULL_NONE

/mob/living/simple_animal/octopus/Initialize()
	. = ..()

	verbs += /mob/living/proc/ventcrawl
	verbs += /mob/living/proc/hide

/mob/living/simple_animal/octopus/Crossed(AM as mob|obj)
	if( ishuman(AM) )
		if(!stat)
			var/mob/M = AM
			to_chat(M, "<span class='warning'>\icon[src] Squeek!</span>")
			sound_to(M, 'sound/items/bikehorn.ogg')
	..()

//mob/living/simple_animal/octopus/handle_movement(var/turf/walking, var/running)
//	if(running)
//		if(footstep >= 2)
//			footstep = 0
//			playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
//		else
//			footstep++
//	else
//		playsound(src, "clownstep", 20, 1)