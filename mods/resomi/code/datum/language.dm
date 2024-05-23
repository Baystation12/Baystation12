/datum/language/resomi
	name = LANGUAGE_RESOMI
	desc = "A trilling language spoken by the diminutive Resomi."
	speech_verb = "щебечет"
	ask_verb = "чирикает"
	exclaim_verb = "верещит"
	colour = "alien"
	key = "e"
	flags = WHITELISTED
	space_chance = 50
	syllables = list(
			"ca", "ra", "ma", "sa", "na", "ta", "la", "sha", "scha", "a", "a",
			"ce", "re", "me", "se", "ne", "te", "le", "she", "sche", "e", "e",
			"ci", "ri", "mi", "si", "ni", "ti", "li", "shi", "schi", "i", "i"
		)
	shorthand = "SCH"
	has_written_form = TRUE


/datum/language/resomi/get_random_name(gender)
	return ..(gender, 1, 4, 1.5)

 //AUTOHISS
/datum/species/resomi
	autohiss_basic_map = list(
			"з" = list("с")
		)
	autohiss_extra_map = list(
			"ч" = list("щ"),

			"ж" = list("ш")
		)
	autohiss_exempt = list(LANGUAGE_RESOMI)

//TODO: RESOMI MISC FILE
/datum/trader/trading_beacon/New()
	..()
	speech[TRADER_HAIL_START + SPECIES_RESOMI] = "Greetings, I am MERCHANT, Artifical Intelligence onboard ORIGIN. We wish to trade with you, no more."
