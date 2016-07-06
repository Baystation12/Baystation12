/datum/species/resomi
	name = "Resomi"
	name_plural = "Resomii"
	blurb = "A race of feathered raptors who developed on a cold world, almost \
	outside of the Goldilocks zone. Extremely fragile, they developed hunting skills \
	that emphasized taking out their prey without themselves getting hit. They are an \
	advanced culture on good terms with Skrellian and Human interests."

	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_RESOMI)
	name_language = LANGUAGE_RESOMI
	min_age = 12
	max_age = 45
	health_hud_intensity = 3

	blood_color = "#D514F7"
	flesh_color = "#5F7BB0"
	base_color = "#001144"
	tail = "resomitail"
	tail_hair = "feathers"
	reagent_tag = IS_RESOMI

	icobase = 'icons/mob/human_races/r_resomi.dmi'
	deform = 'icons/mob/human_races/r_resomi.dmi'
	damage_overlays = 'icons/mob/human_races/masks/dam_resomi.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_resomi.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_resomi.dmi'

	eyes = "eyes_resomi"
	slowdown = -1
	total_health = 50
	brute_mod = 1.35
	burn_mod =  1.35
	mob_size = MOB_SMALL
	holder_type = /obj/item/weapon/holder/human
	short_sighted = 1
	gluttonous = GLUT_TINY
	blood_volume = 280
	hunger_factor = 0.2

	spawn_flags = CAN_JOIN | IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_COLOR | HAS_EYE_COLOR
	bump_flag = MONKEY
	swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	push_flags = MONKEY|SLIME|SIMPLE_ANIMAL|ALIEN

	cold_level_1 = 180
	cold_level_2 = 130
	cold_level_3 = 70
	heat_level_1 = 320
	heat_level_2 = 370
	heat_level_3 = 600
	heat_discomfort_level = 292
	heat_discomfort_strings = list(
		"Your feathers prickle in the heat.",
		"You feel uncomfortably warm.",
		)
	cold_discomfort_level = 180

	has_limbs = list(
		"chest" =  list("path" = /obj/item/organ/external/chest),
		"groin" =  list("path" = /obj/item/organ/external/groin),
		"head" =   list("path" = /obj/item/organ/external/head),
		"l_arm" =  list("path" = /obj/item/organ/external/arm),
		"r_arm" =  list("path" = /obj/item/organ/external/arm/right),
		"l_leg" =  list("path" = /obj/item/organ/external/leg),
		"r_leg" =  list("path" = /obj/item/organ/external/leg/right),
		"l_hand" = list("path" = /obj/item/organ/external/hand/resomi),
		"r_hand" = list("path" = /obj/item/organ/external/hand/right/resomi),
		"l_foot" = list("path" = /obj/item/organ/external/foot/resomi),
		"r_foot" = list("path" = /obj/item/organ/external/foot/right/resomi)
		)

	has_organ = list(
		"heart" =    /obj/item/organ/heart,
		"lungs" =    /obj/item/organ/lungs,
		"liver" =    /obj/item/organ/liver,
		"kidneys" =  /obj/item/organ/kidneys,
		"brain" =    /obj/item/organ/brain,
		"eyes" =     /obj/item/organ/eyes
		)

	unarmed_types = list(
		/datum/unarmed_attack/bite/sharp,
		/datum/unarmed_attack/claws,
		/datum/unarmed_attack/stomp/weak
		)

/datum/species/resomi/get_vision_flags(var/mob/living/carbon/human/H)
	if(!(H.sdisabilities & DEAF) && !H.ear_deaf)
		return SEE_SELF|SEE_MOBS
	else
		return SEE_SELF
