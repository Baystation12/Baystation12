#define INNIE_OVERRIDE 'code/modules/halo/clothing/inniearmor.dmi'

// x52 stuff

/obj/item/clothing/suit/storage/toggle/x52vest
	name = "X-52 Researcher Vest"
	desc = "A  classy brown vest that has a x-52 patch on it with pockets"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "vestworn"
	icon_state = "vestobj"
	blood_overlay_type = "coat"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/device/analyzer,/obj/item/stack/medical,/obj/item/weapon/reagent_containers/dropper,/obj/item/weapon/reagent_containers/syringe,/obj/item/weapon/reagent_containers/hypospray,/obj/item/device/healthanalyzer,/obj/item/device/flashlight/pen,/obj/item/weapon/reagent_containers/glass/bottle,/obj/item/weapon/reagent_containers/glass/beaker,/obj/item/weapon/reagent_containers/pill,/obj/item/weapon/storage/pill_bottle,/obj/item/weapon/paper)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/toggle/x52vest/jacket
	name = "X-52 Researcher Jacket"
	desc = "A  classy brown jacket that has a x-52 patch on it with pockets"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "jacketworn"
	icon_state = "jacketobj"

/obj/item/clothing/mask/x52/x52shemagh
	name = "X-52 Shemagh"
	desc = "A X-52 headdress designed to keep out dust and protect agains the sun."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	icon_state = "maskworn"
	item_state = "maskobj"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/gloves/x52/x52gloves
	name = "X-52 Combat Gloves"
	desc = "These  gloves are somewhat fire and impact-resistant."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "glovesworn"
	icon_state = "gloveobj"
	force = 5
	armor = list(melee = 20, bullet = 20, laser = 0,energy = 5, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/shoes/x52boots
	name = "X-52 Jackboots"
	desc = "A pair of steel-toed work boots designed for use in industrial settings. Safety first."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	icon_state = "bootobj"
	item_state = "bootworn"
	armor = list(melee = 40, bullet = 30, laser = 0, energy = 0, bomb = 15, bio = 0, rad = 0)
	siemens_coefficient = 0.7
	can_hold_knife = 1

/obj/item/clothing/head/helmet/x52hood
	name = "Armored X-52 Hood"
	desc = "An  lightly armored hood cover composed of materials salvaged from a wide array of ONI equipment"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "hoodworn"
	icon_state = "Hoodobj"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD

/obj/item/clothing/suit/storage/x52armor/light
	name = "V12L Body Armor"
	desc = "The V12L Body Armor is composed of materials salvaged from a wide array of UNSC equipment for a lightweight design based off the M22L Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "armorworn-l"
	icon_state = "amrorobj-l"
	blood_overlay_type = "armorworn-l"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 25, bullet = 30, laser = 30, energy = 25, bomb = 25, bio = 0, rad = 0)
	armor_thickness = 10
	slowdown_general = -0.5
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/x52armor/medium
	name = "V12D Body Armor"
	desc = "The V12D Body Armor is composed of materials salvaged from a wide array of UNSC equipment as an standard design based off the M22D  Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "armorworn-m"
	icon_state = "armorobj-m"
	blood_overlay_type = "armorworn-m"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 45, bullet = 40, laser = 35, energy = 30, bomb = 30, bio = 0, rad = 0)
	armor_thickness = 15
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/under/innie/jumpsuit
	name = "Insurrectionist-modified Jumpsuit"
	desc = "A grey jumpsuit, modified with extra padding."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "jumpsuit1_s"
	icon_state = "jumpsuit1_s"
	worn_state = "jumpsuit1"
	armor = list(melee = 10, bullet = 10, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/under/innie/jumpsuit/x52
	name = "X-52 Researcher Uniform"
	desc = "A classy brown uniform, modified with extra padding that seems to have x-52 marking on it."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "x52nerdworn"
	icon_state = "x52nerdobj"
	worn_state = "x52nerdworn"

/obj/item/clothing/under/innie/jumpsuit/x52rd
	name = "X-52 Researcher Director Uniform"
	desc = "A  classy brown uniform, modified with extra padding that seems to have x-52 marking on it."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "x52headnerdworn"
	icon_state = "x52headnerdobj"
	worn_state = "x52headnerdworn"

/obj/item/clothing/head/helmet/innie
	name = "Armored Helmet"
	desc = "An armored helmet composed of materials salvaged from a wide array of UNSC equipment"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "helmet"
	icon_state = "helmet"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 40, bullet = 30, laser = 40,energy = 5, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/lighturf/brown
	name = "LV28L Armored Helmet - Brown Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_brown"
	icon_state = "l_innie_helmet_obj_brown"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/lighturf/blue
	name = "LV28L Armored Helmet - Blue Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_blue"
	icon_state = "l_innie_helmet_obj_blue"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/lighturf/green
	name = "LV28L Armored Helmet - Green Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_green"
	icon_state = "l_innie_helmet_obj_green"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/lighturf/black
	name = "LV28L Armored Helmet - Black Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_black"
	icon_state = "l_innie_helmet_obj_black"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/lighturf/white
	name = "LV28L Armored Helmet - White Camo"
	desc = "The LV28L an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a lightweight design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_helmet_white"
	icon_state = "l_innie_helmet_obj_white"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 5
	armor = list(melee = 30, bullet = 25, laser = 40,energy = 10, bomb = 15, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/brown
	name = "LV28D Armored Helmet - Brown Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_brown"
	icon_state = "m_innie_helmet_obj_brown"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	armor = list(melee = 30, bullet = 25, laser = 45,energy = 15, bomb = 20, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/blue
	name = "LV28D Armored Helmet - Blue Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_blue"
	icon_state = "m_innie_helmet_obj_blue"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	armor = list(melee = 30, bullet = 25, laser = 45,energy = 15, bomb = 20, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/green
	name = "LV28D Armored Helmet - Green Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_green"
	icon_state = "m_innie_helmet_obj_green"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	armor = list(melee = 30, bullet = 25, laser = 45,energy = 15, bomb = 20, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/black
	name = "LV28D Armored Helmet - Black Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_black"
	icon_state = "m_innie_helmet_obj_black"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	armor = list(melee = 30, bullet = 25, laser = 45,energy = 15, bomb = 20, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/mediumurf/white
	name = "LV28D Armored Helmet - White Camo"
	desc = "The LV28D an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a standard equal to the CH252 Helmet design crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_helmet_white"
	icon_state = "m_innie_helmet_obj_white"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 10
	armor = list(melee = 30, bullet = 25, laser = 45,energy = 15, bomb = 20, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/brown
	name = "LV28H Armored Helmet - Brown Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_brown"
	icon_state = "h_innie_helmet_obj_brown"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/vbrown
	name = "LV28H Armored Helmet Visor Variant - Brown Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_brown_visor"
	icon_state = "h_innie_helmet_obj_brown_visor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/blue
	name = "LV28H Armored Helmet - Blue Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_blue"
	icon_state = "h_innie_helmet_obj_blue"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/vblue
	name = "LV28H Armored Helmet Visor Variant - Blue Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_blue_visor"
	icon_state = "h_innie_helmet_obj_blue_visor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/green
	name = "LV28H Armored Helmet - Green Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_green"
	icon_state = "h_innie_helmet_obj_green"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/vgreen
	name = "LV28H Armored Helmet Visor Variant - Green Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_green_visor"
	icon_state = "h_innie_helmet_obj_green_visor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/black
	name = "LV28H Armored Helmet - Black Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_black"
	icon_state = "h_innie_helmet_obj_black"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/vblack
	name = "LV28H Armored Helmet Visor Variant - Black Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_black_visor"
	icon_state = "h_innie_helmet_obj_black_visor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/white
	name = "LV28H Armored Helmet - White Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_white"
	icon_state = "h_innie_helmet_obj_white"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/clothing/head/helmet/heavyurf/vwhite
	name = "LV28H Armored Helmet Visor Variant - White Camo"
	desc = "The LV28H an armored helmet composed of materials salvaged from a wide array of UNSC equipment for a heavy plated re-design of the CH252 Helmet crafted by X-52 for the new armor series being rolled out from Eridanus Secundus"
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_helmet_white_visor"
	icon_state = "h_innie_helmet_obj_white_visor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor_thickness = 15
	armor = list(melee = 45, bullet = 35, laser = 40,energy = 25, bomb = 25, bio = 0, rad = 0)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4

	integrated_hud = /obj/item/clothing/glasses/hud/tactical


/obj/item/clothing/shoes/lighturfboot/brown
	name = "VZG4L Armored Boots - Brown Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots modified with less plating for light movement."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_foot_brown"
	icon_state = "l_innie_foot_obj_brown"
	force = 2
	armor = list(melee = 20, bullet = 20, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/lighturfboot/blue
	name = "VZG4L Armored Boots - Blue Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots modified with less plating for light movement."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_foot_blue"
	icon_state = "l_innie_foot_obj_blue"
	force = 2
	armor = list(melee = 20, bullet = 20, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/lighturfboot/green
	name = "VZG4L Armored Boots - Green Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots modified with less plating for light movement."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_foot_green"
	icon_state = "l_innie_foot_obj_green"
	force = 2
	armor = list(melee = 20, bullet = 20, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/lighturfboot/black
	name = "VZG4L Armored Boots - Black Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots modified with less plating for light movement."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_foot_black"
	icon_state = "l_innie_foot_obj_black"
	force = 2
	armor = list(melee = 20, bullet = 20, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/lighturfboot/white
	name = "VZG4L Armored Boots - White Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots modified with less plating for light movement."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_foot_white"
	icon_state = "l_innie_foot_obj_white"
	force = 2
	armor = list(melee = 20, bullet = 20, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/mediumurfboot/blue
	name = "VZG4D Armored Boots - Blue Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_foot_blue"
	icon_state = "m_innie_foot_obj_blue"
	force = 4
	armor = list(melee = 25, bullet = 30, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/mediumurfboot/brown
	name = "VZG4D Armored Boots - Brown Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_foot_brown"
	icon_state = "m_innie_foot_obj_brown"
	force = 4
	armor = list(melee = 25, bullet = 30, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/mediumurfboot/green
	name = "VZG4D Armored Boots - Green Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_foot_green"
	icon_state = "m_innie_foot_obj_green"
	force = 4
	armor = list(melee = 25, bullet = 30, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/mediumurfboot/black
	name = "VZG4D Armored Boots - Black Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_foot_black"
	icon_state = "m_innie_foot_obj_black"
	force = 4
	armor = list(melee = 25, bullet = 30, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/shoes/mediumurfboot/white
	name = "VZG4D Armored Boots - White Camo"
	desc = "An older standard issue combat boots model of the VZG7 Armored Boots."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_foot_white"
	icon_state = "m_innie_foot_obj_white"
	force = 4
	armor = list(melee = 25, bullet = 30, laser = 5, energy = 20, bomb = 15, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE

/obj/item/clothing/suit/storage/lighturfarmor/
	name = "M22L Body Armor"
	desc = "The M22L Body Armor is composed of materials salvaged from a wide array of UNSC equipment for a lightweight design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_chest_blue"
	icon_state = "l_innie_chest_obj_blue"
	blood_overlay_type = "l_innie_chest_blue"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 25, bullet = 30, laser = 30, energy = 25, bomb = 25, bio = 0, rad = 0)
	var/slots = 2
	var/max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 10
	slowdown_general = -0.5
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/lighturfarmor/blue
	name = "M22L Body Armor - Blue Camo"
	desc = "The M22L Body Armor is composed of materials salvaged from a wide array of UNSC equipment for a lightweight design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_chest_blue"
	icon_state = "l_innie_chest_obj_blue"
	blood_overlay_type = "l_innie_chest_blue"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 25, bullet = 30, laser = 30, energy = 25, bomb = 25, bio = 0, rad = 0)
	slots = 2
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 10
	slowdown_general = -0.5
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/lighturfarmor/brown
	name = "M22L Body Armor - Brown Camo"
	desc = "The M22L Body Armor is composed of materials salvaged from a wide array of UNSC equipment for a lightweight design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_chest_brown"
	icon_state = "l_innie_chest_obj_brown"
	blood_overlay_type = "l_innie_chest_brown"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 25, bullet = 30, laser = 30, energy = 25, bomb = 25, bio = 0, rad = 0)
	slots = 2
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 10
	slowdown_general = -0.5
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/lighturfarmor/green
	name = "M22L Body Armor - Green Camo"
	desc = "The M22L Body Armor is composed of materials salvaged from a wide array of UNSC equipment for a lightweight design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_chest_green"
	icon_state = "l_innie_chest_obj_green"
	blood_overlay_type = "l_innie_chest_green"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 25, bullet = 30, laser = 30, energy = 25, bomb = 25, bio = 0, rad = 0)
	slots = 2
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 10
	slowdown_general = -0.5
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/lighturfarmor/black
	name = "M22L Body Armor - Black Camo"
	desc = "The M22L Body Armor is composed of materials salvaged from a wide array of UNSC equipment for a lightweight design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_chest_black"
	icon_state = "l_innie_chest_obj_black"
	blood_overlay_type = "l_innie_chest_black"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 25, bullet = 30, laser = 30, energy = 25, bomb = 25, bio = 0, rad = 0)
	slots = 2
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 10
	slowdown_general = -0.5
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/lighturfarmor/white
	name = "M22L Body Armor - White Camo"
	desc = "The M22L Body Armor is composed of materials salvaged from a wide array of UNSC equipment for a lightweight design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "l_innie_chest_white"
	icon_state = "l_innie_chest_obj_white"
	blood_overlay_type = "l_innie_chest_white"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 25, bullet = 30, laser = 30, energy = 25, bomb = 25, bio = 0, rad = 0)
	slots = 6
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 10
	slowdown_general = -0.5
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/mediumurfarmor/
	name = "M22D Body Armor"
	desc = "The M22D Body Armor is composed of materials salvaged from a wide array of UNSC equipment as an standard design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_chest_blue"
	icon_state = "m_innie_chest_obj_blue"
	blood_overlay_type = "m_innie_chest_blue"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 45, bullet = 40, laser = 35, energy = 30, bomb = 30, bio = 0, rad = 0)
	var/slots = 4
	var/max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 15
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip


/obj/item/clothing/suit/storage/mediumurfarmor/blue
	name = "M22D Body Armor - Blue Camo"
	desc = "The M22D Body Armor is composed of materials salvaged from a wide array of UNSC equipment as an standard design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_chest_blue"
	icon_state = "m_innie_chest_obj_blue"
	blood_overlay_type = "m_innie_chest_blue"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 45, bullet = 40, laser = 35, energy = 30, bomb = 30, bio = 0, rad = 0)
	slots = 4
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 15
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/mediumurfarmor/brown
	name = "M22D Body Armor - Brown Camo"
	desc = "The M22D Body Armor is composed of materials salvaged from a wide array of UNSC equipment as an standard design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_chest_brown"
	icon_state = "m_innie_chest_obj_brown"
	blood_overlay_type = "m_innie_chest_brown"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 45, bullet = 40, laser = 35, energy = 30, bomb = 30, bio = 0, rad = 0)
	slots = 4
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 15
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/mediumurfarmor/green
	name = "M22D Body Armor - Green Camo"
	desc = "The M22D Body Armor is composed of materials salvaged from a wide array of UNSC equipment as an standard design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_chest_green"
	icon_state = "m_innie_chest_obj_green"
	blood_overlay_type = "m_innie_chest_green"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 45, bullet = 40, laser = 35, energy = 30, bomb = 30, bio = 0, rad = 0)
	slots = 4
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 15
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/mediumurfarmor/black
	name = "M22D Body Armor - Black Camo"
	desc = "The M22D Body Armor is composed of materials salvaged from a wide array of UNSC equipment as an standard design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_chest_black"
	icon_state = "m_innie_chest_obj_black"
	blood_overlay_type = "m_innie_chest_black"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 45, bullet = 40, laser = 35, energy = 30, bomb = 30, bio = 0, rad = 0)
	slots = 4
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 15
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/mediumurfarmor/white
	name = "M22D Body Armor - White Camo"
	desc = "The M22D Body Armor is composed of materials salvaged from a wide array of UNSC equipment as an standard design based off the M52B Body Armor crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "m_innie_chest_white"
	icon_state = "m_innie_chest_obj_white"
	blood_overlay_type = "m_innie_chest_white"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 45, bullet = 40, laser = 35, energy = 30, bomb = 30, bio = 0, rad = 0)
	slots = 4
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 15
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/heavyurfarmor/blue
	name = "M22H Body Armor - Blue Camo"
	desc = "The M22H Body Armor is composed of materials salvaged from a wide array of UNSC equipment based off the M52B Body Armor and re-designed with more plating with overall better defense but lacking in movement crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_chest_blue"
	icon_state = "h_innie_chest_obj_blue"
	blood_overlay_type = "h_innie_chest_blue"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 55, bullet = 50, laser = 35, energy = 40, bomb = 40, bio = 0, rad = 0)
	slots = 2
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 20
	slowdown_general = 0.5
	siemens_coefficient = 0.3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/heavyurfarmor/
	name = "M22H Body Armor"
	desc = "The M22H Body Armor is composed of materials salvaged from a wide array of UNSC equipment based off the M52B Body Armor and re-designed with more plating with overall better defense but lacking in movement crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_chest_brown"
	icon_state = "h_innie_chest_obj_brown"
	blood_overlay_type = "h_innie_chest_brown"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 55, bullet = 50, laser = 35, energy = 40, bomb = 40, bio = 0, rad = 0)
	var/slots = 2
	var/max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 20
	slowdown_general = 0.5
	siemens_coefficient = 0.3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/heavyurfarmor/brown
	name = "M22H Body Armor - Brown Camo"
	desc = "The M22H Body Armor is composed of materials salvaged from a wide array of UNSC equipment based off the M52B Body Armor and re-designed with more plating with overall better defense but lacking in movement crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_chest_brown"
	icon_state = "h_innie_chest_obj_brown"
	blood_overlay_type = "h_innie_chest_brown"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 55, bullet = 50, laser = 35, energy = 40, bomb = 40, bio = 0, rad = 0)
	slots = 2
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 20
	slowdown_general = 0.5
	siemens_coefficient = 0.3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/heavyurfarmor/green
	name = "M22H Body Armor - Green Camo"
	desc = "The M22H Body Armor is composed of materials salvaged from a wide array of UNSC equipment based off the M52B Body Armor and re-designed with more plating with overall better defense but lacking in movement crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_chest_green"
	icon_state = "h_innie_chest_obj_green"
	blood_overlay_type = "h_innie_chest_green"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 55, bullet = 50, laser = 35, energy = 40, bomb = 40, bio = 0, rad = 0)
	slots = 2
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 20
	slowdown_general = 0.5
	siemens_coefficient = 0.3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/heavyurfarmor/black
	name = "M22H Body Armor - Black Camo"
	desc = "The M22H Body Armor is composed of materials salvaged from a wide array of UNSC equipment based off the M52B Body Armor and re-designed with more plating with overall better defense but lacking in movement crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_chest_black"
	icon_state = "h_innie_chest_obj_black"
	blood_overlay_type = "h_innie_chest_black"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 55, bullet = 50, laser = 35, energy = 40, bomb = 40, bio = 0, rad = 0)
	slots = 2
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 20
	slowdown_general = 0.5
	siemens_coefficient = 0.3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/storage/heavyurfarmor/white
	name = "M22H Body Armor - White Camo"
	desc = "The M22H Body Armor is composed of materials salvaged from a wide array of UNSC equipment based off the M52B Body Armor and re-designed with more plating with overall better defense but lacking in movement crafted by X-52 for the new armor series being rolled out from Eridanus Secundus."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	item_state = "h_innie_chest_white"
	icon_state = "h_innie_chest_obj_white"
	blood_overlay_type = "h_innie_chest_white"
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 55, bullet = 50, laser = 35, energy = 40, bomb = 40, bio = 0, rad = 0)
	slots = 2
	max_w_class = ITEM_SIZE_SMALL
	armor_thickness = 20
	slowdown_general = 0.5
	siemens_coefficient = 0.3
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter)
	starting_accessories = /obj/item/clothing/accessory/holster/hip

