/datum/species/mantid

	name =                   SPECIES_MANTID_ALATE
	name_plural =            "Mantid Alates"
	show_ssd =               "quiescent"

	blurb = "When human explorers finally arrived at the outer reaches of Skrellian space, they hoped to find \
	new frontiers and new planets to exploit. They were largely not expecting to have entire expeditions lost \
	amid reports of highly advanced, astonishingly violent mantid-cephlapodean sentients with particle cannons."

	icobase =                'icons/mob/human_races/r_alate.dmi'
	deform =                 'icons/mob/human_races/r_alate.dmi'
	damage_overlays =        'icons/mob/human_races/masks/dam_alate.dmi'
	blood_mask =             'icons/mob/human_races/masks/blood_alate.dmi'
	eye_icon_location =      'icons/mob/human_races/r_alate.dmi'
	eye_icon =               "eyes"
	blood_color =            "#660066"
	flesh_color =            "#009999"
	hud_type =               /datum/hud_data/mantid
	move_trail =             /obj/effect/decal/cleanable/blood/tracks/snake
	has_floating_eyes =      TRUE
	speech_sounds = list('sound/voice/mantid1.ogg', 'sound/voice/mantid2.ogg')


	min_age =                 1
	max_age =                20
	slowdown =               -1
	rarity_value =            3
	gluttonous =              2
	siemens_coefficient =     0
	body_temperature =        null

	breath_type =             "methyl_bromide"
	poison_type =             "phoron"
	exhale_type =             "methane"

	reagent_tag =             IS_MANTID
	genders =                 list(MALE)

	language =                LANGUAGE_MANTID_NONVOCAL
	default_language =        LANGUAGE_MANTID_NONVOCAL
	additional_langs =         list(LANGUAGE_MANTID_BROADCAST, LANGUAGE_MANTID_VOCAL, LANGUAGE_NABBER, LANGUAGE_SKRELLIAN)

	num_alternate_languages = 1

	appearance_flags =        0
	species_flags =           SPECIES_FLAG_NO_SCAN | SPECIES_FLAG_NO_SLIP | SPECIES_FLAG_NO_MINOR_CUT
	spawn_flags =             SPECIES_IS_RESTRICTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN | SPECIES_NO_LACE

	heat_discomfort_strings = list(
		"You feel brittle and overheated.",
		"Your overheated carapace flexes uneasily.",
		"Overheated ichor trickles from your eyes."
		)
	cold_discomfort_strings = list(
		"Frost forms along your carapace.",
		"You hear a faint crackle of ice as you shift your freezing body.",
		"Your movements become sluggish under the weight of the chilly conditions."
		)
	inherent_verbs = list(
		/mob/living/carbon/human/proc/leap,
		/mob/living/carbon/human/proc/gut
		)
	unarmed_types = list(
		/datum/unarmed_attack/claws/strong,
		/datum/unarmed_attack/bite/sharp
	)

/datum/species/mantid/gyne

	name =                    SPECIES_MANTID_GYNE
	name_plural =             "Mantid Gynes"

	genders =                 list(FEMALE)
	eye_icon_location =       'icons/mob/human_races/r_gyne.dmi'
	icobase =                 'icons/mob/human_races/r_gyne.dmi'
	deform =                  'icons/mob/human_races/r_gyne.dmi'
	icon_template =           'icons/mob/human_races/r_gyne.dmi'
	damage_overlays =         'icons/mob/human_races/masks/dam_gyne.dmi'
	blood_mask =              'icons/mob/human_races/masks/blood_gyne.dmi'

	gluttonous =              3
	slowdown =                2
	num_alternate_languages = 2
	rarity_value =           10
	min_age =                 5
	max_age =               500
	blood_volume =         1200
	spawns_with_stack =       0

	siemens_coefficient =   0.2 // Crystalline body.
	brute_mod =             1.5 // Fragile. Can be shattered.
	burn_mod =              0.5 // Crystalline, reflective.
	oxy_mod =               0.8 // Don't need as much breathable gas as humans.
	toxins_mod =            0.8 // Not as biologically fragile as meatboys.
	radiation_mod =         0.5 // Not as biologically fragile as meatboys.
	flash_mod =               2 // Highly photosensitive.

	pixel_offset_x =        -22
	antaghud_offset_y =      32
	antaghud_offset_x =      22

	bump_flag =               HEAVY
	push_flags =              ALLMOBS
	swap_flags =              ALLMOBS


	equip_adjust = list(
		slot_all_slots_str = list(
			NORTH = list("x" = 22, "y" = -2),
			EAST =  list("x" = 22, "y" = -2),
			SOUTH = list("x" = 22, "y" = -2),
			WEST =  list("x" = 22, "y" = -2)
		)
	)

	inherent_verbs = list(
		/mob/living/carbon/human/proc/gut,
		/mob/living/carbon/human/proc/devour_head
		)

/datum/hud_data/mantid
	gear = list(
		"i_clothing" =   list("loc" = ui_iclothing, "name" = "Uniform",      "slot" = slot_w_uniform, "state" = "center", "toggle" = 1),
		"o_clothing" =   list("loc" = ui_oclothing, "name" = "Suit",         "slot" = slot_wear_suit, "state" = "suit",   "toggle" = 1),
		"mask" =         list("loc" = ui_mask,      "name" = "Mask",         "slot" = slot_wear_mask, "state" = "mask",   "toggle" = 1),
		"gloves" =       list("loc" = ui_gloves,    "name" = "Gloves",       "slot" = slot_gloves,    "state" = "gloves", "toggle" = 1),
		"eyes" =         list("loc" = ui_glasses,   "name" = "Glasses",      "slot" = slot_glasses,   "state" = "glasses","toggle" = 1),
		"l_ear" =        list("loc" = ui_l_ear,     "name" = "Left Ear",     "slot" = slot_l_ear,     "state" = "ears",   "toggle" = 1),
		"r_ear" =        list("loc" = ui_r_ear,     "name" = "Right Ear",    "slot" = slot_r_ear,     "state" = "ears",   "toggle" = 1),
		"head" =         list("loc" = ui_head,      "name" = "Hat",          "slot" = slot_head,      "state" = "hair",   "toggle" = 1),
		"shoes" =        list("loc" = ui_shoes,     "name" = "Shoes",        "slot" = slot_shoes,     "state" = "shoes",  "toggle" = 1),
		"suit storage" = list("loc" = ui_sstore1,   "name" = "Suit Storage", "slot" = slot_s_store,   "state" = "suitstore"),
		"back" =         list("loc" = ui_back,      "name" = "Back",         "slot" = slot_back,      "state" = "back"),
		"id" =           list("loc" = ui_id,        "name" = "ID",           "slot" = slot_wear_id,   "state" = "id"),
		"storage1" =     list("loc" = ui_storage1,  "name" = "Left Pocket",  "slot" = slot_l_store,   "state" = "pocket"),
		"storage2" =     list("loc" = ui_storage2,  "name" = "Right Pocket", "slot" = slot_r_store,   "state" = "pocket"),
		"belt" =         list("loc" = ui_belt,      "name" = "Belt",         "slot" = slot_belt,      "state" = "belt")
		)
