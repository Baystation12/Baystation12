
GLOBAL_LIST_INIT(first_names_sangheili, world.file2list('code/modules/halo/covenant/species/sangheili/first_sangheili.txt'))
GLOBAL_LIST_INIT(last_names_sangheili, world.file2list('code/modules/halo/covenant/species/sangheili/last_sangheili.txt'))

/datum/species/sangheili
	name = "Sangheili"
	name_plural = "Sangheili"
	blurb = "The Sangheili (Macto cognatus, \"I glorify my kin\"), known to humans as Elites, \
		are a saurian species of strong, proud, and intelligent warriors, as well as skilled \
		combat tacticians. Due to their skill in combat, the Sangheili have formed the military \
		backbone of the Covenant for almost the entirety of its existence. They had a very strong \
		rivalry with the upstart, crude Jiralhanae."
	flesh_color = "#4A4A64"
	blood_color = "#AB36AF"
	icobase = 'code/modules/halo/covenant/species/sangheili/r_elite.dmi' //The DMI needed modification to fit the usual format (see other species' dmis)
	deform = 'code/modules/halo/covenant/species/sangheili/r_elite.dmi'
	icon_template = 'code/modules/halo/covenant/species/sangheili/Sangheili_template.dmi'
	damage_overlays = 'code/modules/halo/covenant/species/sangheili/dam_elite.dmi'
	damage_mask = 'code/modules/halo/covenant/species/sangheili/dam_mask_elite.dmi'
	blood_mask = 'code/modules/halo/covenant/species/sangheili/blood_elite.dmi'
	default_language = LANGUAGE_SANGHEILI
	language = LANGUAGE_SANGHEILI
	flags = NO_MINOR_CUT
	total_health = 250 // Stronger than humans at base health.
	radiation_mod = 0.6 //Covie weapons emit beta radiation. Resistant to 1/3 types of radiation.
	spawn_flags = SPECIES_CAN_JOIN
	appearance_flags = HAS_SKIN_TONE | HAS_EYE_COLOR
	brute_mod = 0.9
	burn_mod = 0.9
	pain_mod = 0.85
	slowdown = -0.1
	explosion_effect_mod = 0.5
	can_force_door = 1
	pixel_offset_x = -8
	item_icon_offsets = list(list(9,6),list(9,6),null,list(6,6),null,null,null,list(6,6),null)
	inhand_icon_offsets = list(list(6,-4),list(-6,-4),null,list(2,-4),null,null,null,list(2,-4),null)
	inter_hand_dist = 9
	inherent_verbs = list()
	default_faction = "Covenant"
	unarmed_types = list(/datum/unarmed_attack/elite_punch)
	gibbed_anim = null
	dusted_anim = null

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/sangheili),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right)
		)

	has_organ = list(
	BP_HEART =    /obj/item/organ/internal/heart,
	"second heart" =	 /obj/item/organ/internal/heart_secondary,
	BP_LUNGS =    /obj/item/organ/internal/lungs,
	BP_LIVER =    /obj/item/organ/internal/liver,
	BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
	BP_BRAIN =    /obj/item/organ/internal/brain,
	BP_APPENDIX = /obj/item/organ/internal/appendix,
	BP_EYES =     /obj/item/organ/internal/eyes
	)

	equipment_slowdown_multiplier = 0.9
	dodge_roll_delay = DODGE_ROLL_BASE_COOLDOWN - 2 SECOND

	pain_scream_sounds = list(\
	'code/modules/halo/sounds/species_pain_screams/elitescream_1.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_2.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_3.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_4.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_5.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_6.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_7.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_8.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_9.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_10.ogg',
	'code/modules/halo/sounds/species_pain_screams/elitescream_11.ogg')

	roll_distance = 3 //One tile further than a human

/datum/species/sangheili/equip_survival_gear(var/mob/living/carbon/human/H,var/extendedtank = 1)
	return

/datum/species/sangheili/get_random_name(var/gender)
	var/newname = pick(GLOB.first_names_sangheili)
	newname += " "
	newname += pick(GLOB.last_names_sangheili)
	return newname

/datum/unarmed_attack/elite_punch
	attack_verb = list("jabs", "strikes", "side-kicks", "punches", "knees", "kicks")
	attack_noun = list("fist")
	eye_attack_text = "fingers"
	eye_attack_text_victim = "digits"
	damage = 15

/obj/item/organ/external/head/sangheili
	eye_icon = "eyes_s"
	eye_icon_location = 'code/modules/halo/covenant/species/sangheili/r_elite.dmi'

/mob/living/carbon/human/covenant/sangheili/New(var/new_loc)
	. = ..(new_loc,"Sangheili")