/obj/item/clothing/suit/armor/innie
	name = "Salvaged Armor"
	desc = "A worn set of armor composed of materials usually found in UNSC equipment, modified for superior bullet resistance."
	icon = INNIE_OVERRIDE
	icon_state = "armor1"
	icon_override = INNIE_OVERRIDE
	blood_overlay_type = "armor1"
	armor = list(melee = 45, bullet = 40, laser = 40, energy = 40, bomb = 35, bio = 20, rad = 15)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	item_flags = THICKMATERIAL
	flags_inv = HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | ARMS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE

/obj/item/clothing/mask/innie/shemagh
	name = "Shemagh"
	desc = "A headdress designed to keep out dust and protect agains the sun."
	icon = INNIE_OVERRIDE
	icon_override = INNIE_OVERRIDE
	icon_state = "shemagh"
	item_state = "shemagh"
	body_parts_covered = FACE
	item_flags = FLEXIBLEMATERIAL
	w_class = ITEM_SIZE_SMALL
	gas_transfer_coefficient = 0.90
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/suit/bomb_suit/security/colossus
	name = "Colossus Armor"
	desc = "When desperation reaches a breaking point humans will create things which are far scarier then they are practical. The colossus armor is a perfect example of this, with multiple layers of heavy impact plating fitted all across the exterior of the body suit, inside this, the wearer becomes a walking tank provided they are wielding enough firepower to emulate such a vehicle. Even without a hand held rocket launcher any foe will be hard pressed to pierce through the robust alloys protecting its user. Though, don't expect to be able to get around the battle field with any kind of speed, the key word of being a walking tank is 'walking'."
	icon_state = "colossusarmor"
	item_state = "colossusarmor"
	w_class = ITEM_SIZE_HUGE//bulky item
	item_flags = THICKMATERIAL
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	flags_inv = 29
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	siemens_coefficient = 0
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 20, rad = 15)
	armor_thickness= 30
	slowdown_general = 1
	siemens_coefficient = 0.7

