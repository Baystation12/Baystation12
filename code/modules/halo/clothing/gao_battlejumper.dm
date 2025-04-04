#define GAO_OVERRIDE 'code/modules/halo/clothing/gao_battlejumper.dmi'

//WIP

//UNDER

obj/item/clothing/under/gao_battlejumper_jumpsuit
	name = "Battlejumper Uniform"
	desc = "A standard issue tan Gao Battlejumper uniform."
	icon_override = GAO_OVERRIDE
	icon = GAO_OVERRIDE
	icon_state = "tan-uniform_obj"
	item_state = "tan-uniform"
	worn_state = "tan-uniform"

//HELMET

/obj/item/clothing/head/helmet/gao_battlejumper
	name = "Battlejumper Helmet"
	desc = "A open helmet worn by Gao Battlejumpers."
	icon_override = GAO_OVERRIDE
	icon = GAO_OVERRIDE
	icon_state = "helmet_worn"
	item_state = "helmet_worn"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	flags_inv = HIDEEARS
	unacidable = 1
	armor = list(melee = 55, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 25, rad = 25)
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/innie

/obj/item/clothing/head/helmet/gao_battlejumper/visor
	name = "Battlejumper Visored Helmet"
	desc = "A visored helmet worn by Gao Battlejumpers."
	icon_override = GAO_OVERRIDE
	icon = GAO_OVERRIDE
	icon_state = "helmet_visor_worn"
	item_state = "helmet_visor_worn"
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	unacidable = 1
	armor = list(melee = 55, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 25, rad = 25)
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD | FACE
	heat_protection = HEAD | FACE
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/head/helmet/gao_battlejumper/solid
	name = "Battlejumper Enclosed Helmet"
	desc = "A fully enclosed helmet worn by Gao Battlejumpers."
	icon_override = GAO_OVERRIDE
	icon = GAO_OVERRIDE
	icon_state = "helmet_solid_worn"
	item_state = "helmet_solid_worn"
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
	body_parts_covered = HEAD|FACE|EYES
	unacidable = 1
	armor = list(melee = 55, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 25, rad = 25)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD | FACE
	heat_protection = HEAD | FACE
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE

//SUIT

/obj/item/clothing/suit/armor/special/gao_battlejumper
	name = "Battlejumper Light Armor"
	desc = "Standard issue armor worn by Gao Battlejumpers, EVA capable and light."
	icon_override = GAO_OVERRIDE
	icon = GAO_OVERRIDE
	icon_state = "armor_light_worn"
	item_state = "armor_light_worn"
	species_restricted = list("Human", "Orion")
	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic,/obj/item/weapon/tank)
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS
	armor_thickness = 20
	unacidable = 1
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/armor/special/gao_battlejumper/specialist
	name = "Battlejumper Specialist Armor"
	desc = "Standard issue specialist armor worn by more veteran Gao Battlejumpers, EVA capable."
	icon_override = GAO_OVERRIDE
	icon = GAO_OVERRIDE
	icon_state = "armor_spec_worn"
	item_state = "armor_spec_worn"
	species_restricted = list("Human", "Orion")
	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic,/obj/item/weapon/tank)
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS
	armor_thickness = 20
	unacidable = 1
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

//SHOES

/obj/item/clothing/shoes/magboots/gao_battlejumper
	name = "Battlejumper Magboots"
	desc = "Magnetic boots, used by Gao Battlejumpers in EVA environments."
	icon_override = GAO_OVERRIDE
	icon = GAO_OVERRIDE
	icon_state = "boots_worn"
	icon_base = "boots_worn"
	item_state = "boots_worn"
	can_hold_knife = 1
	force = 5

//GLOVES

/obj/item/clothing/gloves/thick/gao_battlejumper
	name = "Battlejumper Gloves"
	desc = "Standard issue Battlejumper gloves, armored slightly and EVA capable."
	icon_override = GAO_OVERRIDE
	icon = GAO_OVERRIDE
	item_state = "gloves_worn"
	icon_state = "gloves_worn"
	force = 5
	armor = list(melee = 80, bullet = 60, laser = 60,energy = 25, bomb = 50, bio = 10, rad = 0)
	siemens_coefficient = 0.15

