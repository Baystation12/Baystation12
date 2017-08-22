/datum/species/sangheili
	name = "Sangheili"
	name_plural = "Sangheili"
	blurb = "Shouldn't be seeing this." // Doesn't appear in chargen
	flesh_color = "#4A4A64"
	blood_color = "#4A4A64"
	icobase = 'code/modules/halo/icons/species/r_elite.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_elite.dmi'
	icon_template = 'code/modules/halo/icons/species/r_elite_template.dmi'
	default_language = "Sangheili"
	language = "Sangheili"
	total_health = 150 // Stronger than humans at base health.
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	spawn_flags = SPECIES_IS_WHITELISTED
	brute_mod = 0.9

	has_organ = list(
	BP_HEART =    /obj/item/organ/internal/heart,
	"second heart" =	 /obj/item/organ/heart_secondary,
	BP_LUNGS =    /obj/item/organ/internal/lungs,
	BP_LIVER =    /obj/item/organ/internal/liver,
	BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
	BP_BRAIN =    /obj/item/organ/internal/brain,
	BP_APPENDIX = /obj/item/organ/internal/appendix,
	BP_EYES =     /obj/item/organ/internal/eyes
	)
