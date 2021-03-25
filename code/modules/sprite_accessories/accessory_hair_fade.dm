/datum/sprite_accessory/marking/hair_fade
	icon = 'icons/mob/human_races/species/human/hair_fade.dmi'
	species_allowed = list(SPECIES_HUMAN)
	body_parts = list(BP_HEAD)
	draw_target = MARKING_TARGET_HAIR
	draw_order = 50 //before ears & horns
	disallows = list(/datum/sprite_accessory/marking/hair_fade)

/datum/sprite_accessory/marking/hair_fade/fade_up
	name = "Fade (Up)"
	icon_state = "fade_up"

/datum/sprite_accessory/marking/hair_fade/fade_down
	name = "Fade (Down)"
	icon_state = "fade_down"

/datum/sprite_accessory/marking/hair_fade/fade_left
	name = "Fade (Left)"
	icon_state = "fade_left"

/datum/sprite_accessory/marking/hair_fade/fade_right
	name = "Fade (Right)"
	icon_state = "fade_right"

/datum/sprite_accessory/marking/hair_fade/split_vert_right
	name = "Fade (Split Right)"
	icon_state = "split_vert_right"

/datum/sprite_accessory/marking/hair_fade/split_vert_left
	name = "Fade (Split Left)"
	icon_state = "split_vert_left"

/datum/sprite_accessory/marking/hair_fade/split_horz
	name = "Fade (Split Top)"
	icon_state = "split_horz"
