/datum/species
	var/bodyfall_sound = "bodyfall_sound" //default, can be used for species specific falling sounds

/datum/species/skrell
	bodyfall_sound = "bodyfall_skrell_sound"


/mob/living/carbon/human/UpdateLyingBuckledAndVerbStatus()
	var/old_lying = lying
	.=..()
	if(lying && !old_lying && !resting && !buckled) // fell down
		playsound(loc, species.bodyfall_sound, 50, 1, -1)
