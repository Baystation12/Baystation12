/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	action_button_name = "Toggle Headlamp"
	brightness_on = 0.5 //luminosity when on
	light_overlay = "hardhat_light"
	w_class = ITEM_SIZE_NORMAL
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 10)
	flags_inv = 0
	siemens_coefficient = 0.9
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"

/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat0_white"

/obj/item/clothing/head/hardhat/dblue
	icon_state = "hardhat0_dblue"

/obj/item/clothing/head/hardhat/EMS
	name = "\improper EMS helmet"
	desc = "A polymer helmet worn by EMTs throughout human space to protect their head. This one comes with an attached flashlight and has 'Medic' written on its back in blue lettering."
	icon_state = "EMS_helmet"
	light_overlay = "EMS_light"
	w_class = ITEM_SIZE_NORMAL
	armor = list(melee = 30, bullet = 10, laser = 10,energy = 10, bomb = 20, bio = 10, rad = 2.5)
	max_heat_protection_temperature = 1300

/obj/item/clothing/head/hardhat/firefighter
	icon_state = "Firefighter-Helmet"
	name = "firefighter helmet"
	desc = "A complete, face covering helmet specially designed for firefighting. It is airtight and has a port for internals."
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_AIRTIGHT
	permeability_coefficient = 0
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	center_of_mass = null
	randpixel = 0
	species_restricted = list("exclude", SPECIES_NABBER, SPECIES_DIONA)
	flash_protection = FLASH_PROTECTION_MAJOR

/obj/item/clothing/head/hardhat/firefighter/Chief
	icon_state = "Firefighter-Helmet-Chief"

