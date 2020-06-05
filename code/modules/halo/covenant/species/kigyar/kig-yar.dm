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
	icobase = 'code/modules/halo/covenant/species/kigyar/r_kig-yar.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/covenant/species/kigyar/r_kig-yar.dmi'
	default_language = "Sangheili" //Just for now, no special language just yet
	language = "Sangheili"
	additional_langs = list("Ruuhti")
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	inherent_verbs = list(/mob/living/carbon/human/proc/focus_view)
	spawn_flags = SPECIES_CAN_JOIN
	flags = NO_MINOR_CUT
	appearance_flags = HAS_SKIN_TONE | HAS_HAIR_COLOR
	darksight = 6
	brute_mod = 1.1
	burn_mod = 1.1
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


GLOBAL_LIST_INIT(first_names_kig_yar, world.file2list('code/modules/halo/covenant/species/kigyar/first_kig-yar.txt'))

/mob/living/carbon/human/covenant/kigyar/New(var/new_loc)
	. = ..(new_loc,"Kig-Yar")

/datum/language/ruuhti
	name = "Ruuhti"
	desc = "The language of the Ruuhtian KigYar"
	native = 1
	colour = "ruutian"
	syllables = list("hss","rar","hrar","har","rah","huss","hee","ha","schra","skraw","skree","skrss","hos","hosk")
	key = "R"
	flags = RESTRICTED

/obj/item/clothing/shoes/ruutian_boots
	name = "Ruutian leg armour"
	desc = "The natural armor on your legs provides a small amount of protection against the elements."
	icon = KIGYAR_CLOTHING_PATH
	icon_state = "naturallegarmor"
	item_state = " "
	armor = list(melee = 35, bullet = 35, laser = 5, energy = 25, bomb = 15, bio = 0, rad = 0)

	canremove = 0
	unacidable = 1

/datum/species/kig_yar/get_random_name(var/gender)
	return pick(GLOB.first_names_kig_yar)

/datum/species/kig_yar/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	return

/datum/unarmed_attack/bird_punch
    attack_verb = list("claws", "kicks", "strikes", "slashes", "rips", "bites")
    attack_noun = list("talon")
    eye_attack_text = "talons"
    eye_attack_text_victim = "digits"
    damage = 0
    sharp = 1
    edge = 1

/datum/sprite_accessory/hair/kiggiyhair/
		icon = 'code/modules/halo/covenant/species/kigyar/r_kig-yar.dmi'
		icon_state = "h_kiggiyhair"
		name = "No Quills"
		species_allowed = list("Kig-Yar")

/datum/sprite_accessory/hair/kiggiyhair/one
		icon = 'code/modules/halo/covenant/species/kigyar/r_kig-yar.dmi'
		icon_state = "h_kiggiyhairone"
		name = "Long Quills"
		species_allowed = list("Kig-Yar")

/datum/sprite_accessory/hair/kiggiyhair/two
		icon = 'code/modules/halo/covenant/species/kigyar/r_kig-yar.dmi'
		icon_state = "h_kiggiyhairtwo"
		name = "Short Quills"
		species_allowed = list("Kig-Yar")


