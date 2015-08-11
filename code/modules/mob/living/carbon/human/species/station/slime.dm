/datum/species/slime
	name = "Slime"
	name_plural = "slimes"
	is_small = 1

	icobase = 'icons/mob/human_races/r_slime.dmi'
	deform = 'icons/mob/human_races/r_slime.dmi'

	language = "Sol Common" //todo?
	unarmed_types = list(/datum/unarmed_attack/slime_glomp)
	flags = IS_RESTRICTED | NO_BLOOD | NO_SCAN | NO_SLIP | NO_BREATHE
	siemens_coefficient = 3
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
		"chest" =  list("path" = /obj/item/organ/external/chest/slime),
		"groin" =  list("path" = /obj/item/organ/external/groin/slime),
		"head" =   list("path" = /obj/item/organ/external/head/slime),
		"l_arm" =  list("path" = /obj/item/organ/external/arm/slime),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right/slime),
		"l_leg" =  list("path" = /obj/item/organ/external/leg/slime),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right/slime),
		"l_hand" = list("path" = /obj/item/organ/external/hand/slime),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/slime),
		"l_foot" = list("path" = /obj/item/organ/external/foot/slime),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/slime)
		)

/datum/species/slime/handle_death(var/mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.gib()
