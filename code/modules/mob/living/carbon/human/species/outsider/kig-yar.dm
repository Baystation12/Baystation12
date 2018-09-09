/datum/species/kig_yar
	name = "Kig-Yar"
	name_plural = "Kig-Yar"
	blurb = ""
	flesh_color = "#FF9463"
	blood_color = "#4A4A64" //Same blood colour as Elites.
	icobase = 'code/modules/halo/icons/species/r_kig-yar.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_kig-yar.dmi'
	default_language = "Sangheili" //Just for now, no special language just yet
	language = "Sangheili"
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	inherent_verbs = list(/mob/living/carbon/human/proc/focus_view)
	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	flags = NO_MINOR_CUT
	darksight = 6
	brute_mod = 1.1
	slowdown = -1.5 //-1 to negate noshoes, -0.5 for their natural speed increase.
	gluttonous = GLUT_ANYTHING
	item_icon_offsets = list(0,0)

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

/datum/species/kig_yar/skirmisher
	name = "Tvaoan Kig-Yar"
	name_plural = "Kig-Yar"
	blurb = ""
	icobase = 'code/modules/halo/icons/species/r_skirmishers.dmi'
	deform = 'code/modules/halo/icons/species/r_skirmishers.dmi'
	icon_template = 'code/modules/halo/icons/species/r_skirmisher_template.dmi'

	pain_mod = 0.9
	brute_mod = 0.95
	slowdown = -1.75

	total_health = 225
	pixel_offset_x = -5

	item_icon_offsets = list(4,-1)

	has_limbs = list( //Normal limbs. A bit better than ruutian
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

/datum/sprite_accessory/hair/skirmisherquills
	icon = 'code/modules/halo/icons/species/r_skirmishers.dmi'
	icon_state = "h_quills"
	name = "Quills"
	species_allowed = list("Tvaoan Kig-Yar")
