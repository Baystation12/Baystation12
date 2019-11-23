/obj/item/clothing/head/helmet/ranger_tvoan
	name = "T-Vaoan Kig-yar ranger helmet"
	desc = "A helmet made for ranger T-Vaoan kig-yars. Useful in harsh, low gravity enviroments"
	icon = 'code/modules/halo/icons/species/skirm_clothing.dmi'
	icon_state = "rangerhelm_obj"
	item_state = "rangerhelmet"
	species_restricted = list("Tvaoan Kig-Yar")
	sprite_sheets = list("Tvaoan Kig-Yar" = 'code/modules/halo/icons/species/skirm_clothing.dmi')
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 20, bullet = 25, laser = 25,energy = 25, bomb = 10, bio = 100, rad = 100)
	armor_thickness = 15
	slowdown_general = 1

	integrated_hud = /obj/item/clothing/glasses/hud/tactical/kigyar_nv

/obj/item/clothing/suit/armor/covenant/ranger_tvoan
	name = "T-Vaoan Kig-yar ranger armor"
	desc = "Lightweight, durable armour specially made for low gravity and low pressure enviroments"
	species_restricted = list("Tvaoan Kig-Yar")
	icon = 'code/modules/halo/icons/species/skirm_clothing.dmi'
	icon_state = "ranger_obj"
	item_state = "ranger"
	blood_overlay_type = "armor"
	sprite_sheets = list("Tvaoan Kig-Yar" = 'code/modules/halo/icons/species/skirm_clothing.dmi')
	armor = list(melee = 20, bullet = 25, laser = 25, energy = 25, bomb = 25, bio = 100, rad = 100)
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS
	flags_inv = HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO
	heat_protection = UPPER_TORSO | LOWER_TORSO
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	armor_thickness = 15
	slowdown_general = 1

/obj/item/clothing/under/covenant/ranger_tvoan
	name = "T-Vaoan Kig-yar ranger suit"
	desc = "A T-Vaoan Kig-yar ranger suit. Made for combat in low gravity and low pressure enviroments"
	icon = 'code/modules/halo/icons/species/skirm_clothing.dmi'
	icon_state = "jackal_bodysuit_s"
	worn_state = "jackal_bodysuit"
	sprite_sheets = list("Tvaoan Kig-Yar" = 'code/modules/halo/icons/species/skirm_clothing.dmi')
	species_restricted = list("Tvaoan Kig-Yar")
	item_flags = STOPPRESSUREDAMAGE
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	flags_inv = HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE