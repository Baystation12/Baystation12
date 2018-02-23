#define MARINE_OVERRIDE 'code/modules/halo/clothing/marine.dmi'
#define ITEM_INHAND 'code/modules/halo/clothing/marine_items.dmi'

/obj/item/clothing/under/unsc/marine_fatigues
	desc = "standard issue for UNSC marines"
	name = "UNSC Marine fatigues"
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "uniform"
	icon_state = "uniform"
	worn_state = "UNSC Marine Fatigues"

/obj/item/clothing/head/helmet/marine
	name = "CH252 Helmet"
	desc = "the standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Helmet"
	icon_state = "helmet_novisor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 25, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3

/obj/item/clothing/head/helmet/marine/visor
	desc = "the standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Visor Helmet"
	icon_state = "helmet"

/obj/item/clothing/suit/storage/marine
	name = "M52B Body Armor"
	desc = "an armored protective vest worn by the members of the UNSC Marine Corps."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "armor"
	icon_state = "M52B Body Armor"
	blood_overlay_type = "armor"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 50, bullet = 45, laser = 20, energy = 20, bomb = 60, bio = 0, rad = 0)
	var/slots = 4
	allowed = list(/obj/item/ammo_magazine/,/obj/item/weapon/melee/combat_knife)
	var/max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 20

/obj/item/clothing/shoes/marine
	name = "VZG7 Armored Boots"
	desc = "standard issue combat boots for the UNSC Marines, worn as a part of the Marine BDU."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "boots"
	icon_state = "boots"
	force = 5
	armor = list(melee = 40, bullet = 60, laser = 5, energy = 5, bomb = 40, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/weapon/storage/belt/marine_ammo
	name = "Ammunition Storage Belt"
	desc = "A belt with many various pouches to hold ammunition"
	icon = 'code/modules/halo/clothing/marine_items.dmi'
	icon_state = "UNSC Marine Ammo Belt item"
	item_state = "UNSC Marine Ammo Belt"
	storage_slots = 6

	can_hold = list(/obj/item/ammo_magazine,/obj/item/ammo_box,/obj/item/weapon/grenade/frag/m9_hedp,/obj/item/weapon/grenade/smokebomb,/obj/item/weapon/grenade/chem_grenade/incendiary)

/obj/item/weapon/storage/belt/marine_medic
	name = "Medical Supplies Storage Belt"
	desc = "A belt with multiple hooks to hold medical kits, alongside a few small ammunition pouches"
	icon_state = "medicalbelt"
	/*icon = ITEM_INHAND //Using normal medical belt sprites for now.
	icon_override = MARINE_OVERRIDE
	icon_state = "UNSC Marine Medical Belt item"
	item_state = "UNSC Marine Medical Belt"*/
	storage_slots = 5

	can_hold = list(/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m127_saphp,/obj/item/ammo_magazine/m127_saphe,/obj/item/weapon/storage/firstaid/unsc)

#undef MARINE_OVERRIDE
#undef ITEM_INHAND