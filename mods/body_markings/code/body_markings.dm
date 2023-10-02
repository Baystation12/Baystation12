/datum/sprite_accessory/marking/modpack_body_markings
	do_coloration = DO_COLORATION_AUTO // На случай если оффы дефолтный изменят
	icon = 'mods/body_markings/icons/body_markings.dmi'
	use_organ_tag = FALSE


/datum/sprite_accessory/marking/modpack_body_markings/heterochromia
	name = "Heterochromia"
	icon_state = "heterochromia"
	do_coloration = DO_COLORATION_USER
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_HUMAN, SPECIES_TAJARA)

/datum/sprite_accessory/marking/modpack_body_markings/greatbrows
	name = "Greatbrows"
	icon_state = "greatbrows"
	draw_target = MARKING_TARGET_HEAD
	body_parts = list(BP_HEAD)
	species_allowed = list(SPECIES_HUMAN, SPECIES_TAJARA)


// HUMAN / SKRELL / TAJARA

/datum/sprite_accessory/marking/modpack_body_markings/humanlike
	species_allowed = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARA)


/datum/sprite_accessory/marking/modpack_body_markings/humanlike/tonage_chest
	name = "Tonage 1 (Masculine)"
	icon_state = "tonage_chest"
	do_coloration = DO_COLORATION_USER
	body_parts = list(BP_CHEST)
	disallows = list(/datum/sprite_accessory/marking/modpack_body_markings/humanlike/tonage_chest)

/datum/sprite_accessory/marking/modpack_body_markings/humanlike/tonage_chest/feminine
	name = "Tonage 1 (Feminine)"
	icon_state = "tonage_chest_f"

/datum/sprite_accessory/marking/modpack_body_markings/humanlike/tonage_chest/two
	name = "Tonage 2 (Masculine)"
	icon_state = "tonage_chest2"

/datum/sprite_accessory/marking/modpack_body_markings/humanlike/tonage_chest/two/feminine
	name = "Tonage 2 (Feminine)"
	icon_state = "tonage_chest2_f"


/datum/sprite_accessory/marking/modpack_body_markings/humanlike/burnface_right
	name = "Burnface (severe, right)"
	icon_state = "burnface_right"
	do_coloration = DO_COLORATION_SKIN
	body_parts = list(BP_HEAD)
	disallows = list(/datum/sprite_accessory/marking/modpack_body_markings/humanlike/burnface_right)

/datum/sprite_accessory/marking/modpack_body_markings/humanlike/burnface_right/slight
	name = "Burnface (slight, right)"
	icon_state = "fburnface_right"


/datum/sprite_accessory/marking/modpack_body_markings/humanlike/burnface_left
	name = "Burnface (severe, left)"
	icon_state = "burnface_left"
	do_coloration = DO_COLORATION_SKIN
	body_parts = list(BP_HEAD)
	disallows = list(/datum/sprite_accessory/marking/modpack_body_markings/humanlike/burnface_left)

/datum/sprite_accessory/marking/modpack_body_markings/humanlike/burnface_left/slight
	name = "Burnface (slight, left)"
	icon_state = "fburnface_left"


/datum/sprite_accessory/marking/modpack_body_markings/humanlike/scar
	name = "Scar (Large)"
	icon_state = "scar1"
	do_coloration = DO_COLORATION_SKIN
	body_parts = list(BP_HEAD)
	disallows = list(/datum/sprite_accessory/marking/modpack_body_markings/humanlike/scar)

/datum/sprite_accessory/marking/modpack_body_markings/humanlike/scar/small
	name = "Scar (Small)"
	icon_state = "scar2"


// HUMAN ONLY

/datum/sprite_accessory/marking/modpack_body_markings
	species_allowed = list(SPECIES_HUMAN)
	icon = 'mods/body_markings/icons/body_markings.dmi'

/datum/sprite_accessory/marking/modpack_body_markings/human/tonage_chest3
	name = "Tonage 3 (Masculine)"
	icon_state = "h_tonage_chest3"
	do_coloration = DO_COLORATION_SKIN
	body_parts = list(BP_CHEST)
	disallows = list(
		/datum/sprite_accessory/marking/modpack_body_markings/humanlike/tonage_chest,
		/datum/sprite_accessory/marking/modpack_body_markings/human/tonage_chest3
	)

/datum/sprite_accessory/marking/modpack_body_markings/human/tonage_chest3/femenine
	name = "Tonage 3 (Feminine)"
	icon_state = "h_tonage_chest3_f"


/datum/sprite_accessory/marking/modpack_body_markings/human/bodyhair
	name = "Body hair"
	icon_state = "h_bodyhair"
	do_coloration = DO_COLORATION_USER
	body_parts = list(BP_CHEST)

/datum/sprite_accessory/marking/modpack_body_markings/human/brows_head
	name = "Brows"
	icon_state = "brows_head"
	draw_target = MARKING_TARGET_HEAD
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/modpack_body_markings/human/eyeshade
	name = "Eyeshade"
	icon_state = "eyeshade"
	do_coloration = DO_COLORATION_USER
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/modpack_body_markings/human/blush
	name = "Blush"
	icon_state = "blush"
	do_coloration = FALSE
	body_parts = list(BP_HEAD)

/datum/sprite_accessory/marking/modpack_body_markings/human/eyeshadow
	name = "Eyeshadow"
	icon_state = "eyeshadow"
	do_coloration = DO_COLORATION_USER
	body_parts = list(BP_HEAD)
