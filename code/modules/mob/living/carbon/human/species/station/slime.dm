/datum/species/slime
	name = "Slime"
	name_plural = "slimes"
	is_small = 1

	icobase = 'icons/mob/human_races/r_slime.dmi'
	deform = 'icons/mob/human_races/r_slime.dmi'

	language = null //todo?
	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	flags = NO_SCAN | NO_SLIP | NO_BREATHE | NO_MINOR_CUT
	spawn_flags = IS_RESTRICTED
	siemens_coefficient = 3 //conductive
	darksight = 3

	blood_color = "#05FF9B"
	flesh_color = "#05FFFB"

	remains_type = /obj/effect/decal/cleanable/ash
	death_message = "rapidly loses cohesion, splattering across the ground..."

	has_organ = list(
		"brain" = /obj/item/organ/brain/slime
		)

	breath_type = null
	poison_type = null

	bump_flag = SLIME
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest/unbreakable),
		"groin" =  list("path" = /obj/item/organ/external/groin/unbreakable),
		"head" =   list("path" = /obj/item/organ/external/head/unbreakable),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/unbreakable),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/unbreakable),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/unbreakable),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/unbreakable),
		"l_hand" = list("path" = /obj/item/organ/external/hand/unbreakable),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/unbreakable),
		"l_foot" = list("path" = /obj/item/organ/external/foot/unbreakable),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/unbreakable)
		)

/datum/species/slime/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()
