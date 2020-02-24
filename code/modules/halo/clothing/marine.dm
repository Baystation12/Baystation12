#define MARINE_OVERRIDE 'code/modules/halo/clothing/marine.dmi'
#define ITEM_INHAND 'code/modules/halo/clothing/marine_items.dmi'

/obj/item/clothing/under/unsc/marine_fatigues
	desc = "Standard issue uniform for UNSC marine corps."
	name = "UNSC Marine fatigues"
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "UNSC Marine Fatigues"
	icon_state = "uniform_obj"
	worn_state = "UNSC Marine Fatigues"
	starting_accessories = /obj/item/clothing/accessory/badge/tags

/obj/item/clothing/head/helmet/marine
	name = "Olive Camo CH251 Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Helmet"
	icon_state = "helmet_novisor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/marine/medic
	name = "Olive Camo CH251 Helmet Medic"
	desc = "A medic variant of the standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	item_state = "CH252 Helmet Medic"
	icon_state = "helmet novisor medic_obj"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/medic/visor
	name = "Olive Camo CH251-V Helmet Medic"
	desc = "A medic variant of the standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	item_state = "CH252 Visor Helmet Medic"
	icon_state = "helmet medic_obj"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/visor
	name = "Olive Camo CH251-V Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Visor Helmet"
	icon_state = "helmet"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/brown
	name = "Brown Camo CH251 Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Helmet B"
	icon_state = "helmet_b"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/medic/brown
	name = "Brown Camo CH251 Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Helmet Medic B"
	icon_state = "helmet medic-b_obj"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/medic/brownvisor
	name = "Brown Camo CH251 Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Visor Helmet Medic B"
	icon_state = "helmet medic-b_obj"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/marine/brownvisor
	name = "Brown Camo CH251-V Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force. Has an inbuilt VISOR for eye protection."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Visor Helmet B"
	icon_state = "helmet_b"
	body_parts_covered = HEAD|EYES

/obj/item/clothing/suit/storage/marine
	name = "Olive Camo M52A Body Armor"
	desc = "An armored protective vest worn by the members of the UNSC Marine Corps."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "M52B Body Armor regular"
	icon_state = "M52B Body Armor regular_obj"
	blood_overlay_type = "armor"
	item_state_slots = list(slot_l_hand_str = "armor", slot_r_hand_str = "armor")
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 50, bullet = 45, laser = 40, energy = 45, bomb = 35, bio = 0, rad = 0)
	armor_thickness = 20
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)

/obj/item/clothing/suit/storage/marine/pilot
	name = "Flak Vest"
	desc = "A vest made of flak to protect against ballistic or explosions projectiles."
	icon_state = "unsc_pilot_armor-obj"
	item_state = "unsc_pilot_armor-worn"
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_LARGE
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	armor = list(melee = 30, bullet = 30, laser = 10, energy = 10, bomb = 45, bio = 0, rad = 0)
	armor_thickness = 20

/obj/item/clothing/suit/storage/marine/military_police
	name = "M52A Body Armor NavSec"
	desc = "An armored protective vest worn by the members of the UNSC Marine Corps. This one is modified for the use of naval security officers."
	armor = list(melee = 50, bullet = 50, laser = 40, energy = 40, bomb = 35, bio = 0, rad = 0)
	armor_thickness = 20

/obj/item/clothing/suit/storage/marine/medic
	name = "Olive Camo M52A Body Armor Medic"
	desc = "An armored protective vest worn by the members of the UNSC Marine Corps."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "M52B Body Armor Medic"
	icon_state = "M52B Body Armor Medic_obj"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/marine/medic/brown
	name = "Brown Camo M52A Body Armor Medic"
	desc = "An armored protective vest worn by the members of the UNSC Marine Corps."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "M52B Body Armor Medic B"
	icon_state = "M52B Body Armor Medic B_obj"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/marine/brown
	name = "Brown Camo M52A Body Armor"
	desc = "An armored protective vest worn by the members of the UNSC Marine Corps."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "M52B Body Armor regular B"
	icon_state = "M52B Body Armor regular B_obj"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)

