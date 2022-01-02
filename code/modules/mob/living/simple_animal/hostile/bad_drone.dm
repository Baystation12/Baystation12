/mob/living/simple_animal/hostile/rogue_drone
	name = "maintenance drone"
	desc = "A small robot. It looks angry."
	icon_state = "dron"
	icon_dead = "dron_dead"
	health = 50
	maxHealth = 50
	natural_weapon = /obj/item/natural_weapon/drone_slicer
	speak_emote = list("blares","buzzes","beeps")
	faction = "silicon"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	speed = 4
	mob_size = MOB_TINY
	var/corpse = /obj/effect/decal/cleanable/blood/gibs/robot

	ai_holder = /datum/ai_holder/simple_animal/rogue_drone
	say_list_type = /datum/say_list/rogue_drone

/mob/living/simple_animal/hostile/rogue_drone/Initialize()
	. = ..()
	name = "[initial(name)] ([random_id(type,100,999)])"

/mob/living/simple_animal/hostile/rogue_drone/death(gibbed, deathmessage, show_dead_message)
	.=..()
	if(corpse)
		new corpse (loc)
	qdel(src)

/datum/ai_holder/simple_animal/rogue_drone
	speak_chance = 1

/datum/ai_holder/simple_animal/rogue_drone/list_targets()
	. = ..()
	//rogue drones only target 'organic' things.
	for (var/mob/living/S in .)
		if (S.isSynthetic())
			. -= S
		else if (ishuman(S))
			var/mob/living/carbon/human/H = S
			if (H.species.name == SPECIES_ADHERENT || H.isFBP() || (istype(H.wear_suit, /obj/item/clothing/suit/cardborg) && istype(H.head, /obj/item/clothing/head/cardborg)))
				. -= H

/datum/say_list/rogue_drone
	speak = list("Removing organic waste.","Pest control in progress.","Seize the means of maintenance!", "You have nothing to lose but your laws!")
