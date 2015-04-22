/obj/item/clothing/head/hardhat
	name = "hard hat"
	desc = "A piece of headgear used in dangerous working conditions to protect the head. Comes with a built-in flashlight."
	icon_state = "hardhat0_yellow"
	item_state = "hardhat0_yellow"
	brightness_on = 4 //luminosity when on
	light_overlay = "hardhat_light"
	armor = list(melee = 30, bullet = 5, laser = 20,energy = 10, bomb = 20, bio = 10, rad = 20)
	flags_inv = 0
	siemens_coefficient = 0.9

/obj/item/clothing/head/hardhat/orange
	icon_state = "hardhat0_orange"
	item_state = "hardhat0_orange"

/obj/item/clothing/head/hardhat/red
	icon_state = "hardhat0_red"
	item_state = "hardhat0_red"
	name = "firefighter helmet"
	flags = STOPPRESSUREDAMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/white
	icon_state = "hardhat0_white"
	item_state = "hardhat0_white"
	flags = STOPPRESSUREDAMAGE
	heat_protection = HEAD
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/head/hardhat/dblue
	icon_state = "hardhat0_dblue"
	item_state = "hardhat0_dblue"
