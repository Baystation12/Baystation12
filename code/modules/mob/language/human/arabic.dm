/datum/language/human/arabic
	name = LANGUAGE_HUMAN_ARABIC
	desc = "'Prototype Standard Arabic', as it was known during its development as a world-wide replacement for the myriad regional dialects of Modern Standard, \
			 was mostly ignored on Earth until co-operative Pan-Arab space exploration made its use attractive. Its use as a liturgical language remains limited."
	colour = "arabic"
	key = "4"
	shorthand = "PSA"
	space_chance = 35
	partial_understanding = list(
		LANGUAGE_HUMAN_EURO = 5,
		LANGUAGE_HUMAN_CHINESE = 5,
		LANGUAGE_HUMAN_INDIAN = 10,
		LANGUAGE_HUMAN_SELENIAN = 5,
		LANGUAGE_SPACER = 20,
		LANGUAGE_HUMAN_LORRIMAN = 5
	)
	syllables = list(
		"af", "if", "ba", "ta", "tha", "id", "jem", "ha", "kha", "dal", "dhl", "ra", "zay",
		"sen", "um", "shn", "sid", "ad", "ta", "za", "ayn", "gha", "zir", "yn", "fa", "qaf",
		"iam", "mim", "al", "ja", "non", "ha", "waw", "ya", "hem", "zah", "hml", "ks", "ini",
		"da", "ks", "iga", "ih", "la", "ulf", "xe", "ayw", "'", "-"
	)
	has_written_form = TRUE
