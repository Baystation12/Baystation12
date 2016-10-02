/datum/species/akula
	name = "Akula"
	name_plural = "Akula"
	icobase = 'icons/eros/mob/human_races/r_shark.dmi'
	deform = 'icons/eros/mob/human_races/r_def_shark.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/claws, /datum/unarmed_attack/bite/sharp)
	darksight = 5
	gluttonous = GLUT_TINY
	slowdown = 0.5
	brute_mod = 0.7
	radiation_mod = 0.1
	num_alternate_languages = 2
	secondary_langs = list(LANGUAGE_SOL_COMMON)
	name_language = LANGUAGE_SOL_COMMON
	health_hud_intensity = 2

	min_age = 18
	max_age = 80

	blurb = "Uplifted by human beings, the akula represent humanity's first major result of genetic \
	tampering. They enjoy full rights as an independant race. Akula politics are somewhat tumultuous, \
	divided between appreciating their close relationship with humanity and rejecting it. As a whole, \
	the race struggles with their innatetely often aggressive nature, similar to the sharks they were \
	uplifted from. They are well-suited to colder climates."

	cold_level_1 = 200 //Default 260 - Lower is better
	cold_level_2 = 140 //Default 200
	cold_level_3 = 90 //Default 120

	heat_level_1 = 380 //Default 360 - Higher is better
	heat_level_2 = 450 //Default 400
	heat_level_3 = 1100 //Default 1000

	spawn_flags = CAN_JOIN
	appearance_flags = HAS_HAIR_COLOR | HAS_LIPS | HAS_UNDERWEAR | HAS_SKIN_COLOR | HAS_EYE_COLOR | HAS_BIOMODS

	flesh_color = "#99CCCC"
	blood_color = "#3333CC"

	reagent_tag = IS_UNATHI  // using unathi reagent tag, since I'd pretty much define the same things anyways
	base_color = "#99CCCC"

	heat_discomfort_level = 295
	cold_discomfort_level = 250
	breathing_sound = 'sound/voice/lizard.ogg'