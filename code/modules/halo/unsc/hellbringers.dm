#define HELLBRINGER_OVERRIDE 'code/modules/halo/icons/hell.dmi'

/obj/item/clothing/under/unsc/hellbringer_undersuit
	desc = "Heat resistant undersuit for hazardous combat"
	name = "UNSC Hellbringer undersuit"
	icon = HELLBRINGER_OVERRIDE
	icon_override = HELLBRINGER_OVERRIDE
	item_state = "hellbringer_undersuit"
	icon_state = "hellbringer_undersuit"
	worn_state = "hellbringer_undersuit"
	starting_accessories = /obj/item/clothing/accessory/badge/tags
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO|LEGS
	siemens_coefficient = 0.6

/obj/item/clothing/head/helmet/hellbringer
	name = "Heat resistant helmet"
	desc = "A helmet for high-temperature operations"
	icon = HELLBRINGER_OVERRIDE
	icon_override = HELLBRINGER_OVERRIDE
	item_state = "hellbringer_helmet"
	icon_state = "hellbringer_helmet"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 0, bullet = 15, laser = 50,energy = 40, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD|FACE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3
	integrated_hud = /obj/item/clothing/glasses/hud/tactical/odst_hud

/obj/item/clothing/shoes/hellbringer
	name = "Heat-proof boots"
	desc = "Standard issue combat boots for the UNSC Marines, modified to withstand extreme temperature"
	icon = HELLBRINGER_OVERRIDE
	icon_override = HELLBRINGER_OVERRIDE
	item_state = "hellbringer_boots"
	icon_state = "hellbringer_boots"
	force = 5
	armor = list(melee = 0, bullet = 20, laser = 10, energy = 40, bomb = 15, bio = 0, rad = 0)
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 0
	stepsound = 'code/modules/halo/sounds/walk_sounds/marine_boots.ogg'
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/thick/unsc/hellbringer
	name = "UNSC Hellbringer gloves"
	desc = "Heat-proof gloves, designed to perfectly support a flamethrower"
	icon_override = HELLBRINGER_OVERRIDE
	icon = HELLBRINGER_OVERRIDE
	body_parts_covered = HANDS
	heat_protection = HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	icon_state = "hellbringer_gloves"
	item_state = "hellbringer_gloves"

/obj/item/clothing/suit/storage/hellbringer
	name = "Hellbringer Armor"
	desc = "An armored protective vest worn by the members of the UNSC Marine Corps. Several plates have been replaced with heat-reflective material"
	icon = HELLBRINGER_OVERRIDE
	icon_override = HELLBRINGER_OVERRIDE
	item_state = "hellbringer_oversuit"
	icon_state = "hellbringer_oversuit"
	blood_overlay_type = "armor"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 45, bullet = 45, laser = 45, energy = 50, bomb = 30, bio = 25, rad = 25) //Increased energy resistance for less in others
	armor_thickness = 20
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing)

#undef HELLBRINGER_OVERRIDE