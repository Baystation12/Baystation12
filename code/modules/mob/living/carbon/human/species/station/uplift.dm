/datum/species/human/uplift
	name = SPECIES_UPLIFT_CHIMP
	name_plural = "Uplifts"
	blurb = "A number of corporations have taken up the practice of genetically uplifting \
	primates to serve as cheap labor. Without the same civil status as their creators, Uplifts are \
	often given undesirable positions with little or no pay. But they are physically and mentally very \
	similar to humans."
	icobase = 'icons/mob/human_races/subspecies/r_uplift.dmi'
	greater_form = SPECIES_HUMAN
	primitive_form = SPECIES_MONKEY

	death_message = "lets out a faint chimper as they stop moving..."
	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat/monkey

	language = LANGUAGE_MONKEY
	default_language = LANGUAGE_MONKEY
	secondary_langs = list(LANGUAGE_GUTTER, LANGUAGE_SIGN)
	assisted_langs = list(LANGUAGE_GALCOM, LANGUAGE_LUNAR, LANGUAGE_SOL_COMMON, LANGUAGE_INDEPENDENT, LANGUAGE_SPACER)
	additional_langs = list(LANGUAGE_GALCOM)
	num_alternate_languages = 2

	min_age = 13
	max_age = 50

	darksight = 3
	slowdown = -0.2
	toxins_mod =   1.2
	brute_mod = 1.1
	burn_mod = 1.1
	radiation_mod = 1.2
	metabolism_mod = 1.5
	total_health = 150
	gluttonous = GLUT_TINY
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_NO_LACE
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE | HAS_EYE_COLOR | HAS_UNDERWEAR

	flesh_color = "#ECCD90"
	base_color = "#2E2E2E"

	heat_discomfort_strings = list(
		"You feel sweat dampening your fur.",
		"You feel uncomfortably warm.",
		"Your skin prickles in the heat."
		)
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your fur stands on end in the cold."
		)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/uplift),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/uplift),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/uplift),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/uplift),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/uplift),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/uplift),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/uplift),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/uplift),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/uplift),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/uplift),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/uplift)
		)


	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart/uplift,
		BP_LUNGS =    /obj/item/organ/internal/lungs/uplift,
		BP_LIVER =    /obj/item/organ/internal/liver/uplift,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys/uplift,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes/uplift,
		BP_VOICE =    /obj/item/organ/internal/voicebox/uplift
		)

/datum/species/human/uplift/get_random_name(gender)
	return capitalize(pick(gender == FEMALE ? GLOB.first_names_female : GLOB.first_names_male))
