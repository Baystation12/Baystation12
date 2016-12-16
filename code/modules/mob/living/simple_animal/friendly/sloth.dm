/mob/living/simple_animal/sloth
	name = "\improper sloth"
	real_name = "sloth"
	desc = "An adorable, sleepy creature."
	icon_state = "sloth"
	icon_living = "sloth"
	icon_dead = "sloth_dead"
	speak = list("Aaa...", "Aa.", "Aaaah..")
	speak_emote = list("yawns")
	emote_hear = list("yawns", "snores")
	emote_see = list("looks around sleepily", "dozes off")
	speak_chance = 1
	turns_per_move = 20
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 2
	response_help  = "pets"
	response_disarm = "gently pushes aside"
	response_harm   = "kicks"
	see_in_dark = 8
	mob_size = MOB_SMALL
	possession_candidate = 1

//Cargo's pet
/mob/living/simple_animal/sloth/Tug
	name = "Tug"
	real_name = "Tug"	//Intended to hold the name without altering it.
	gender = FEMALE
	desc = "Cargo's pet sloth. About as useful as the rest of the techs."