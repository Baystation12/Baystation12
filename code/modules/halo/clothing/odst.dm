#define ODST_OVERRIDE 'code/modules/halo/clothing/odst.dmi'
#define ITEM_INHAND 'code/modules/halo/clothing/odst_items.dmi'

/obj/item/clothing/under/unsc/odst_jumpsuit
	name = "ODST jumpsuit"
	desc = "standard issue ODST jumpsuits, padded to provide a slight edge."
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	item_state = "Jumpsuit"
	icon_state = "Jumpsuit"
	worn_state = "ODST Jumpsuit"
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

/obj/item/clothing/head/helmet/odst
	name = "ODST Rifleman Helmet"
	desc = "Standard issue short-EVA capable helmet issued to ODST forces"
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	item_state = "Odst Helmet"
	icon_state = "Helmet ODST"
	var/icon_state_novisr = "Helmet ODST Transparent"
	var/item_state_novisr = "Odst Helmet Transparent"
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL|AIRTIGHT
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD | FACE
	heat_protection = HEAD | FACE
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 55, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 25, rad = 25)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	unacidable = 1
	on = 0
	var/visr_on = 1
	armor_thickness = 20

	integrated_hud = /obj/item/clothing/glasses/hud/tactical/odst_hud

/obj/item/clothing/suit/armor/special/odst
	name = "ODST Armour"
	desc = "Lightweight, durable armour issued to Orbital Drop Shock Troopers for increased survivability in the field."
	icon = ITEM_INHAND
	icon_state = "Odst Armour"
	icon_override = ODST_OVERRIDE
	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 25, rad = 25)
	allowed = list(/obj/item/weapon/gun/energy,/obj/item/device/radio,/obj/item/weapon/reagent_containers/spray/pepper,/obj/item/weapon/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/handcuffs,/obj/item/weapon/gun/magnetic,/obj/item/weapon/tank)
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	unacidable = 1
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)


/obj/item/clothing/shoes/magboots/odst
	name = "ODST Magboots"
	desc = "Experimental magnetic boots, used to ensure the user is safely attached to any surfaces during extra-vehicular operations. They're large enough to be worn over other footwear."
	icon = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_override = 'code/modules/halo/clothing/urf_commando.dmi'
	icon_state = "magboots_obj0"
	icon_base = "magboots_obj"
	item_state = "magboots"
	can_hold_knife = 1
	force = 5
	stepsound = 'code/modules/halo/sounds/walk_sounds/marine_boots.ogg'

//Defines for armour subtypes//

/obj/effect/odst_armour_set
	var/obj/helmet = /obj/item/clothing/head/helmet/odst/rifleman
	var/obj/armour = /obj/item/clothing/suit/armor/special/odst

/obj/effect/odst_armour_set/New()
	.=..()
	new helmet(src.loc)
	new armour(src.loc)

/obj/effect/odst_armour_set/Initialize()
	.=..()
	return INITIALIZE_HINT_QDEL

/obj/effect/odst_armour_set/cqb
	helmet = /obj/item/clothing/head/helmet/odst/cqb
	armour = /obj/item/clothing/suit/armor/special/odst/cqb

/obj/item/clothing/head/helmet/odst/rifleman

/obj/item/clothing/head/helmet/odst/verb/Toggle_VISR()
	set category = "Helmet"
	set name = "Toggle VISR"
	visr_on = !visr_on
	if (visr_on)
		item_state = initial(item_state)
		icon_state = initial(icon_state)
	else
		icon_state = icon_state_novisr
		item_state = item_state_novisr
	update_icon()
	update_clothing_icon()
	. = ..()

/obj/item/clothing/suit/armor/special/odst/cqb
	name = "ODST CQB Armour"

	icon_state = "Odst Armour CQB"

/obj/item/clothing/head/helmet/odst/cqb
	name = "ODST CQB Helmet"
	item_state = "Odst Helmet CQB"
	icon_state = "Helmet CQB"
	item_state_novisr = "Odst Helmet CQB Transparent"
	icon_state_novisr = "Helmet CQB Transparent"

/obj/effect/odst_armour_set/sharpshooter
	helmet = /obj/item/clothing/head/helmet/odst/sharpshooter
	armour = /obj/item/clothing/suit/armor/special/odst/sharpshooter

/obj/item/clothing/suit/armor/special/odst/sharpshooter
	name = "ODST Sharpshooter Armour"

	icon_state = "Odst Armour Sharpshooter"