/obj/item/clothing/shoes/marine
	name = "Olive VZG7 Armored Boots"
	desc = "Standard issue combat boots for the UNSC Marines, worn as a part of the Marine BDU."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "boots"
	icon_state = "boots"
	force = 5
	armor = list(melee = 40, bullet = 40, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	stepsound = 'code/modules/halo/sounds/walk_sounds/marine_boots.ogg'
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/marine/brown
	name = "Brown VZG7 Armored Boots"
	desc = "Standard issue combat boots for the UNSC Marines, worn as a part of the Marine BDU."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "boots_b"
	icon_state = "boots_b"

/obj/item/weapon/storage/belt/marine_ammo
	name = "Ammunition Storage Belt"
	desc = "A belt with many various pouches to hold ammunition"
	icon = 'code/modules/halo/clothing/marine_items.dmi'
	icon_state = "UNSC Marine Ammo Belt item"
	item_state = "UNSC Marine Ammo Belt"
	storage_slots = 6

	can_hold = list(/obj/item/ammo_magazine,/obj/item/ammo_box,/obj/item/ammo_casing)

/obj/item/weapon/storage/belt/marine_medic
	name = "Medical Supplies Storage Belt"
	desc = "A belt with multiple hooks to hold medical kits, alongside a few small ammunition pouches"
	icon_state = "medicalbelt"
	/*icon = ITEM_INHAND //Using normal medical belt sprites for now.
	icon_override = MARINE_OVERRIDE
	icon_state = "UNSC Marine Medical Belt item"
	item_state = "UNSC Marine Medical Belt"*/
	storage_slots = 5

	can_hold = list(/obj/item/ammo_magazine/m5,/obj/item/ammo_magazine/m127_saphp,/obj/item/ammo_magazine/m127_saphe,/obj/item/weapon/storage/firstaid/unsc,/obj/item/weapon/storage/firstaid/erk,/obj/item/weapon/storage/firstaid/combat/unsc)

/obj/item/clothing/mask/marine
	name = "Marine Mask"
	desc = "For masking your identity, keeping your face warm, and blocking dust or sand. This one is grey."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	icon_state = "marinemask"
	item_state = "marinemask"
	w_class = ITEM_SIZE_SMALL
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEEARS|BLOCKHAIR

/obj/item/clothing/suit/space/void/unsc
	name = "\improper Salvage Suit"
	desc = "A universal suit used in EVA runs on derelicts."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS
	flags_inv = HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0.6
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	icon_state = "salvage_void"
	item_state = "salvage_void"
	item_state_slots = list(slot_l_hand_str = "syndicate-orange", slot_r_hand_str = "syndicate-orange")
	w_class = ITEM_SIZE_HUGE
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/weapon/tank)
	armor = list(melee = 60, bullet = 30, laser = 60, energy = 25, bomb = 30, bio = 100, rad = 100)

/obj/item/clothing/head/helmet/space/void/unsc
	name = "\improper Salvage Helmet"
	desc = "A universally used helmet to protect one's head against the vacuum when doing EVA."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	armor = list(melee = 30, bullet = 10, laser = 20, energy = 5, bomb = 30, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	icon_state = "rig0-salvage"
	item_state = "rig0-salvage"

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/suit/space/void/unsc/prepared/New()
	. = ..()
	helmet = new /obj/item/clothing/head/helmet/space/void/unsc
	boots = new /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/unsc/New()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/head/helmet/marine/winter
	name = "Winter Camo CH252 Helmet"
	desc = "The standard issue winter camo combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	item_state = "UNSCMarineHelmetNoVisor"
	icon_state = "UNSCMarineHelmetNoVisor"

/obj/item/clothing/head/helmet/marine/wintervisor
	name = "Winter Camo CH252-V Helmet"
	desc = "The standard issue winter camo combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	item_state = "UNSCWinterMarineHelmetVisor"
	icon_state = "UNSCWinterMarineHelmetVisor"

/obj/item/clothing/suit/storage/marine/winter
	name = "M52B Winter Body Armor"
	desc = "The standard issue winter camo combat armor worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	item_state = "UNSCMarineArmor"
	icon_state = "UNSCMarineArmor"

/obj/item/clothing/shoes/marine/winter
	name = "VZG7 Armored Winter Boots"
	desc = "Standard issue combat boots for the UNSC Marines, worn as a part of the Marine BDU."
	item_state = "UNSCMarineBoots"
	icon_state = "UNSCMarineBoots"

/obj/item/clothing/gloves/thick/unsc/winter //Combined effect of SWAT gloves and insulated gloves
	name = "UNSC Winter Combat gloves"
	desc = "Standard Issue UNSC Marine Winter Gloves."
	icon_state = "UNSCMarineGloves"
	item_state = "UNSCMarineGloves"

/obj/item/clothing/under/unsc/marine_fatigues/winter
	name = "UNSC Marine Winter fatigues"
	desc = "Standard issue winter uniform for UNSC marine corps."
	item_state = "UNSCMarineFatigues"
	icon_state = "UNSCMarineFatigues"

/obj/item/clothing/suit/spaceeva/eva
	name = "\improper EVA Marine Suit"
	desc = "A universal suit used in EVA runs on derelicts."
	icon = 'code/modules/halo/clothing/marine.dmi'
	body_parts_covered = LOWER_TORSO|UPPER_TORSO|ARMS|HANDS
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "body"
	icon_state = "body"
	item_flags = STOPPRESSUREDAMAGE|AIRTIGHT
	siemens_coefficient = 0.6
	armor_thickness = 20
	w_class = ITEM_SIZE_HUGE
	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/weapon/tank)
	armor = list(melee = 55, bullet = 40, laser = 25, energy = 25, bomb = 30, bio = 100, rad = 100)

