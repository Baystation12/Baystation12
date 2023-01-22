/mob/living/simple_animal/hostile/retaliate/snake
	name = "snake"
	desc = "A medium-sized, lethargic reptile, covered in geometrical patterns. You're not sure if this one's venomous or not."
	icon = 'icons/mob/simple_animal/animal.dmi'
	icon_state = "snake"
	icon_living = "snake"
	icon_dead = "snake-dead"
	speak_emote = list("hisses")
	health = 45
	maxHealth = 45
	natural_weapon = /obj/item/natural_weapon/bite
	response_help  = "pets"
	response_disarm = "swats away"
	response_harm   = "stomps on"
	gender = NEUTER
	holder_type = /obj/item/holder/snake
	mob_size = MOB_MINISCULE
	can_escape = TRUE
	pass_flags = PASS_FLAG_TABLE
	density = FALSE
	var/venomous = FALSE

	meat_amount = 1
	bone_amount = 1
	skin_amount = 1
	skin_material = MATERIAL_SKIN_LIZARD

	ai_holder = /datum/ai_holder/simple_animal/retaliate
	say_list_type = /datum/say_list/snake


/obj/item/holder/snake
	name = "snake"
	desc = "It's a snake. Holding it is probably a bad idea."
	gender = NEUTER
	icon_state = "snake"

/datum/say_list/snake
	emote_hear = list("hisses","hisses softly")
	emote_see = list("samples the air", "lounges")

/mob/living/simple_animal/hostile/retaliate/snake/proc/inject_venom(mob/living/L, target_zone)
	if (isSynthetic())
		return

	if(venomous)
		L.reagents.add_reagent(/datum/reagent/toxin/venom, 2)

/mob/living/simple_animal/hostile/retaliate/snake/venom //Identical to the one without toxins.
	venomous = TRUE

/mob/living/simple_animal/hostile/retaliate/snake/cob
	name = "Cobby"
	desc = "A genetically engineered corn snake, spotted with brown diamond patterns over their glimmering copper-colored scales. This one seems particularly lazy."
	ai_holder = /datum/ai_holder/simple_animal/passive // We dont want a crew pet killing people.