/obj/item/clothing/head/bomb_hood/security/colossus
	name = "Colossus Helm"
	desc = "It's all well and good to have your body protected by a few inches of pure metal, but the colossus set is not complete without making sure your brain stays in the same condition as your body. The Colossus helm is also heavy, unwieldly and covered in multiple layers of heavy impact plating. But you can't really be a walking tank without it."
	icon_state = "colossushelmet"
	item_state = "colossushelmet"
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	w_class = ITEM_SIZE_HUGE//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.01
	slowdown_general = 1
	siemens_coefficient = 1.5
	armor_thickness = 20
	armor = list(melee = 50, bullet = 50, laser = 50, energy = 50, bomb = 50, bio = 20, rad = 15)
	gas_transfer_coefficient = 0.90
	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0

/obj/item/weapon/storage/briefcase/colossuscase
	name = "Thick Brief Case"
	desc = "This is a hardy metal bound briefcase which seems larger then your normal carry on. Inside of this enourmous case you can see there are two molded slots which seem perfectly fitted for both the Colossus Armor and Helmet in their entirety. You should silently thank whatever various diety you believe in that this case even exists in the first place."
	icon_state = "colossuscase"
	item_state = "colossuscase"
	flags = CONDUCT
	force = 10.0
	throw_speed = 1
	throw_range = 4
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_HUGE
	max_storage_space = 32
	can_hold = list(/obj/item/clothing/head/bomb_hood/security/colossus, /obj/item/clothing/suit/bomb_suit/security/colossus)
	slowdown_general = 0

