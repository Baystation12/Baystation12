/datum/species/kig_yar
	name = "Kig-Yar"
	name_plural = "Kig-Yar"
	blurb = "Shouldn't be seeing this." // Doesn't appear in chargen
	flesh_color = "#FF9463"
	blood_color = "#4A4A64" //Same blood colour as Elites.
	icobase = 'code/modules/halo/icons/species/r_kig-yar.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_kig-yar.dmi'
	default_language = "Sangheili" //Just for now, no special language just yet
	language = "Sangheili"
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	inherent_verbs = list(/mob/living/carbon/human/proc/focus_view)
	spawn_flags = SPECIES_IS_WHITELISTED
	darksight = 6
	brute_mod = 1.1

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/hollow_bones),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/hollow_bones),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/hollow_bones),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/hollow_bones),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/hollow_bones),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/hollow_bones),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/hollow_bones),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/hollow_bones)
		)