/obj/item/clothing/head/helmet/odst/sharpshooter
	name = "ODST Sharpshooter Helmet"

	item_state = "Odst Helmet Sharpshooter"
	icon_state = "Helmet Sharpshooter"
	item_state_novisr = "Odst Helmet Sharpshooter Transparent"
	icon_state_novisr = "Helmet Sharpshooter Transparent"

/obj/effect/odst_armour_set/medic
	helmet = /obj/item/clothing/head/helmet/odst/medic
	armour = /obj/item/clothing/suit/armor/special/odst/medic

/obj/item/clothing/suit/armor/special/odst/medic
	name = "ODST Medic Armour"

	icon_state = "Odst Armour Medic"

/obj/item/clothing/head/helmet/odst/medic
	name = "ODST Medic Helmet"

	item_state = "Odst Helmet Medic"
	icon_state = "Helmet Medic"
	item_state_novisr = "Odst Helmet Medic Transparent"
	icon_state_novisr = "Helmet Medic Transparent"

	integrated_hud = /obj/item/clothing/glasses/hud/tactical/odst_hud/medic

///obj/item/clothing/head/helmet/odst/medic/health/process_hud(var/mob/M)
//	process_med_hud(M, 1)

/obj/effect/odst_armour_set/engineer
	helmet = /obj/item/clothing/head/helmet/odst/engineer
	armour = /obj/item/clothing/suit/armor/special/odst/engineer

/obj/item/clothing/head/helmet/odst/engineer
	name = "ODST Engineer Helmet"
	flash_protection = FLASH_PROTECTION_MAJOR
	item_state = "Odst Helmet Engineer"
	icon_state = "Helmet Engineer"
	item_state_novisr = "Odst Helmet Engineer Transparent"
	icon_state_novisr = "Helmet Engineer Transparent"

/obj/item/clothing/suit/armor/special/odst/engineer
	name = "ODST Engineer Armour"

	icon_state = "Odst Armour Engineer"

/obj/effect/odst_armour_set/squadleader
	helmet = /obj/item/clothing/head/helmet/odst/squadleader
	armour = /obj/item/clothing/suit/armor/special/odst/squadleader

/obj/item/clothing/head/helmet/odst/squadleader
	name = "ODST Squad Leader Helmet"

	item_state = "Odst Helmet Squad Leader"
	icon_state = "Helmet Squad Leader"
	item_state_novisr = "Odst Helmet Squad Leader Transparent"
	icon_state_novisr = "Helmet Squad Leader Transparent"

/obj/item/clothing/suit/armor/special/odst/squadleader
	name = "ODST Squad Leader Armour"

	icon_state = "Odst Armor Squad Leader"


/obj/effect/random_ODST_set/New()
	.=..()
	var/obj/armour_set = pick(list(/obj/effect/odst_armour_set/medic,/obj/effect/odst_armour_set/sharpshooter,/obj/effect/odst_armour_set/cqb,/obj/effect/odst_armour_set,/obj/effect/odst_armour_set/engineer))
	new armour_set(src.loc)

/obj/effect/random_ODST_set/Initialize()
	.=..()
	return INITIALIZE_HINT_QDEL

/obj/item/clothing/accessory/storage/odst
	name = "Tactical Webbing"
	icon_state = "Tactical Webbing"

//BACKPACKS

/obj/item/weapon/storage/backpack/odst/regular
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack"
	item_state = "odst_b"
	icon_state = "odst_ba"


/obj/item/weapon/storage/backpack/odst/cqb
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack CQB"
	item_state = "odst_c"
	icon_state = "odst_ca"


/obj/item/weapon/storage/backpack/odst/medic
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack Medic"
	item_state = "odst_m"
	icon_state = "odst_ma"


/obj/item/weapon/storage/backpack/odst/sharpshooter
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack Sharpshooter"
	item_state = "odst_s"
	icon_state = "odst_sa"


/obj/item/weapon/storage/backpack/odst/engineer
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack Engineer"
	item_state = "odst_e"
	icon_state = "odst_ea"


/obj/item/weapon/storage/backpack/odst/squadlead
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Odst Backpack Squad Leader"
	item_state = "odst_sl"
	icon_state = "odst_sla"


//DONATOR GEAR

/obj/item/weapon/storage/backpack/odst/donator/general
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Customized's Backpack"
	item_state = "Odst customized Backpack"
	icon_state = "Odst customized Backpack"

//END DONATOR GEAR
#undef ODST_OVERRIDE
#undef ITEM_INHAND
