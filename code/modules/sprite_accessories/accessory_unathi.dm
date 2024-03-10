/datum/sprite_accessory/hair/una
	name = "Demon Horns"
	icon = 'icons/mob/human_races/species/unathi/hair.dmi'
	icon_state = "demon_horn"
	blend = ICON_MULTIPLY
	species_allowed = list(SPECIES_UNATHI)


/datum/sprite_accessory/hair/una/spines_long
	name = "Long Unathi Spines"
	icon_state = "soghun_longspines"


/datum/sprite_accessory/hair/una/spines_short
	name = "Short Unathi Spines"
	icon_state = "soghun_shortspines"


/datum/sprite_accessory/hair/una/frills_long
	name = "Long Unathi Frills"
	icon_state = "soghun_longfrills"


/datum/sprite_accessory/hair/una/frills_medium
	name = "Unathi Frills"
	icon_state = "frills"


/datum/sprite_accessory/hair/una/frills_water
	name = "Aquatic Frills"
	icon_state = "aquatic_frills"


/datum/sprite_accessory/hair/una/frills_short
	name = "Short Unathi Frills"
	icon_state = "soghun_shortfrills"


/datum/sprite_accessory/hair/una/horns
	name = "Unathi Horns"
	icon_state = "soghun_horns"


/datum/sprite_accessory/hair/una/swept_horn
	name = "Swept Horns"
	icon_state = "swept_horn"


/datum/sprite_accessory/hair/una/ram_horn
	name = "Ram Horns"
	icon_state = "ram_horn"


/datum/sprite_accessory/hair/una/fin_hawk
	name = "Fin Hawk"
	icon_state = "fin_hawk"


/datum/sprite_accessory/hair/una/exotic
	name = "Exotic Frills"
	icon_state = "big_frills"


/datum/sprite_accessory/hair/una/curvedown
	name = "Downward Curved Horns"
	icon_state = "curved_down"


/datum/sprite_accessory/hair/una/curveup
	name = "Upward Curved Horns"
	icon_state = "curved_up"


/datum/sprite_accessory/hair/una/sam
	name = "Inwardly Curved Horns"
	icon_state = "samurai"


/datum/sprite_accessory/hair/una/imp
	name = "Regal Horns"
	icon_state = "imperial"


/datum/sprite_accessory/hair/una/spikes_norm
	name = "Head Spikes"
	icon_state = "head_spikes"


/datum/sprite_accessory/hair/una/spikes_thicc
	name = "Thick Head Spikes"
	icon_state = "overgrown_head_spikes"


/datum/sprite_accessory/hair/una/quad
	name = "Four Horns"
	icon_state = "double_horns"


/datum/sprite_accessory/skin/unathi
	name = "Default Unathi skin"
	icon_state = "default"
	icon = 'icons/mob/human_races/species/unathi/skin.dmi'
	species_allowed = list(SPECIES_UNATHI)


/datum/sprite_accessory/marking/unathi
	species_allowed = list(SPECIES_UNATHI)


/datum/sprite_accessory/marking/unathi/body
	icon = 'icons/mob/human_races/species/unathi/body.dmi'
	draw_order = 50
	use_organ_tag = FALSE


/datum/sprite_accessory/marking/unathi/body/head
	disallows = list(/datum/sprite_accessory/marking/unathi/body/head)
	body_parts = list(BP_HEAD)


/datum/sprite_accessory/marking/unathi/body/chest
	disallows = list(/datum/sprite_accessory/marking/unathi/body/chest)
	body_parts = list(BP_CHEST)


/datum/sprite_accessory/marking/unathi/body/groin
	disallows = list(/datum/sprite_accessory/marking/unathi/body/groin)
	body_parts = list(BP_GROIN)


/datum/sprite_accessory/marking/unathi/body/arm_left
	disallows = list(/datum/sprite_accessory/marking/unathi/body/arm_left)
	body_parts = list(BP_L_ARM)


/datum/sprite_accessory/marking/unathi/body/arm_right
	disallows = list(/datum/sprite_accessory/marking/unathi/body/arm_right)
	body_parts = list(BP_R_ARM)


/datum/sprite_accessory/marking/unathi/body/hand_left
	disallows = list(/datum/sprite_accessory/marking/unathi/body/hand_left)
	body_parts = list(BP_L_HAND)


/datum/sprite_accessory/marking/unathi/body/hand_right
	disallows = list(/datum/sprite_accessory/marking/unathi/body/hand_right)
	body_parts = list(BP_R_HAND)


