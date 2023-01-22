/datum/sprite_accessory/marking/tattoo
	icon = 'icons/mob/human_races/species/tattoos.dmi'
	draw_order = 60
	use_organ_tag = FALSE
	species_allowed = list(
		SPECIES_HUMAN,
		SPECIES_IPC,
		SPECIES_SKRELL
	)


/datum/sprite_accessory/marking/tattoo/head
	disallows = list(/datum/sprite_accessory/marking/tattoo/head)
	body_parts = list(BP_HEAD)


/datum/sprite_accessory/marking/tattoo/chest
	disallows = list(/datum/sprite_accessory/marking/tattoo/chest)

	body_parts = list(BP_CHEST)


/datum/sprite_accessory/marking/tattoo/groin
	disallows = list(/datum/sprite_accessory/marking/tattoo/groin)
	body_parts = list(BP_GROIN)



/datum/sprite_accessory/marking/tattoo/arm_left
	disallows = list(/datum/sprite_accessory/marking/tattoo/arm_left)
	body_parts = list(BP_L_ARM)


/datum/sprite_accessory/marking/tattoo/arm_right
	disallows = list(/datum/sprite_accessory/marking/tattoo/arm_right)
	body_parts = list(BP_R_ARM)



/datum/sprite_accessory/marking/tattoo/hand_left
	disallows = list(/datum/sprite_accessory/marking/tattoo/hand_left)
	body_parts = list(BP_L_HAND)



/datum/sprite_accessory/marking/tattoo/hand_right
	disallows = list(/datum/sprite_accessory/marking/tattoo/hand_right)
	body_parts = list(BP_R_HAND)



/datum/sprite_accessory/marking/tattoo/leg_left
	disallows = list(/datum/sprite_accessory/marking/tattoo/leg_left)
	body_parts = list(BP_L_LEG)


/datum/sprite_accessory/marking/tattoo/leg_right
	disallows = list(/datum/sprite_accessory/marking/tattoo/leg_right)
	body_parts = list(BP_R_LEG)


/datum/sprite_accessory/marking/tattoo/foot_left
	disallows = list(/datum/sprite_accessory/marking/tattoo/foot_left)
	body_parts = list(BP_L_FOOT)



/datum/sprite_accessory/marking/tattoo/foot_right
	disallows = list(/datum/sprite_accessory/marking/tattoo/foot_right)
	body_parts = list(BP_R_FOOT)



/datum/sprite_accessory/marking/tattoo/chest/hive
	name = "Tattoo (Hive, Back)"
	icon_state = "hive-chest"



/datum/sprite_accessory/marking/tattoo/chest/nightling
	name = "Tattoo (Nightling, Back)"
	icon_state = "nightling-chest"



/datum/sprite_accessory/marking/tattoo/arm_left/campbell
	name = "Tattoo (Campbell, Left Arm)"
	icon_state = "campbell-arm-left"



/datum/sprite_accessory/marking/tattoo/arm_right/campbell
	name = "Tattoo (Campbell, Right Arm)"
	icon_state = "campbell-arm-right"



/* The icon for this needs work.
/datum/sprite_accessory/marking/head/tiger
	name = "Tattoo (Tiger Stripes, Head)"
	icon_state = "tiger-head"
*/


/datum/sprite_accessory/marking/tattoo/chest/tiger
	name = "Tattoo (Tiger Stripes, Body)"
	icon_state = "tiger-chest"


/datum/sprite_accessory/marking/tattoo/groin/tiger
	name = "Tattoo (Tiger Stripes, Groin)"
	icon_state = "tiger-groin"


/datum/sprite_accessory/marking/tattoo/arm_left/tiger
	name = "Tattoo (Tiger Stripes, Left Arm)"
	icon_state = "tiger-arm-left"


/datum/sprite_accessory/marking/tattoo/arm_right/tiger
	name = "Tattoo (Tiger Stripes, Right Arm)"
	icon_state = "tiger-arm-right"


/datum/sprite_accessory/marking/tattoo/leg_left/tiger
	name = "Tattoo (Tiger Stripes, Left Leg)"
	icon_state = "tiger-leg-left"


/datum/sprite_accessory/marking/tattoo/leg_right/tiger
	name = "Tattoo (Tiger Stripes, Right Leg)"
	icon_state = "tiger-leg-right"


/datum/sprite_accessory/marking/tattoo/foot_left/tiger
	name = "Tattoo (Tiger Stripes, Left Foot)"
	icon_state = "tiger-foot-left"


/datum/sprite_accessory/marking/tattoo/foot_right/tiger
	name = "Tattoo (Tiger Stripes, Right Foot)"
	icon_state = "tiger-foot-right"


/* The icon for this needs work.
/datum/sprite_accessory/marking/tattoo/head/bands
	name = "Tattoo (Bands, Head)"
	icon_state = "bands-head"
*/


/datum/sprite_accessory/marking/tattoo/chest/bands
	name = "Tattoo (Bands, Body)"
	icon_state = "bands-chest"


/datum/sprite_accessory/marking/tattoo/groin/bands
	name = "Tattoo (Bands, Groin)"
	icon_state = "bands-groin"


/datum/sprite_accessory/marking/tattoo/arm_left/bands
	name = "Tattoo (Bands, Left Arm)"
	icon_state = "bands-arm-left"


/datum/sprite_accessory/marking/tattoo/arm_right/bands
	name = "Tattoo (Bands, Right Arm)"
	icon_state = "bands-arm-right"


/datum/sprite_accessory/marking/tattoo/hand_left/bands
	name = "Tattoo (Bands, Left Hand)"
	icon_state = "bands-hand-left"


/datum/sprite_accessory/marking/tattoo/hand_right/bands
	name = "Tattoo (Bands, Right Hand)"
	icon_state = "bands-hand-right"


/datum/sprite_accessory/marking/tattoo/leg_left/bands
	name = "Tattoo (Bands, Left Leg)"
	icon_state = "bands-leg-left"


/datum/sprite_accessory/marking/tattoo/leg_right/bands
	name = "Tattoo (Bands, Right Leg)"
	icon_state = "bands-leg-right"


/datum/sprite_accessory/marking/tattoo/foot_left/bands
	name = "Tattoo (Bands, Left Foot)"
	icon_state = "bands-foot-left"


/datum/sprite_accessory/marking/tattoo/foot_right/bands
	name = "Tattoo (Bands, Right Foot)"
	icon_state = "bands-foot-right"
