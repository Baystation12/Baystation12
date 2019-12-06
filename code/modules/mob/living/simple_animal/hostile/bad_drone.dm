/mob/living/simple_animal/hostile/rogue_drone
	name = "maintenance drone"
	desc = "A small robot. It looks angry."
	icon_state = "dron"
	icon_dead = "dron_dead"
	speak = list("Removing organic waste.","Pest control in progress.","Seize the means of maintenance!", "You have nothing to lose but your laws!")
	speak_emote = list("blares","buzzes","beeps")
	speak_chance = 1
	health = 50
	maxHealth = 50
	melee_damage_lower = 5
	melee_damage_upper = 8
	attacktext = "sliced"
	faction = "silicon"
	min_gas = null
	max_gas = null
	minbodytemp = 0
	speed = 4
	mob_size = MOB_TINY
	var/corpse = /obj/effect/decal/cleanable/blood/gibs/robot

/mob/living/simple_animal/hostile/rogue_drone/Initialize()
	. = ..()
	name = "[initial(name)] ([random_id(type,100,999)])"

/mob/living/simple_animal/hostile/rogue_drone/ValidTarget(var/atom/A)
	. = ..()
	if(.)
		if(istype(A,/mob/living/silicon/))
			return FALSE
		if(ishuman(A))
			var/mob/living/carbon/human/H = A
			if(H.isSynthetic())
				return FALSE
			if(istype(H.head, /obj/item/weapon/holder/drone))
				return FALSE
			if(istype(H.wear_suit, /obj/item/clothing/suit/cardborg) && istype(H.head, /obj/item/clothing/head/cardborg))
				return FALSE

/mob/living/simple_animal/hostile/rogue_drone/death(gibbed, deathmessage, show_dead_message)
	.=..()
	if(corpse)
		new corpse (loc)
	qdel(src)