/obj/item/clothing/head/helmet/eva/marine
	name = "\improper EVA Marine Helmet"
	desc = "A universally used helmet to protect one's head against the vacuum when doing EVA."
	icon = 'code/modules/halo/clothing/marine.dmi'
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE|BLOCKHAIR
	body_parts_covered = FACE|HEAD
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "eva"
	icon_state = "eva"
	item_flags = STOPPRESSUREDAMAGE|AIRTIGHT
	armor = list(melee = 55, bullet = 25, laser = 55,energy = 25, bomb = 15, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/shoes/magboots/eva/marine
	name = "\improper EVA Armoured Boots"
	desc = "A universally used helmet to protect one's feet against the vacuum when doing EVA."
	icon = 'code/modules/halo/clothing/marine.dmi'
	body_parts_covered = LEGS|FEET
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "evalegs"
	icon_state = "evalegs"
	item_flags = NOSLIP|STOPPRESSUREDAMAGE|AIRTIGHT
	can_hold_knife = 1
	armor = list(melee = 45, bullet = 35, laser = 10, energy = 25, bomb = 30, bio = 100, rad = 50)
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/weapon/card/id/unsc
	name = "identification card"
	desc = "An identification card worn by members of the UNSC."
	icon = 'code/modules/halo/icons/objs/(Placeholder)card.dmi'
	icon_state = "id"
	item_state = "card-id"

/obj/item/weapon/card/id/odst
	name = "ODST ID Badge"
	desc = "An identification card worn by members of the 113th Shock Troops Division."
	icon = 'code/modules/halo/icons/objs/(Placeholder)card.dmi'
	icon_state = "id"
	item_state = "card-id"

/obj/item/weapon/card/id/oni
	name = "ONI ID Badge"
	desc = "An identification card worn by members of the Office Of Naval Intelligence."
	icon = 'code/modules/halo/icons/objs/(Placeholder)card.dmi'
	icon_state = "id"
	item_state = "card-id"

/obj/item/clothing/gloves/thick/unsc //Combined effect of SWAT gloves and insulated gloves
	desc = "Standard Issue UNSC Marine Gloves."
	name = "Olive UNSC Combat gloves"
	icon_state = "unsc gloves_obj"
	item_state = "unsc gloves"
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	item_state_slots = list(slot_l_hand_str = "gloves", slot_r_hand_str = "gloves")
	body_parts_covered = HANDS
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 15, bio = 0, rad = 0)
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/gloves/thick/unsc/brown
	desc = "Standard Issue UNSC Marine Gloves."
	name = "Brown UNSC Combat gloves"
	icon_state = "unsc gloves-b_obj"
	item_state = "unsc gloves-b"
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE

/obj/item/weapon/storage/backpack/marine
	name = "Olive Camo Marine Backpack"
	desc = "The standard issue Marine pack designed for Marines to carry their essentials to battle."
	icon_state = "backpack_obj"
	item_state = "marine backpack"
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state_slots = list(slot_l_hand_str = "backpack", slot_r_hand_str = "backpack")

/obj/item/weapon/storage/backpack/marine/brown
	name = "Brown Camo Marine Backpack"
	desc = "The standard issue Marine pack designed for Marines to carry their essentials to battle."
	icon_state = "backpack-b_obj"
	item_state = "marine backpack-b"
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	item_state_slots = null

#undef MARINE_OVERRIDE
#undef ITEM_INHAND