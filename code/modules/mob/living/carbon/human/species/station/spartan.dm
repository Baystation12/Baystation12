/datum/species/spartan
	name = "Spartan"
	name_plural = "Spartans"
	blurb = ""//Not in chargen
	blood_color = "#A10808"
	flesh_color = "#FFC896"
	icobase = 'code/modules/halo/icons/species/r_Augmented_Human.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_Augmented_Human.dmi'
	icon_template = 'code/modules/halo/icons/species/r_Augmented_Human_template.dmi'
	flags = NO_MINOR_CUT
	total_health = 250 //Same base health as sangheili
	spawn_flags = SPECIES_IS_WHITELISTED
	brute_mod = 0.8 //Lower amount of brute damage taken than sangheili
	item_icon_offsets = list(-1,3)

	has_limbs =  list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/augmented),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/augmented),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/augmented),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/augmented),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/augmented),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/augmented),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/augmented),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/augmented),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/augmented),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/augmented),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/augmented)
		)