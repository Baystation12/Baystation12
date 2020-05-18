/datum/species/mantid

	name =                   SPECIES_MANTID_ALATE
	name_plural =            "Kharmaan Alates"
	show_ssd =               "quiescent"

	description = "When human explorers finally arrived at the outer reaches of Skrellian space, they hoped to find \
	new frontiers and new planets to exploit. They were largely not expecting to have entire expeditions lost \
	amid reports of highly advanced, astonishingly violent mantid-cephlapodean sentients with particle cannons."

	icobase =                 'icons/mob/human_races/species/ascent/alate/body.dmi'
	deform =                  'icons/mob/human_races/species/ascent/alate/body.dmi'
	damage_overlays =         'icons/mob/human_races/species/ascent/alate/damage_mask.dmi'
	blood_mask =              'icons/mob/human_races/species/ascent/alate/blood_mask.dmi'
	organs_icon =             'icons/mob/human_races/species/ascent/organs.dmi'

	blood_color =             "#660066"
	flesh_color =             "#009999"
	hud_type =                /datum/hud_data/mantid
	move_trail =              /obj/effect/decal/cleanable/blood/tracks/snake

	speech_chance = 100
	speech_sounds = list(
		'sound/voice/ascent1.ogg',
		'sound/voice/ascent2.ogg',
		'sound/voice/ascent3.ogg',
		'sound/voice/ascent4.ogg',
		'sound/voice/ascent5.ogg',
		'sound/voice/ascent6.ogg'
	)

	siemens_coefficient =   0.2 // Crystalline body.
	oxy_mod =               0.8 // Don't need as much breathable gas as humans.
	toxins_mod =            0.8 // Not as biologically fragile as meatboys.
	radiation_mod =         0.5 // Not as biologically fragile as meatboys.
	flash_mod =               2 // Highly photosensitive.

	min_age =                 1
	max_age =                20
	slowdown =               -1
	rarity_value =            3
	gluttonous =              2
	body_temperature =        null

	breath_type =             GAS_METHYL_BROMIDE
	exhale_type =             GAS_METHANE
	poison_types =            list(GAS_PHORON)

	reagent_tag =             IS_MANTID
	genders =                 list(MALE)

	appearance_flags =        0
	species_flags =           SPECIES_FLAG_NO_SCAN  | SPECIES_FLAG_NO_SLIP        | SPECIES_FLAG_NO_MINOR_CUT
	spawn_flags =             SPECIES_IS_RESTRICTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN

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
	unarmed_types = list(
		/datum/unarmed_attack/claws/strong/gloves,
		/datum/unarmed_attack/bite/sharp
	)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest/insectoid),
		BP_GROIN =  list("path" = /obj/item/organ/external/groin/insectoid/mantid),
		BP_HEAD =   list("path" = /obj/item/organ/external/head/insectoid),
		BP_L_ARM =  list("path" = /obj/item/organ/external/arm/insectoid),
		BP_L_HAND = list("path" = /obj/item/organ/external/hand/insectoid),
		BP_R_ARM =  list("path" = /obj/item/organ/external/arm/right/insectoid),
		BP_R_HAND = list("path" = /obj/item/organ/external/hand/right/insectoid),
		BP_R_LEG =  list("path" = /obj/item/organ/external/leg/right/insectoid),
		BP_L_LEG =  list("path" = /obj/item/organ/external/leg/insectoid),
		BP_L_FOOT = list("path" = /obj/item/organ/external/foot/insectoid),
		BP_R_FOOT = list("path" = /obj/item/organ/external/foot/right/insectoid)
	)

	has_organ = list(
		BP_HEART =             /obj/item/organ/internal/heart/insectoid,
		BP_STOMACH =           /obj/item/organ/internal/stomach/insectoid,
		BP_LUNGS =             /obj/item/organ/internal/lungs/insectoid,
		BP_LIVER =             /obj/item/organ/internal/liver/insectoid,
		BP_KIDNEYS =           /obj/item/organ/internal/kidneys/insectoid,
		BP_BRAIN =             /obj/item/organ/internal/brain/insectoid,
		BP_EYES =              /obj/item/organ/internal/eyes/insectoid,
		BP_SYSTEM_CONTROLLER = /obj/item/organ/internal/controller
	)

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_ASCENT,
		TAG_HOMEWORLD = HOME_SYSTEM_KHARMAANI,
		TAG_FACTION =   FACTION_ASCENT_ALATE,
		TAG_RELIGION =  RELIGION_KHARMAANI
	)

	descriptors = list(
		/datum/mob_descriptor/height = -1,
		/datum/mob_descriptor/body_length = -2
		)

	pain_emotes_with_pain_level = list(
			list(/decl/emote/visible/ascent_shine, /decl/emote/visible/ascent_dazzle) = 80,
			list(/decl/emote/visible/ascent_glimmer, /decl/emote/visible/ascent_pulse) = 50,
			list(/decl/emote/visible/ascent_flicker, /decl/emote/visible/ascent_glint) = 20,
		)

