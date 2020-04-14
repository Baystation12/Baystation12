
/obj/item/clothing/under/ranger_kigyar
	name = "Kig-yar ranger suit"
	desc = "A Kig-yar ranger suit. Made for combat in low gravity and low pressure enviroments. Requires sealed armour and a helmet to function."
	icon = 'code/modules/halo/covenant/species/kigyar/ranger_kigyar.dmi'
	icon_state = "Ranger_bodysuit_s"
	worn_state = "Ranger_bodysuit"
	sprite_sheets = list("Kig-Yar" = 'code/modules/halo/covenant/species/kigyar/ranger_kigyar.dmi',"Tvaoan Kig-Yar" = 'code/modules/halo/covenant/species/kigyar/ranger_tvoan.dmi')
	species_restricted = list("Kig-Yar","Tvaoan Kig-Yar")
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)
	item_flags = STOPPRESSUREDAMAGE
	body_parts_covered = LEGS | FEET | ARMS | HANDS
	flags_inv = HIDETAIL
	cold_protection = LEGS | FEET | ARMS | HANDS
	heat_protection = LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/ranger_kigyar
	name = "Kig-yar ranger armor"
	desc = "Lightweight, durable armour specially made for low gravity and low pressure enviroments. Requires a sealed bodysuit and helmet to be functional."
	species_restricted = list("Kig-Yar","Tvaoan Kig-Yar")
	icon = 'code/modules/halo/covenant/species/kigyar/ranger_kigyar.dmi'
	icon_state = "Ranger_armor"
	item_state = "Ranger_armor"
	sprite_sheets = list("Kig-Yar" = 'code/modules/halo/covenant/species/kigyar/ranger_kigyar.dmi',"Tvaoan Kig-Yar" = 'code/modules/halo/covenant/species/kigyar/ranger_tvoan.dmi')
	blood_overlay_type = "armor"
	armor = list(melee = 40, bullet = 35, laser = 35, energy = 35, bomb = 40, bio = 100, rad = 35)
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = UPPER_TORSO | LOWER_TORSO
	flags_inv = HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO
	heat_protection = UPPER_TORSO | LOWER_TORSO
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)
	armor_thickness = 15

/obj/item/clothing/head/helmet/ranger_kigyar
	name = "Kig-yar ranger helmet"
	desc = "A helmet made for ranger kig-yars. Useful in harsh, low gravity enviroments.  Requires a sealed bodysuit and armour to be functional."
	icon = 'code/modules/halo/covenant/species/kigyar/ranger_kigyar.dmi'
	icon_state = "Ranger_Helmet"
	sprite_sheets = list("Kig-Yar" = 'code/modules/halo/covenant/species/kigyar/ranger_kigyar.dmi',"Tvaoan Kig-Yar" = 'code/modules/halo/covenant/species/kigyar/ranger_tvoan.dmi')
	species_restricted = list("Kig-Yar","Tvaoan Kig-Yar")
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 40, bullet = 35, laser = 35,energy = 35, bomb = 20, bio = 100, rad = 35)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)
	armor_thickness = 15

	integrated_hud = /obj/item/clothing/glasses/hud/tactical/kigyar_nv