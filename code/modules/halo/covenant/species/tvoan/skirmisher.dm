
/datum/species/kig_yar_skirmisher
	name = "T\'vaoan Kig-Yar"
	name_plural = "T\'vaoan Kig-Yar"
	spawn_flags = SPECIES_CAN_JOIN
	blurb = "T'vaoan Skirmishers are the same species as the more common, lightly-built Ruutian Jackals, but \
		they are subspecies that is faster, stronger, can jump higher and are more agile than any ordinary Kig-Yar. In addition, \
		they sport manes of feathers rather than quills. A Skirmisher's voice is more raspy and guttural - this is \
		because they have an expanded voice chamber in their throat. Skirmishers serve as Covenant shock troopers \
		and close-range combatants, attacking in packs and using flanking tactics. Kig'Yar feud with Unggoy for \
		status as the lowest ranked members of the Covenant."
	flesh_color = "#FF9463"
	blood_color = "#532476"
	default_language = "Sangheili"
	language = "Sangheili"
	additional_langs = list("T\'voai")
	icobase = 'code/modules/halo/covenant/species/tvoan/r_skirmishers.dmi'
	deform = 'code/modules/halo/covenant/species/tvoan/r_skirmishers.dmi'
	icon_template = 'code/modules/halo/covenant/species/tvoan/r_skirmisher_template.dmi'
	default_faction = "Covenant"
	unarmed_types = list(/datum/unarmed_attack/bird_punch)
	appearance_flags = HAS_SKIN_TONE | HAS_HAIR_COLOR | HAS_EYE_COLOR

	pain_mod = 0.9
	brute_mod = 1.1
	burn_mod = 1.
	slowdown = -1.0

	equipment_slowdown_multiplier = 0.7

	item_icon_offsets = list(list(0,0),list(0,0),null,list(0,0),null,null,null,list(0,0),null)

	has_limbs = list( //Normal limbs. A bit better than ruutian
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/tvoan),
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
	icon = 'code/modules/halo/covenant/species/tvoan/r_skirmishers.dmi'
	icon_state = "tvoanhair1"
	name = "Long Feathers"
	species_allowed = list("T\'vaoan Kig-Yar")

/datum/sprite_accessory/hair/skirmisherquills/two
	icon = 'code/modules/halo/covenant/species/tvoan/r_skirmishers.dmi'
	icon_state = "tvoanhair2"
	name = "Short Feathers"
	species_allowed = list("T\'vaoan Kig-Yar")

/mob/living/carbon/human/covenant/tvoan/New(var/new_loc)
	. = ..(new_loc,"T\'vaoan Kig-Yar")
	faction = "Covenant"

/datum/language/tvoai
	name = "T\'voai"
	desc = "The language of the T\'vaoan KigYar"
	native = 1
	colour = "tvaoan"
	syllables = list("hss","rar","hrar","har","rah","huss","hee","ha","schra","skraw","skree","skrss","hos","hosk")
	key = "T"
	flags = RESTRICTED

/obj/item/organ/external/head/tvoan
	eye_icon = "eyes_s"
	eye_icon_location = 'code/modules/halo/covenant/species/tvoan/r_skirmishers.dmi'

