
GLOBAL_LIST_INIT(sanshyuum_virtues, world.file2list('code/modules/halo/covenant/species/sanshyuum/sanshyuum_virtues.txt'))
GLOBAL_LIST_INIT(sanshyuum_titles, world.file2list('code/modules/halo/covenant/species/sanshyuum/sanshyuum_titles.txt'))

/datum/species/sanshyuum
	name = "San Shyuum"
	name_plural = "San Shyuum"
	blurb = "San Shyuum (Latin Perfidia vermis, meaning \"Worms of Treachery\"), also \
		known as Prophets by humanity, are a species who are the leadership caste within the \
		Covenant. Prophets to exert complete control over religious and political \
		affairs.  Although physically frail compared to other Covenant species, they wield \
		near absolute power over the Covenant. They have a strong religious importance \
		throughout the Covenant Hierarchy."
	flesh_color = "#4A4A64"
	icobase = 'code/modules/halo/covenant/species/sanshyuum/r_sanshyuum.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/covenant/species/sanshyuum/r_sanshyuum.dmi'
	icon_template = 'code/modules/halo/covenant/species/sanshyuum/sanshyuum_template.dmi'
	default_language = LANGUAGE_SANGHEILI
	language = LANGUAGE_SANGHEILI
	additional_langs = list(LANGUAGE_SANSHYUUM, LANGUAGE_ENGLISH)
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_EYE_COLOR
	item_icon_offsets = list(list(0,2),list(0,2),null,list(0,2),null,null,null,list(0,2),null)
	brute_mod = 1.1
	burn_mod = 1.1
	equipment_slowdown_multiplier = 1.2
	default_faction = "Covenant"
	gibbed_anim = null
	dusted_anim = null

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/sanshyuum),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

/datum/species/sanshyuum/get_random_name(var/gender)
	var/newname = "[pick(GLOB.sanshyuum_titles)] of [pick(GLOB.sanshyuum_virtues)]"
	return newname

/mob/living/carbon/human/covenant/sanshyuum/New(var/new_loc)
	. = ..(new_loc,"San Shyuum")

/obj/item/organ/external/head/sanshyuum
	eye_icon = "eyes_s"
	eye_icon_location = 'code/modules/halo/covenant/species/sanshyuum/r_sanshyuum.dmi'