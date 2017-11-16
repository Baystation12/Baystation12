/datum/species/human/uplift
	name = "Uplift"
	name_plural = "Uplifts"
	blurb = "With cloning and genetic modification in common use by the scientific community, \
	a number of corporations have taken up the practice of uplifting primates to serve as lab assistants \
	or other forms of cheap labor. Without the same civil status as their Human creators, Uplifts are \
	often given undesirable positions with little or no pay."
	icobase = 'icons/mob/human_races/subspecies/r_uplift.dmi'

	language = LANGUAGE_MONKEY
	default_language = LANGUAGE_MONKEY
	secondary_langs = list(LANGUAGE_GUTTER, LANGUAGE_SIGN)
	assisted_langs = list(LANGUAGE_GALCOM, LANGUAGE_LUNAR, LANGUAGE_SOL_COMMON, LANGUAGE_INDEPENDENT, LANGUAGE_SPACER)
	additional_langs = list(LANGUAGE_GALCOM)
	num_alternate_languages = 2

	min_age = 10
	max_age = 30

	darksight = 3
	slowdown = -0.2
	toxins_mod =   1.2
	brute_mod = 1.1
	burn_mod = 1.1
	gluttonous = GLUT_TINY
	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes,
		BP_VOICE =    /obj/item/organ/internal/voicebox/monkey
		)

/datum/species/human/uplift/get_random_name(gender)
	return capitalize(pick(gender == FEMALE ? GLOB.first_names_female : GLOB.first_names_male))

