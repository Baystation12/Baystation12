/datum/language/nabber
	name = LANGUAGE_NABBER
	desc = "A strange language that can be understood both by the sounds made and by the movement needed to create those sounds."
	signlang_verb = list("chitters", "grinds its mouthparts", "chitters and grinds its mouthparts")
	key = "n"
	flags = WHITELISTED | SIGNLANG | NO_STUTTER | NONVERBAL
	colour = ".nabber_lang"
	shorthand = "SD"

/datum/language/nabber/get_random_name(var/gender)
	if(gender == FEMALE)
		return capitalize(pick(GLOB.first_names_female))
	else
		return capitalize(pick(GLOB.first_names_male))