/obj/item/clothing/suit/justice/zeal
	name = "Zeal Scout Suit"
	desc = "The Zeal suit was initially designed by URF research efforts to create a scout suit which their forces could utilize on a large scale across multiple systems. Geminus Colony scientists were contracted for the project so that suspicion wouldn't be drawn to the scattered URF bases near Sol due to technological requirements of the initial design. When it was finished the URF had on their hands an advanced uniform which also provided moderate defense for the wearer. The armor is carefully constructed with nano-kinetic motors built into the joints between the small segments of armor provide enhanced speed by continuously storing and releasing kinetic energy from the users natural movements. Though it is a powerful addition to the URF's compliment of existing equipment the rare minerals required to power and store this kind of energy meant that the URF was only initially capable of small scale production. In the end only the largest URF bases ended up recieving any number of these suits to help in their efforts of liberation. Because of its light weight the suit has no storage capacity to speak of, only being capable of holding a single weapon on its magnetic harness. Due to the nature of the armor's abilities excess weight taken on by the user can lead to overtaxing the motors and a loss of speed very quickly."
	w_class = ITEM_SIZE_LARGE
	icon_state = "zealarmor"
	item_state = "zealarmor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|HANDS|LEGS|FEET
	flags_inv = 29|HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT
	allowed = list(/obj/item/weapon/gun)
	slowdown_general = -3
	armor_thickness = 15 //Should be able to take 5-6 bullets before shattering.
	siemens_coefficient = 0.5
	armor = list(melee = 25, bullet = 30, laser = 20, energy = 20, bomb = 20, bio = 10, rad = 15)

/obj/item/clothing/suit/justice/zeal/New()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/head/helmet/zeal
	name = "Zeal Scout Suit Helmet"
	desc = "The Zeal suit was initially designed by URF research efforts to create a scout suit which their forces could utilize on a large scale across multiple systems. Geminus Colony scientists were contracted for the project so that suspicion wouldn't be drawn to the scattered URF bases near Sol due to technological requirements of the initial design."
	icon_state = "zealhelmet"
	item_state = "zealhelmet"
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	w_class = ITEM_SIZE_LARGE//bulky item
	siemens_coefficient = 0.5
	armor_thickness = 15
	armor = list(melee = 25, bullet = 30, laser = 20, energy = 20, bomb = 20, bio = 10, rad = 15)
	gas_transfer_coefficient = 0.90

	integrated_hud = /obj/item/clothing/glasses/hud/tactical


#undef INNIE_OVERRIDE