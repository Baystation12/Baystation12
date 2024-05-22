/datum/sprite_accessory/hair/skr
	name = "Skrell Male Tentacles"
	icon = 'icons/mob/human_races/species/skrell/hair.dmi'
	icon_state = "skrell_hair_m"
	species_allowed = list(SPECIES_SKRELL)
	gender = MALE

/datum/sprite_accessory/hair/skr/tentacle_f
	name = "Skrell Female Tentacles"
	icon_state = "skrell_hair_f"
	gender = FEMALE

/datum/sprite_accessory/skin/skrell
	name = "Default skrell skin"
	icon_state = "default"
	icon = 'icons/mob/human_races/species/skrell/body.dmi'
	species_allowed = list(SPECIES_SKRELL)

/datum/sprite_accessory/marking/skrell
	icon = 'icons/mob/human_races/species/skrell/markings.dmi'
	draw_order = 50
	use_organ_tag = FALSE
	species_allowed = list(SPECIES_SKRELL)

/datum/sprite_accessory/marking/skrell/body
	name = "Spots (Right, Body, Skrell)"
	draw_target = MARKING_TARGET_SKIN
	icon_state = "spots-right"
	body_parts = list(
		BP_HEAD,
		BP_CHEST,
		BP_GROIN,
		BP_L_ARM,
		BP_L_HAND,
		BP_R_ARM,
		BP_R_HAND,
		BP_L_LEG,
		BP_L_FOOT,
		BP_R_LEG,
		BP_R_FOOT
	)

/datum/sprite_accessory/marking/skrell/body/left
	name = "Spots (Left, Body, Skrell)"
	icon_state = "spots-left"

/datum/sprite_accessory/marking/skrell/head
	name = "Spots (Right, Tentacles, Skrell)"
	draw_target = MARKING_TARGET_HAIR
	icon_state = "spots-hair-right"
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/skrell/head/left
	name = "Spots (Left, Tentacles, Skrell)"
	icon_state = "spots-hair-left"