/datum/sprite_accessory/marking/unathi/body/leg_left
	disallows = list(/datum/sprite_accessory/marking/unathi/body/leg_left)
	body_parts = list(BP_L_LEG)


/datum/sprite_accessory/marking/unathi/body/leg_right
	disallows = list(/datum/sprite_accessory/marking/unathi/body/leg_right)
	body_parts = list(BP_R_LEG)


/datum/sprite_accessory/marking/unathi/body/foot_left
	disallows = list(/datum/sprite_accessory/marking/unathi/body/foot_left)
	body_parts = list(BP_L_FOOT)


/datum/sprite_accessory/marking/unathi/body/foot_right
	disallows = list(/datum/sprite_accessory/marking/unathi/body/foot_right)
	body_parts = list(BP_R_FOOT)


/datum/sprite_accessory/marking/unathi/body/plating_female_full
	name = "Plating (Full, Female)"
	icon_state = "plating_f_full"
	disallows = list(
		/datum/sprite_accessory/marking/unathi/body/chest,
		/datum/sprite_accessory/marking/unathi/body/arm_left,
		/datum/sprite_accessory/marking/unathi/body/arm_right,
		/datum/sprite_accessory/marking/unathi/body/leg_left,
		/datum/sprite_accessory/marking/unathi/body/leg_right
	)
	body_parts = list(
		BP_CHEST,
		BP_L_ARM,
		BP_R_ARM,
		BP_L_LEG,
		BP_R_LEG
	)


/datum/sprite_accessory/marking/unathi/body/chest/plating_female
	name = "Plating (Chest, Female)"
	icon_state = "plating_f_chest"


/datum/sprite_accessory/marking/unathi/body/plating_male_full
	name = "Plating (Full, Male)"
	icon_state = "plating_m_full"
	disallows = list(
		/datum/sprite_accessory/marking/unathi/body/chest,
		/datum/sprite_accessory/marking/unathi/body/arm_left,
		/datum/sprite_accessory/marking/unathi/body/arm_right,
		/datum/sprite_accessory/marking/unathi/body/leg_left,
		/datum/sprite_accessory/marking/unathi/body/leg_right
	)
	body_parts = list(
		BP_CHEST,
		BP_L_ARM,
		BP_R_ARM,
		BP_L_LEG,
		BP_R_LEG
	)


/datum/sprite_accessory/marking/unathi/body/chest/plating_male
	name = "Plating (Chest, Male)"
	icon_state = "plating_m_chest"


/datum/sprite_accessory/marking/unathi/tattoo
	icon = 'icons/mob/human_races/species/unathi/tattoo.dmi'
	draw_order = 60
	use_organ_tag = FALSE


/datum/sprite_accessory/marking/unathi/tattoo/head
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/head,
		/datum/sprite_accessory/marking/unathi/tattoo/head
		)
	body_parts = list(BP_HEAD)


/datum/sprite_accessory/marking/unathi/tattoo/chest
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/chest,
		/datum/sprite_accessory/marking/unathi/tattoo/chest
		)
	body_parts = list(BP_CHEST)


/datum/sprite_accessory/marking/unathi/tattoo/groin
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/groin,
		/datum/sprite_accessory/marking/unathi/tattoo/groin
		)
	body_parts = list(BP_GROIN)


/datum/sprite_accessory/marking/unathi/tattoo/arm_left
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/arm_left,
		/datum/sprite_accessory/marking/unathi/tattoo/arm_left
		)
	body_parts = list(BP_L_ARM)


/datum/sprite_accessory/marking/unathi/tattoo/arm_right
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/arm_right,
		/datum/sprite_accessory/marking/unathi/tattoo/arm_right
		)
	body_parts = list(BP_R_ARM)


/datum/sprite_accessory/marking/unathi/tattoo/hand_left
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/hand_left,
		/datum/sprite_accessory/marking/unathi/tattoo/hand_left
		)
	body_parts = list(BP_L_HAND)


/datum/sprite_accessory/marking/unathi/tattoo/hand_right
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/hand_right,
		/datum/sprite_accessory/marking/unathi/tattoo/hand_right
		)
	body_parts = list(BP_R_HAND)


/datum/sprite_accessory/marking/unathi/tattoo/leg_left
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/leg_left,
		/datum/sprite_accessory/marking/unathi/tattoo/leg_left
		)
	body_parts = list(BP_L_LEG)


