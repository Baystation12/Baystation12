/datum/sprite_accessory/marking/human
	species_allowed = list(SPECIES_HUMAN)
	icon = 'icons/mob/human_races/species/human/bodymods.dmi'


/datum/sprite_accessory/marking/human/ears
	body_parts = list(BP_HEAD)
	draw_target = MARKING_TARGET_HEAD
	draw_order = 75 //before horns
	do_coloration = DO_COLORATION_AUTO
	disallows = list(
		/datum/sprite_accessory/marking/human/ears,
		/datum/sprite_accessory/marking/human/horns/ram
	)


/datum/sprite_accessory/marking/human/ears/pointy
	icon_state = "ears_pointy"
	name = "Ear Biomods (Pointy)"
	do_coloration = DO_COLORATION_SKIN


/datum/sprite_accessory/marking/human/ears/pointy_down
	icon_state = "ears_pointy_down"
	name = "Ear Biomods (Pointy, Down)"
	do_coloration = DO_COLORATION_SKIN


/datum/sprite_accessory/marking/human/ears/pointy_long
	icon_state = "ears_pointy_long"
	name = "Ear Biomods (Pointy, Long)"
	do_coloration = DO_COLORATION_SKIN


/datum/sprite_accessory/marking/human/ears/pointy_long_down
	icon_state = "ears_pointy_long_down"
	name = "Ear Biomods (Pointy, Long, Down)"
	do_coloration = DO_COLORATION_SKIN


/datum/sprite_accessory/marking/human/ears/cat
	icon_state = "ears_cat"
	name = "Ear Biomods (Cat)"


/datum/sprite_accessory/marking/human/ears/rabbit
	icon_state = "ears_bun"
	name = "Ear Biomods (Rabbit)"


/datum/sprite_accessory/marking/human/horns
	body_parts = list(BP_HEAD)
	draw_target = MARKING_TARGET_HEAD
	disallows = list(/datum/sprite_accessory/marking/human/horns)


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

