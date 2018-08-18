/decl/cultural_info/culture/hidden/xenophage
	name = CULTURE_XENOPHAGE_D
	language = LANGUAGE_XENOPHAGE
	default_language = LANGUAGE_XENOPHAGE
	additional_langs = list(LANGUAGE_XENOPHAGE_HIVE)
	var/caste_name = "drone"
	var/caste_number = 0

/decl/cultural_info/culture/hidden/xenophage/get_random_name()
	return "alien [caste_name] ([caste_number])"

/decl/cultural_info/culture/hidden/xenophage/hunter
	name = CULTURE_XENOPHAGE_H
	caste_name = "hunter"

/decl/cultural_info/culture/hidden/xenophage/sentinel
	name = CULTURE_XENOPHAGE_S
	caste_name = "sentinel"

/decl/cultural_info/culture/hidden/xenophage/queen
	name = CULTURE_XENOPHAGE_Q
	caste_name = "queen"

/decl/cultural_info/culture/hidden/xenophage/queen/get_random_name(var/mob/living/carbon/human/queen)
	if(!istype(queen) || !alien_queen_exists(1, queen))
		return "alien queen ([caste_number])"
	else
		return "alien princess ([caste_number])"
