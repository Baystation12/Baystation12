/datum/species/grey
	name = SPECIES_GREY
	name_plural = SPECIES_GREY

	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	blurb = "Greys do not exist. Greys are a myth. Greys are among us. Greys are uplifted chimpanzees. Greys are evolved humans from the future. Greys do not exist. Greys are early Bogani sightings. Greys are figments of imagination. Greys are not from this dimension. Greys do not exist. Greys are a poorly documented species allegedly originating from the direction of the reticulum stars. Their language to date defies translation and their motives are alien to human comprehension. Captured specimens quickly expire despite our best efforts and spectral analysis reveal all specimens are identical on a genetic level. Their goals seem to revolve around harvesting organs of other races and the acquisition of super-matter. To what ends we can not discern."
	num_alternate_languages = 0
	default_language = SPECIES_GREY
	unarmed_types = list(/datum/unarmed_attack/punch)

	min_age = 1
	max_age = 1200

	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_EYE_COLOR

	blood_color = "#00ffc8"

	icobase = 'icons/mob/human_races/r_grey.dmi'
	deform = 'icons/mob/human_races/r_grey.dmi'
	eye_icon = "grey_eyes_s"
	damage_overlays = 'icons/mob/human_races/masks/dam_human.dmi'
	damage_mask = 'icons/mob/human_races/masks/dam_mask_human.dmi'
	blood_mask = 'icons/mob/human_races/masks/blood_human.dmi'

	darksight = 7

	total_health = 300
	blood_volume = 600
	brute_mod = 1.5                  // Physical damage multiplier.
	burn_mod = 1.5                   // Burn damage multiplier.
	oxy_mod = 0.6                    // Oxyloss modifier
	toxins_mod = 1.2                 // Toxloss modifier
	radiation_mod = 0.10             // Radiation modifier
	flash_mod = 1.8                  // Stun from blindness modifier.

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes
//
		)

	breath_pressure = 18
	breath_type = "oxygen"
	poison_type = list("chlorine")
	siemens_coefficient = 1.0



	genders = list(NEUTER)

	death_sound = 'sound/voice/hiss6.ogg'