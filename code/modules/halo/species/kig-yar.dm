/datum/species/kig_yar
	name = "Kig-Yar"
	name_plural = "Kig-Yar"
	blurb = "Ruutian Kig'Yar are the most commonly encountered species of Kig'Yar, known as Jackals. \
		They have an avian appearance and serve as light infantry in combat, being equipped with either \
		light weaponry and large energy defence point defence shields or (less frequently) marksman weaponry \
		due to their enhanced hearing and eyesight. Kig'Yar feud with Unggoy for status as the lowest ranked\
		members of the Covenant."
	flesh_color = "#FF9463"
	blood_color = "#532476"
	icobase = 'code/modules/halo/icons/species/r_kig-yar.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/icons/species/r_kig-yar.dmi'
	default_language = "Sangheili" //Just for now, no special language just yet
	language = "Sangheili"
	additional_langs = list("Ruuhti")
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	inherent_verbs = list(/mob/living/carbon/human/proc/focus_view)
	spawn_flags = SPECIES_CAN_JOIN
	flags = NO_MINOR_CUT
	appearance_flags = HAS_SKIN_TONE | HAS_UNDERWEAR
	darksight = 6
	brute_mod = 1.1
	gluttonous = GLUT_ANYTHING
	item_icon_offsets = list(list(0,0),list(0,0),null,list(0,0),null,null,null,list(0,0),null)
	total_health = 200
	default_faction = "Covenant"
	unarmed_types = list(/datum/unarmed_attack/bird_punch)

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

	pain_scream_sounds = list(\
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_1.ogg',
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_2.ogg',
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_3.ogg',
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_4.ogg',
		'code/modules/halo/sounds/species_pain_screams/kiggyscream_5.ogg')

/datum/species/kig_yar/create_organs(var/mob/living/carbon/human/H)
	. = ..()

	H.equip_to_slot(new /obj/item/clothing/shoes/ruutian_boots,slot_shoes)


/obj/item/clothing/shoes/ruutian_boots
	name = "Ruutian leg armour"
	desc = "The natural armor on your legs provides a small amount of protection against the elements."
	icon = 'code/modules/halo/icons/species/grunt_gear.dmi'
	icon_state = "naturallegarmor"
	item_state = " "

	canremove = 0

/datum/species/kig_yar/get_random_name(var/gender)
	return pick(GLOB.first_names_kig_yar)

/datum/species/kig_yar/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	return

/datum/species/kig_yar_skirmisher
	name = "Tvaoan Kig-Yar"
	name_plural = "Tvaoan Kig-Yar"
	spawn_flags = SPECIES_CAN_JOIN
	blurb = "T'Voan Skirmishers are the same species as the more common, lightly-built Ruutian Jackals, but \
		they are subspecies that is faster, stronger, can jump higher and are more agile than any ordinary Kig-Yar. In addition, \
		they sport manes of feathers rather than quills. A Skirmisher's voice is more raspy and guttural - this is \
		because they have an expanded voice chamber in their throat. Skirmishers serve as Covenant shock troopers \
		and close-range combatants, attacking in packs and using flanking tactics. Kig'Yar feud with Unggoy for \
		status as the lowest ranked members of the Covenant."
	flesh_color = "#FF9463"
	blood_color = "#532476"
	default_language = "Sangheili"
	language = "Sangheili"
	additional_langs = list("Tvoai")
	icobase = 'code/modules/halo/icons/species/r_skirmishers.dmi'
	deform = 'code/modules/halo/icons/species/r_skirmishers.dmi'
	icon_template = 'code/modules/halo/icons/species/r_skirmisher_template.dmi'
	default_faction = "Covenant"
	unarmed_types = list(/datum/unarmed_attack/bird_punch)
	appearance_flags = HAS_SKIN_TONE | HAS_HAIR_COLOR

	pain_mod = 0.8
	brute_mod = 1.2
	slowdown = -1.5

	total_health = 200
	pixel_offset_x = -4

	item_icon_offsets = list(list(4,-1),list(4,-1),null,list(0,0),null,null,null,list(0,0),null)

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

	pain_scream_sounds = list(\
	'code/modules/halo/sounds/species_pain_screams/kiggyscream_1.ogg',
	'code/modules/halo/sounds/species_pain_screams/kiggyscream_2.ogg',
	'code/modules/halo/sounds/species_pain_screams/kiggyscream_3.ogg',
	'code/modules/halo/sounds/species_pain_screams/kiggyscream_4.ogg',
	'code/modules/halo/sounds/species_pain_screams/kiggyscream_5.ogg')

	roll_distance = 4
	per_roll_delay = 1.5 //Slightly faster than a human's dodge roll

/datum/species/kig_yar_skirmisher/get_random_name(var/gender)
	return pick(GLOB.first_names_kig_yar)

/datum/sprite_accessory/hair/skirmisherquills
	icon = 'code/modules/halo/icons/species/r_skirmishers.dmi'
	icon_state = "h_quills"
	name = "Quills"
	species_allowed = list("Tvaoan Kig-Yar")

/datum/unarmed_attack/bird_punch
    attack_verb = list("claws", "kicks", "strikes", "slashes", "rips", "bites")
    attack_noun = list("talon")
    eye_attack_text = "talons"
    eye_attack_text_victim = "digits"
    damage = 0
    sharp = 1
    edge = 1
