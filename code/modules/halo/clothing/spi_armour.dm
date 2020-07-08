
/obj/item/clothing/head/helmet/spi
	name = "Semi-Powered Infiltration helmet"
	desc = "Advanced stealth capabilities and spaceworthiness with reduced protection."
	icon = 'code/modules/halo/clothing/spi_armour.dmi'
	icon_state = "mk4-helm"
	item_state = "mk4-helm-worn"
	icon_override = 'code/modules/halo/clothing/spi_armour.dmi'
	item_state_slots = list(slot_l_hand_str = "syndicate-helm-black", slot_r_hand_str = "syndicate-helm-black")

	armor = list(melee = 50, bullet = 30, laser = 50, energy = 20, bomb = 25, bio = 0, rad = 0)
	species_restricted = list("Human")
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	heat_protection = HEAD|FACE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = HEAD|FACE
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	flash_protection = FLASH_PROTECTION_MAJOR

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light_dual"
	brightness_on = 4
	on = 0

/obj/item/clothing/suit/armor/special/spi
	name = "Semi-Powered Infiltration armour Gen-1"
	desc = "Advanced stealth capabilities and spaceworthiness with reduced protection."
	icon = 'code/modules/halo/clothing/spi_armour.dmi'
	icon_state = "mk4-shell"
	item_state = "mk4-shell-worn"
	icon_override = 'code/modules/halo/clothing/spi_armour.dmi'
	item_state_slots = list(slot_l_hand_str = "syndicate-black", slot_r_hand_str = "syndicate-black")

	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25) //ODST tier but covers less of their body.
	armor_thickness = 20
	allowed = list(/obj/item/device,/obj/item/weapon/gun,/obj/item/ammo_magazine)

	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDETAIL
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	species_restricted = list("Human")
	max_suitstore_w_class = ITEM_SIZE_HUGE

/obj/item/clothing/shoes/magboots/spi
	name = "Semi-Powered Infiltration boots"
	desc = "Advanced stealth capabilities, spaceworthiness and mag-pulse traction with reduced protection."
	icon = 'code/modules/halo/clothing/spi_armour.dmi'
	icon_override = 'code/modules/halo/clothing/spi_armour.dmi'
	icon_state = "neuralboots_obj0"
	icon_base = "neuralboots_obj"
	item_state = "neuralboots"
	species_restricted = list("Human")

	armor = list(melee = 40, bullet = 40, laser = 5, energy = 30, bomb = 15, bio = 0, rad = 0)
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	stepsound = null

/obj/item/clothing/gloves/thick/spi
	name = "Semi-Powered Infiltration gloves"
	desc = "Advanced stealth capabilities and spaceworthiness with reduced protection."
	icon = 'code/modules/halo/clothing/spi_armour.dmi'
	icon_override = 'code/modules/halo/clothing/spi_armour.dmi'
	icon_state = "neuralgloves_obj"
	item_state = "neuralgloves"
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	body_parts_covered = HANDS
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("Human")
