#define ONI_OVERRIDE 'code/modules/halo/clothing/oni_guard.dmi'
#define ITEM_INHAND 'code/modules/halo/clothing/item_oni.dmi'
/*
/obj/item/clothing/under/unsc/oni_uniform
	desc = "Standard issue uniform for ONI security guards."
	name = "ONI uniform"
	icon = ITEM_INHAND
	icon_override = ONI_OVERRIDE
	item_state = "uniform"
	icon_state = "uniform"
	worn_state = "Oniform"
	starting_accessories = /obj/item/clothing/accessory/badge/tags
	*/

/obj/item/clothing/head/helmet/oni_guard
	name = "CH252 Helmet"
	desc = "An ONI variant of the standard CH252 Helmet"
	icon = ITEM_INHAND
	icon_override = ONI_OVERRIDE
	item_state = "ONI Helmet"
	icon_state = "Oni_Helmet_Novisor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 25, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3

/obj/item/clothing/head/helmet/oni_guard/visor
	name = "CH252-V Helmet"
	desc = "An ONI variant of the standard CH252 Helmet. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = ONI_OVERRIDE
	item_state = "ONI Visor Helmet"
	icon_state = "Oni_Helmet"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/suit/storage/oni_guard
	name = "M52B Body Armor"
	desc = "An ONI variant of the M52B Body Armor."
	icon = ITEM_INHAND
	icon_override = ONI_OVERRIDE
	item_state = "armor"
	icon_state = "armor"
	blood_overlay_type = "armor"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 50, bullet = 35, laser = 20, energy = 20, bomb = 60, bio = 0, rad = 0)
	var/slots = 4
	var/max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 20
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/shoes/oni_guard
	name = "VZG7 Armored Boots"
	desc = "An ONI variant of the standard VZG7 Armored Boots."
	icon = ITEM_INHAND
	icon_override = ONI_OVERRIDE
	item_state = "boots"
	icon_state = "boots_ico"
	force = 5
	armor = list(melee = 40, bullet = 40, laser = 5, energy = 20, bomb = 40, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/thick/oni_guard
	desc = "Standard Issue ONI security gloves."
	name = "ONI Combat gloves"
	icon_state = "unsc_gloves"
	item_state = "unsc_gloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	body_parts_covered = HANDS
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 20, bio = 0, rad = 0)
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE


#undef ONI_OVERRIDE
#undef ITEM_INHAND