/datum/species/mantid/handle_sleeping(var/mob/living/carbon/human/H)
	return

/datum/species/mantid/get_blood_name()
	return "hemolymph"

/datum/species/mantid/post_organ_rejuvenate(var/obj/item/organ/org, var/mob/living/carbon/human/H)
	org.status |= ORGAN_CRYSTAL

/datum/species/mantid/equip_survival_gear(var/mob/living/carbon/human/H, var/extendedtank = 1)
	return

/datum/species/mantid/gyne

	name =                    SPECIES_MANTID_GYNE
	name_plural =             "Kharmaan Gynes"

	genders =                 list(FEMALE)
	icobase =                 'icons/mob/human_races/species/ascent/gyne/body.dmi'
	deform =                  'icons/mob/human_races/species/ascent/gyne/body.dmi'
	icon_template =           'icons/mob/human_races/species/ascent/gyne/template.dmi'
	damage_overlays =         'icons/mob/human_races/species/ascent/gyne/damage_mask.dmi'
	blood_mask =              'icons/mob/human_races/species/ascent/gyne/blood_mask.dmi'

	gluttonous =              3
	slowdown =                2
	rarity_value =           10
	min_age =                 5
	max_age =               500
	blood_volume =         1200
	spawns_with_stack =       0

	pixel_offset_x =        -4
	antaghud_offset_y =      18
	antaghud_offset_x =      4

	bump_flag =               HEAVY
	push_flags =              ALLMOBS
	swap_flags =              ALLMOBS

	override_limb_types = list(
		BP_HEAD = /obj/item/organ/external/head/insectoid/mantid,
		BP_GROIN = /obj/item/organ/external/groin/insectoid/mantid/gyne
	)

	descriptors = list(
		/datum/mob_descriptor/height = 5,
		/datum/mob_descriptor/body_length = 2
	)

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_ASCENT,
		TAG_HOMEWORLD = HOME_SYSTEM_KHARMAANI,
		TAG_FACTION =   FACTION_ASCENT_GYNE,
		TAG_RELIGION =  RELIGION_KHARMAANI
	)

/datum/species/mantid/gyne/attempt_grab(var/mob/living/carbon/human/grabber, var/mob/living/target)
	if(grabber != target)
		grabber.unEquip(grabber.l_hand)
		grabber.unEquip(grabber.r_hand)
		to_chat(grabber, SPAN_WARNING("You drop everything as you seize \the [target]!"))
		playsound(grabber.loc, 'sound/weapons/pierce.ogg', 25, 1, -1)
	. = ..(grabber, target, GRAB_NAB)

/datum/species/mantid/gyne/New()
	equip_adjust = list(
		slot_l_hand_str = list(
			"[NORTH]" = list("x" = -4, "y" = 12),
			"[EAST]" = list("x" =  -4, "y" = 12),
			"[SOUTH]" = list("x" = -4, "y" = 12),
			"[WEST]" = list("x" =  -4, "y" = 12)
		)
	)
	..()

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

/datum/species/nabber/monarch
	name = SPECIES_MONARCH_WORKER
	name_plural = "Monarch Serpentid Workers"
	spawn_flags = SPECIES_IS_RESTRICTED | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_NO_FBP_CHARGEN
	has_organ = list(
		BP_BRAIN =             /obj/item/organ/internal/brain/insectoid/nabber,
		BP_EYES =              /obj/item/organ/internal/eyes/insectoid/nabber,
		BP_TRACH =             /obj/item/organ/internal/lungs/insectoid/nabber,
		BP_HEART =             /obj/item/organ/internal/heart/open,
		BP_LIVER =             /obj/item/organ/internal/liver/insectoid/nabber,
		BP_STOMACH =           /obj/item/organ/internal/stomach/insectoid,
		BP_SYSTEM_CONTROLLER = /obj/item/organ/internal/controller
	)

	force_cultural_info = list(
		TAG_CULTURE =   CULTURE_ASCENT,
		TAG_HOMEWORLD = HOME_SYSTEM_KHARMAANI,
		TAG_FACTION =   FACTION_ASCENT_SERPENTID,
		TAG_RELIGION =  RELIGION_KHARMAANI
	)

/datum/species/nabber/monarch/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_NABBER

/datum/species/nabber/monarch/queen
	name = SPECIES_MONARCH_QUEEN
	name_plural = "Monarch Serpentid Queens"
