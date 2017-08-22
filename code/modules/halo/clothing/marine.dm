
/obj/item/clothing/under/unsc/marine_fatigues
	desc = "standard issue for UNSC marines"
	name = "UNSC Marine fatigues"
	icon_state = "jumpsuit_marine_s"
	item_state = "g_suit"
	worn_state = "jumpsuit_marine"

/obj/item/clothing/head/helmet/marine
	name = "CH252 Helmet"
	desc = "the standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	icon_state = "marine"
	item_state = "marine"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3

/obj/item/clothing/head/helmet/marine/visor
	desc = "the standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR."
	icon_state = "marine_visor"
	item_state = "marine_visor"

/obj/item/clothing/suit/armor/marine
	name = "M52B Body Armor"
	desc = "an armored protective vest worn by the members of the UNSC Marine Corps."
	icon_state = "marine"
	item_state = "marine"
	blood_overlay_type = "armor"
	armor = list(melee = 50, bullet = 95, laser = 4, energy = 4, bomb = 60, bio = 0, rad = 0)

/obj/item/clothing/shoes/marine
	name = "VZG7 Armored Boots"
	desc = "standard issue combat boots for the UNSC Marines, worn as a part of the Marine BDU."
	icon_state = "marine"
	item_state = "marine"
	force = 5
	armor = list(melee = 40, bullet = 60, laser = 5, energy = 4, bomb = 40, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6

	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
