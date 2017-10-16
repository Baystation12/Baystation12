/datum/species/bogani
	name = SPECIES_BOGANI
	name_plural = SPECIES_BOGANI

	icobase = 'icons/mob/human_races/r_bogani.dmi'
	deform = 'icons/mob/human_races/r_bogani.dmi'

	default_language = SPECIES_BOGANI
	unarmed_types = list(/datum/unarmed_attack/punch)
	blurb = "An unknown species of Slavers and Conquerors from distant stars yet discovered by the known species, the Bogani are a force to be reckoned with."
	blood_color = "#FFF5EE"

	darksight = 7

	total_health = 150
	blood_volume = 840

	brute_mod = 0.5                    // Physical damage multiplier.
	burn_mod = 0.5                    // Burn damage multiplier.
	oxy_mod = 1.8                    // Oxyloss modifier
	toxins_mod = 1.3                    // Toxloss modifier
	radiation_mod = 0.75                    // Radiation modifier
	flash_mod = 1.7                    // Stun from blindness modifier.

	gluttonous = GLUT_TINY
	spawn_flags = SPECIES_IS_RESTRICTED

	cold_level_1 = 240
	cold_level_2 = 180
	cold_level_3 = 90

	heat_discomfort_level = 300
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 255
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your exoskeleton feels rigid.")

	breath_pressure = 28
	breath_type = "chlorine"
	poison_type = list("oxygen")
	siemens_coefficient = 0.1

	genders = list(NEUTER)

/datum/species/bogani/egyno
	name = SPECIES_EGYNO
	name_plural = SPECIES_EGYNO

	icobase = 'icons/mob/human_races/r_bogani_small.dmi'
	deform = 'icons/mob/human_races/r_bogani_small.dmi'

	default_language = SPECIES_BOGANI
	unarmed_types = list(/datum/unarmed_attack/punch)
	blurb = "An unknown species of Slavers and Conquerors from distant stars yet discovered by the known species, the Bogani are a force to be reckoned with."
	blood_color = "#FFF5EE"

	darksight = 5

	total_health = 90
	blood_volume = 540

	brute_mod = 0.8                    // Physical damage multiplier.
	burn_mod = 0.8                    // Burn damage multiplier.
	oxy_mod = 1.2                    // Oxyloss modifier
	toxins_mod = 1                    // Toxloss modifier
	radiation_mod = 0.75                    // Radiation modifier
	flash_mod = 1.7                    // Stun from blindness modifier.

	gluttonous = GLUT_TINY

	cold_level_1 = 240
	cold_level_2 = 180
	cold_level_3 = 90

	heat_discomfort_level = 300
	heat_discomfort_strings = list(
		"You feel soothingly warm.",
		"You feel the heat sink into your bones.",
		"You feel warm enough to take a nap."
		)

	cold_discomfort_level = 255
	cold_discomfort_strings = list(
		"You feel chilly.",
		"You feel sluggish and cold.",
		"Your scales bristle against the cold.")

	breath_type = "chlorine"
	poison_type = list("oxygen")
	siemens_coefficient = 0.9

	genders = list(NEUTER)
