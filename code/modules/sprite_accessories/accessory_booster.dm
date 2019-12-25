/datum/sprite_accessory/marking/booster
	species_allowed = list(SPECIES_HUMAN)
	subspecies_allowed = list(SPECIES_BOOSTER)
	icon = 'icons/mob/human_races/species/human/subspecies/booster_mods.dmi'

/datum/sprite_accessory/marking/booster/ears
	body_parts = list(BP_HEAD)
	draw_target = MARKING_TARGET_HAIR
	do_colouration = FALSE
	disallows = list(/datum/sprite_accessory/marking/booster/ears)

/datum/sprite_accessory/marking/booster/horns
	body_parts = list(BP_HEAD)
	draw_target = MARKING_TARGET_HAIR
	do_colouration = TRUE
	disallows = list(/datum/sprite_accessory/marking/booster/horns)

/datum/sprite_accessory/marking/booster/ears/cat
	icon_state = "ears_cat"
	name = "Ear Biomods (Cat)"

/datum/sprite_accessory/marking/booster/ears/rabbit
	icon_state = "ears_bun"
	name = "Ear Biomods (Rabbit)"

/datum/sprite_accessory/marking/booster/horns/ram
	icon_state = "horns_ram"
	name = "Horn Biomods (Ram)"

/datum/sprite_accessory/marking/booster/horns/unathi
	icon_state = "horns_unathi"
	name = "Horn Biomods (Unathi)"

/datum/sprite_accessory/marking/booster/horns/spines_short
	icon_state = "horns_spines_short"
	name = "Horn Biomods (Short Spines)"

/datum/sprite_accessory/marking/booster/horns/spines_long
	icon_state = "horns_spines_long"
	name = "Horn Biomods (Long Spines)"

/datum/sprite_accessory/marking/booster/horns/frills_long
	icon_state = "horns_frills_long"
	name = "Horn Biomods (Long Frills)"

/datum/sprite_accessory/marking/booster/horns/frills_short
	icon_state = "horns_frills_short"
	name = "Horn Biomods (Short Frills)"
