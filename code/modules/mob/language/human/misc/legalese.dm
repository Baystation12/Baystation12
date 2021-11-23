/datum/language/legal
	name = LANGUAGE_LEGALESE
	desc = "A cryptic language used only in written form by interstellar bureaucrats and lawyers."
	space_chance = 100
	partial_understanding = list(
		LANGUAGE_HUMAN_EURO = 10,
		LANGUAGE_HUMAN_SELENIAN = 25
	)
	syllables = list(
		"hitherto", "whereof", "hereunto", "deed", "hereinbefore", "whereas", "consensus", "nonwithstanding",
		"exonerated", "effecuate", "accord", "caveat", "stipulation", "pledgee", "covenant", "rights",
		"lawful", "suit of law", "sequestrator", "et al", "et", "ex", "quid", "bono",	"quo", "pro", "ad"
	)
	has_written_form = TRUE

//Cannot be spoken
/datum/language/legal/can_speak_special(var/mob/speaker)
	return FALSE
