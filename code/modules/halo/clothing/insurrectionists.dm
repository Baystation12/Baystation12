#define INNIE_OVERRIDE 'code/modules/halo/clothing/inniearmor.dmi'

/obj/item/clothing/under/innie/jumpsuit
	name = "Insurrectionist-modified Jumpsuit"
	desc = "A grey jumpsuit, modified with extra padding."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "jumpsuit1_s"
	icon_state = "jumpsuit1_s"
	worn_state = "jumpsuit1"
	armor = list(melee = 10, bullet = 10, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/head/helmet/innie
	name = "Armored Helmet"
	desc = "An armored helmet composed of materials salvaged from a wide array of UNSC equipment"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "helmet"
	icon_state = "helmet"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 40, bullet = 30, laser = 40,energy = 5, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/suit/armor/innie
	name = "Salvaged Armor"
	desc = "A worn set of armor composed of materials usually found in UNSC equipment, modified for superior bullet resistance."
	icon = INNIE_OVERRIDE
	icon_state = "armor1"
	icon_override = INNIE_OVERRIDE
	blood_overlay_type = "armor1"
	armor = list(melee = 45, bullet = 40, laser = 40, energy = 40, bomb = 40, bio = 20, rad = 15)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	item_flags = THICKMATERIAL
	flags_inv = HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/mask/innie/shemagh
	name = "Shemagh"
	desc = "A headdress designed to keep out dust and protect agains the sun."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	icon_state = "shemagh"
	item_state = "shemagh"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

#undef INNIE_OVERRIDE