/mob/living/simple_animal/hostile/skeleton
	name = "skeleton"
	desc = "A walking pile of bones, somehow living."
	icon = 'icons/obj/surgery_tools.dmi'
	icon_state = "skeletor"
	icon_living = "skeletor"
	icon_dead = "skeletor"
	health = 65
	maxHealth = 65
	speed = 1
	pry_time = 10 SECONDS
	harm_intent_damage = 10

	natural_weapon = /obj/item/natural_weapon/punch
	ai_holder = /datum/ai_holder/simple_animal/melee/skeleton
	faction = "skeleton"

	bleed_colour = "#d8d8d3"
	meat_type =     null
	meat_amount =   0
	bone_material = null
	bone_amount =   0
	skin_material = null
	skin_amount =   0

	min_gas = null
	max_gas = null
	minbodytemp = 0

/mob/living/simple_animal/hostile/skeleton/death()
	..(null, "collapses into a pile of bones!")
	new /obj/decal/cleanable/remains (loc)
	new /obj/item/stack/material/generic/bone (loc, 5)
	playsound(src.loc, 'sound/effects/bonerattle.ogg', 50, 1)
	qdel(src)
	return

/datum/ai_holder/simple_animal/melee/skeleton
	speak_chance = 0
	wander = TRUE

/datum/ai_holder/simple_animal/melee/skeleton/find_target(list/possible_targets, has_targets_list)
	. = ..()
	if (.)
		holder.custom_emote(1, "rattles its bones at [.]!")
		playsound(holder.loc, 'sound/effects/bonerattle.ogg', 50, 1)

/obj/decal/cleanable/remains
	name = "bones"
	desc = "A haphazard pile of bones."
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
