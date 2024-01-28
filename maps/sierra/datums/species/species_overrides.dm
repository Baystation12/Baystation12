/*
Various overrides for standart species, which are too tiny to have their own mod
*/

// Skrell

/obj/item/organ/internal/eyes/skrell
	eye_icon = 'maps/sierra/icons/mob/human_races/species/skrell/eyes.dmi'
	apply_eye_colour = FALSE

// Unathi

/datum/species/unathi
	autohiss_basic_map = list(
			"s" = list("ss", "sss", "ssss"),

			"с" = list("с", "сс", "ссс")
		)
	autohiss_extra_map = list(
			"x" = list("ks", "kss", "ksss"),

			"к" = list("х"),

			"г" = list("х"),

			"з" = list("с", "сс", "ссс"),

			"ч" = list("щ", "щщ", "щщщ"),

			"ж" = list("ш", "шш", "шшш")

		)
	autohiss_exempt = list(
					LANGUAGE_UNATHI_SINTA,
					LANGUAGE_UNATHI_YEOSA
	)