/datum/sprite_accessory/marking/unathi/tattoo/leg_right
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/leg_right,
		/datum/sprite_accessory/marking/unathi/tattoo/leg_right
		)
	body_parts = list(BP_R_LEG)


/datum/sprite_accessory/marking/unathi/tattoo/foot_left
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/foot_left,
		/datum/sprite_accessory/marking/unathi/tattoo/foot_left
		)
	body_parts = list(BP_L_FOOT)


/datum/sprite_accessory/marking/unathi/tattoo/foot_right
	disallows = list(
		/datum/sprite_accessory/marking/tattoo/foot_right,
		/datum/sprite_accessory/marking/unathi/tattoo/foot_right
		)
	body_parts = list(BP_R_FOOT)


/datum/sprite_accessory/marking/unathi/tattoo/chest/hive
	name = "Tattoo (Hive, Body, Unathi)"
	icon_state = "hive-chest"


/datum/sprite_accessory/marking/unathi/tattoo/arm_left/campbell
	name = "Tattoo (Campbell, Left Arm, Unathi)"
	icon_state = "campbell-arm-left"


/datum/sprite_accessory/marking/unathi/tattoo/arm_right/campbell
	name = "Tattoo (Campbell, Right Arm, Unathi)"
	icon_state = "campbell-arm-right"


/datum/sprite_accessory/marking/unathi/tattoo/head/tiger
	name = "Tattoo (Tiger Stripes, Head, Unathi)"
	icon_state = "tiger-head"


/datum/sprite_accessory/marking/unathi/tattoo/chest/tiger
	name = "Tattoo (Tiger Stripes, Body, Unathi)"
	icon_state = "tiger-chest"


/datum/sprite_accessory/marking/unathi/tattoo/arm_left/tiger
	name = "Tattoo (Tiger Stripes, Left Arm, Unathi)"
	icon_state = "tiger-arm-left"


/datum/sprite_accessory/marking/unathi/tattoo/arm_right/tiger
	name = "Tattoo (Tiger Stripes, Right Arm, Unathi)"
	icon_state = "tiger-arm-right"


/datum/sprite_accessory/marking/unathi/tattoo/leg_left/tiger
	name = "Tattoo (Tiger Stripes, Left Leg, Unathi)"
	icon_state = "tiger-leg-left"


/datum/sprite_accessory/marking/unathi/tattoo/leg_right/tiger
	name = "Tattoo (Tiger Stripes, Right Leg, Unathi)"
	icon_state = "tiger-leg-right"


/datum/sprite_accessory/marking/unathi/tattoo/foot_left/tiger
	name = "Tattoo (Tiger Stripes, Left Foot, Unathi)"
	icon_state = "tiger-foot-left"


/datum/sprite_accessory/marking/unathi/tattoo/foot_right/tiger
	name = "Tattoo (Tiger Stripes, Right Foot, Unathi)"
	icon_state = "tiger-foot-right"


/datum/sprite_accessory/marking/unathi/tattoo/chest/bands
	name = "Tattoo (Bands, Body, Unathi)"
	icon_state = "bands-chest"


/datum/sprite_accessory/marking/unathi/tattoo/arm_left/bands
	name = "Tattoo (Bands, Left Arm, Unathi)"
	icon_state = "bands-arm-left"


/datum/sprite_accessory/marking/unathi/tattoo/arm_right/bands
	name = "Tattoo (Bands, Right Arm, Unathi)"
	icon_state = "bands-arm-right"


/datum/sprite_accessory/marking/unathi/tattoo/hand_left/bands
	name = "Tattoo (Bands, Left Hand, Unathi)"
	icon_state = "bands-hand-left"


/datum/sprite_accessory/marking/unathi/tattoo/hand_right/bands
	name = "Tattoo (Bands, Right Hand, Unathi)"
	icon_state = "bands-hand-right"


/datum/sprite_accessory/marking/unathi/tattoo/leg_left/bands
	name = "Tattoo (Bands, Left Leg, Unathi)"
	icon_state = "bands-leg-left"


/datum/sprite_accessory/marking/unathi/tattoo/leg_right/bands
	name = "Tattoo (Bands, Right Leg, Unathi)"
	icon_state = "bands-leg-right"


/datum/sprite_accessory/marking/unathi/tattoo/foot_left/bands
	name = "Tattoo (Bands, Left Foot, Unathi)"
	icon_state = "bands-foot-left"


/datum/sprite_accessory/marking/unathi/tattoo/foot_right/bands
	name = "Tattoo (Bands, Right Foot, Unathi)"
	icon_state = "bands-foot-right"
