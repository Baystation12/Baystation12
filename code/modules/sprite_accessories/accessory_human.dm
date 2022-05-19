/datum/sprite_accessory/marking/human
	species_allowed = list(SPECIES_HUMAN)
	icon = 'icons/mob/human_races/species/human/bodymods.dmi'


/datum/sprite_accessory/marking/human/no_navel
	icon_state = "no_navel"
	name = "No Navel"
	body_parts = list(BP_CHEST)
	draw_target = MARKING_TARGET_SKIN
	do_coloration = DO_COLORATION_SKIN_TONE
	skin_tone_offset = list(-48, -48, -48)
	blend = ICON_NO_BLEND
	draw_order = 60


/datum/sprite_accessory/marking/human/big_eyes
	icon_state = "big_eyes"
	name = "Big Eyes"
	body_parts = list(BP_HEAD)
	draw_target = MARKING_TARGET_HEAD
	do_coloration = DO_COLORATION_EYES
	draw_order = 90


/datum/sprite_accessory/marking/human/pointy_teeth
	icon_state = "pointy_teeth"
	name = "Pointy Teeth"
	body_parts = list(BP_HEAD)
	draw_target = MARKING_TARGET_HEAD
	do_coloration = EMPTY_BITFIELD
	draw_order = 60


/datum/sprite_accessory/marking/human/ears
	body_parts = list(BP_HEAD)
	draw_target = MARKING_TARGET_HEAD
	do_coloration = DO_COLORATION_SKIN_TONE
	skin_tone_offset = list(-55, -55, -55)
	draw_order = 140
	disallows = list(
		/datum/sprite_accessory/marking/human/ears,
		/datum/sprite_accessory/marking/human/horns/ram
	)


/datum/sprite_accessory/marking/human/ears/pointy
	icon_state = "ears_pointy"
	name = "Ear Biomods (Pointy)"


/datum/sprite_accessory/marking/human/ears/pointy_down
	icon_state = "ears_pointy_down"
	name = "Ear Biomods (Pointy, Down)"


/datum/sprite_accessory/marking/human/ears/pointy_long
	icon_state = "ears_pointy_long"
	name = "Ear Biomods (Pointy, Long)"


/datum/sprite_accessory/marking/human/ears/pointy_long_down
	icon_state = "ears_pointy_long_down"
	name = "Ear Biomods (Pointy, Long, Down)"


/datum/sprite_accessory/marking/human/ears/cat
	icon_state = "ears_cat"
	name = "Ear Biomods (Cat)"
	do_coloration = DO_COLORATION_HAIR_OR_SKIN


/datum/sprite_accessory/marking/human/ears/rabbit
	icon_state = "ears_bun"
	name = "Ear Biomods (Rabbit)"
	do_coloration = DO_COLORATION_HAIR_OR_SKIN


/datum/sprite_accessory/marking/human/horns
	body_parts = list(BP_HEAD)
	draw_target = MARKING_TARGET_HEAD
	draw_order = 160
	disallows = list(
		/datum/sprite_accessory/marking/human/horns
	)


/datum/sprite_accessory/marking/human/horns/ram
	icon_state = "horns_ram"
	name = "Horn Biomods (Ram)"
	disallows = list(
		/datum/sprite_accessory/marking/human/horns,
		/datum/sprite_accessory/marking/human/ears
	)


/datum/sprite_accessory/marking/human/horns/unathi
	icon_state = "horns_unathi"
	name = "Horn Biomods (Unathi)"


/datum/sprite_accessory/marking/human/horns/spines_short
	icon_state = "horns_spines_short"
	name = "Horn Biomods (Short Spines)"


/datum/sprite_accessory/marking/human/horns/spines_long
	icon_state = "horns_spines_long"
	name = "Horn Biomods (Long Spines)"


/datum/sprite_accessory/marking/human/horns/frills_long
	icon_state = "horns_frills_long"
	name = "Horn Biomods (Long Frills)"


/datum/sprite_accessory/marking/human/horns/frills_short
	icon_state = "horns_frills_short"
	name = "Horn Biomods (Short Frills)"

