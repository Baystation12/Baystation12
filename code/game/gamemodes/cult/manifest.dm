/datum/species/human/cult
	name = "Cult"
	spawn_flags = SPECIES_IS_RESTRICTED
	brute_mod = 2
	burn_mod = 2
	species_flags = SPECIES_FLAG_NO_SCAN
	force_cultural_info = list(
		TAG_CULTURE = CULTURE_CULTIST
	)

/datum/species/human/cult/handle_death(mob/living/carbon/human/H)
	spawn(1)
		if(H)
			H.dust()

/datum/species/human/cult/handle_post_spawn(mob/living/carbon/human/H)
	H.skin_tone = 35
	H.eye_color = "#e60707"
	H.update_eyes()
