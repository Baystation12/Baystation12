/obj/item/clothing/accessory/leg_guards
	name = "leg guards"
	desc = "A pair of armored leg pads in black. Attaches to a plate carrier."
	icon_override = 'icons/mob/onmob/onmob_modular_armor.dmi'
	icon = 'icons/obj/clothing/obj_suit_modular_armor.dmi'
	accessory_icons = list(slot_tie_str = 'icons/mob/onmob/onmob_modular_armor.dmi', slot_wear_suit_str = 'icons/mob/onmob/onmob_modular_armor.dmi')
	icon_state = "legguards"
	gender = PLURAL
	body_parts_covered = LEGS
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_PADDED
	)
	slot = ACCESSORY_SLOT_ARMOR_L
	body_location = LEGS
	flags_inv = CLOTHING_BULKY


/obj/item/clothing/accessory/leg_guards/blue
	desc = "A pair of armored leg pads in blue. Attaches to a plate carrier."
	icon_state = "legguards_blue"


/obj/item/clothing/accessory/leg_guards/navy
	desc = "A pair of armored leg pads in navy blue. Attaches to a plate carrier."
	icon_state = "legguards_navy"


/obj/item/clothing/accessory/leg_guards/green
	desc = "A pair of armored leg pads in green. Attaches to a plate carrier."
	icon_state = "legguards_green"


/obj/item/clothing/accessory/leg_guards/tan
	desc = "A pair of armored leg pads in tan. Attaches to a plate carrier."
	icon_state = "legguards_tan"


/obj/item/clothing/accessory/leg_guards/merc
	name = "heavy leg guards"
	desc = "A pair of heavily armored leg pads in red-trimmed black. Attaches to a plate carrier."
	icon_state = "legguards_merc"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_PISTOL,
		laser = ARMOR_LASER_HANDGUNS,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)


/obj/item/clothing/accessory/leg_guards/riot
	name = "riot leg guards"
	desc = "A pair of armored leg pads with heavy padding to protect against melee attacks. Looks like they might impair movement."
	icon_state = "legguards_riot"
	armor = list(
		melee = ARMOR_MELEE_VERY_HIGH,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.5
	slowdown = 1
	accessory_flags = EMPTY_BITFIELD


/obj/item/clothing/accessory/leg_guards/ballistic
	name = "ballistic leg guards"
	desc = "A pair of armored leg pads with heavy plates to protect against ballistic projectiles. Looks like they might impair movement."
	icon_state = "legguards_ballistic"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_RIFLE,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0.7
	slowdown = 1
	accessory_flags = EMPTY_BITFIELD


/obj/item/clothing/accessory/leg_guards/ablative
	name = "ablative leg guards"
	desc = "A pair of armored leg pads with advanced shielding to protect against energy weapons. Looks like they might impair movement."
	icon_state = "legguards_ablative"
	armor = list(
		melee = ARMOR_MELEE_KNIVES,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_RIFLES,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_PADDED
	)
	siemens_coefficient = 0
	slowdown = 1
	accessory_flags = EMPTY_BITFIELD
