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
	body_parts_covered = HEAD|FACE
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	flash_protection = FLASH_PROTECTION_MODERATE
	cold_protection = HEAD
	heat_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	armor = list(melee = 60, bullet = 35, laser = 25,energy = 25, bomb = 20, bio = 100, rad = 25)
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0
	var/visr_on = 1
	armor_thickness = 20


/obj/item/clothing/suit/armor/special/odst
	name = "ODST Armour"
	desc = "Lightweight, durable armour issued to Orbital Drop Shock Troopers for increased survivability in the field."
	icon = ITEM_INHAND
	icon_state = "Odst Armour"
	icon_override = ODST_OVERRIDE
	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 40, bio = 100, rad = 25)
	//specials = list(/datum/armourspecials/internal_air_tank/human) This line is disabled untill a dev can fix the internals code for it.
	item_flags = STOPPRESSUREDAMAGE|THICKMATERIAL
	body_parts_covered = UPPER_TORSO | LOWER_TORSO | ARMS | LEGS
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)
	armor_thickness = 20


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





//DONATOR GEAR

/obj/item/clothing/head/helmet/odst/donator/liam_gallagher
	name = "ODST EOD Helmet"

	item_state = "osama-helmet_worn"
	icon_state = "osama-helmet_obj"
	item_state_novisr = "osama-helmet-open_worn"
	icon_state_novisr = "osama-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/liam_gallagher
	name = "ODST EOD Suit"

	icon_state = "osama-armor_worn"

/obj/item/clothing/head/helmet/odst/donator/ragnarok
	name = "Bishop's ODST Helmet"

	item_state = "ragnarok-helmet_worn"
	icon_state = "ragnarok-helmet_obj"
	item_state_novisr = "ragnarok-helmet-open_worn"
	icon_state_novisr = "ragnarok-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/ragnarok
	name = "Bishop's ODST Armour"

	icon_state = "ragnarok-armor_worn"

/obj/item/clothing/head/helmet/odst/donator/winterume
	name = "Rose's Recon Helmet"

	item_state = "amy-helmet_worn"
	icon_state = "amy-helmet_obj"
	item_state_novisr = "amy-helmet-open_worn"
	icon_state_novisr = "amy-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/winterume
	name = "Rose's Recon Armor"

	icon_state = "amy-armor_worn"

/obj/item/clothing/head/helmet/odst/donator/eonoc
	name = "Barnabus's ODST Helmet"

	item_state = "eonoc-helmet_worn"
	icon_state = "eonoc-helmet_obj"
	item_state_novisr = "eonoc-helmet-open_worn"
	icon_state_novisr = "eonoc-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/eonoc
	name = "Barnabus's ODST Armor"

	icon_state = "eonoc-armor_worn"

/obj/item/clothing/head/helmet/odst/donator/flaksim
	name = "Kashada's ODST Helmet"

	item_state = "Odst Helmet Flaksim"
	icon_state = "Odst Helmet Flaksim"
	item_state_novisr = "Odst Helmet Flaksim Transparent"
	icon_state_novisr = "Odst Helmet Flaksim Transparent"

/obj/item/clothing/suit/armor/special/odst/donator/flaksim
	name = "Kashada's ODST Armour"

	icon_state = "Odst Armor Flaksim"

/obj/item/clothing/head/helmet/odst/donator/mann
	name = "Mann's ODST Helmet"

	item_state = "Odst Helmet Mann"
	icon_state = "Odst Helmet Mann"
	item_state_novisr = "Odst Helmet Mann"
	icon_state_novisr = "Odst Helmet Mann"

/obj/item/clothing/suit/armor/special/odst/donator/mann
	name = "Mann's ODST Armour"

	icon_state = "Odst Armor Mann"

/obj/item/clothing/head/helmet/odst/donator/moerk
	name = "Moerk's ODST Helmet"

	item_state = "Odst Helmet Moerk"
	icon_state = "Odst Helmet Moerk"
	item_state_novisr = "Odst Helmet Moerk"
	icon_state_novisr = "Odst Helmet Moerk"

/obj/item/clothing/suit/armor/special/odst/donator/moerk
	name = "Moerk's Customized ODST Armour"

	icon_state = "Odst Armor Moerk"

/obj/item/clothing/head/helmet/odst/donator/spartan
	name = "Spartan's ODST Helmet"

	item_state = "Odst Helmet Spartan"
	icon_state = "Odst Helmet Spartan"
	item_state_novisr = "Odst Helmet Spartan Transparent"
	icon_state_novisr = "Odst Helmet Spartan Transparent"

/obj/item/clothing/suit/armor/special/odst/donator/spartan
	name = "Customized ODST CQB Armour"

	icon_state = "Odst Armor Spartan"

/obj/item/clothing/head/helmet/odst/donator/caelumz
	name = "Customized ODST Sniper Helmet"

	item_state = "Odst Helmet Caelum"
	icon_state = "Odst Helmet Caelum"
	item_state_novisr = "Odst Helmet Caelum Transparent"
	icon_state_novisr = "Odst Helmet Caelum Transparent"

/obj/item/clothing/suit/armor/special/odst/donator/caelumz
	name = "Customized ODST Sniper Armour"

	icon_state = "Odst Armor Caelum"

/obj/item/clothing/head/helmet/odst/donator/maxattacker
	name = "Customized ODST Helmet"

	item_state = "Odst Helmet Maxattacker"
	icon_state = "Odst Helmet Maxattacker"
	item_state_novisr = "Odst Helmet Maxattacker Transparent"
	icon_state_novisr = "Odst Helmet Maxattacker Transparent"

/obj/item/clothing/suit/armor/special/odst/donator/maxattacker
	name = "Customized ODST Recon Armour"

	icon_state = "Odst Armor Maxattacker"

/obj/item/clothing/head/helmet/odst/donator/wehraboo
	name = "SPI Helmet Mk I"
	item_state = "wehraboo-helmet_worn"
	icon_state = "wehraboo-helmet_obj"
	item_state_novisr = "wehraboo-helmet_worn"
	icon_state_novisr = "wehraboo-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/wehraboo
	name = "SPI Armour Mk I"
	item_state = "wehraboo-armor_worn"
	icon_state = "wehraboo-armor_obj"

/obj/item/clothing/head/helmet/odst/donator/kozi
	name = "Kozi's Hassar Helmet"
	item_state = "kozi-helmet_worn"
	icon_state = "kozi-helmet_obj"
	item_state_novisr = "kozi-helmet_worn"
	icon_state_novisr = "kozi-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/kozi
	name = "Kozi's Hassar Armor"
	icon_state = "kozi-armor_obj"
	item_state = "kozi-armor_worn"
//Kozi's sword

/obj/item/weapon/material/machete/kozi
	name = "Hassar Sabre"
	icon_state = "kozi-sabre_obj"
	item_state = "kozi-sabre"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_left.dmi',
		slot_r_hand_str = 'code/modules/halo/weapons/icons/Weapon_Inhands_right.dmi',
		)

obj/item/clothing/head/helmet/odst/donator/gulag
	name = "Murmillo Helmet"
	item_state = "gulag-helmet_worn"
	icon_state = "gulag-helmet_obj"
	item_state_novisr = "gulag-helmet_worn"
	icon_state_novisr = "gulag-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/gulag
	name = "Murmillo Armour"
	icon_state = "gulag-armor_obj"
	item_state = "gulag-armor_worn"

obj/item/clothing/head/helmet/odst/donator/maxattackeralt
	name = "ODST 'Grasshopper' Helmet"
	item_state = "maxattackeralt-helmet_worn"
	icon_state = "maxattackeralt-helmet_obj"
	item_state_novisr = "maxattackeralt-helmet_worn"
	icon_state_novisr = "maxattackeralt-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/maxattackeralt
	name = "ODST 'Thorn' Armour"
	icon_state = "maxattackeralt-armor_obj"
	item_state = "maxattackeralt-armor_worn"

obj/item/clothing/head/helmet/odst/donator/pinstripe
	name = "Pinstripe's ODST Helmet"
	item_state = "pinstripe-helmet_worn"
	icon_state = "pinstripe-helmet_obj"
	item_state_novisr = "pinstripe-helmet_worn"
	icon_state_novisr = "pinstripe-helmet_obj"

/obj/item/clothing/suit/armor/special/odst/donator/pinstripe
	name = "Pinstripe's ODST Armour"
	icon_state = "pinstripe-armor_obj"
	item_state = "pinstripe-armor_worn"
//END DONATOR GEAR

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

/obj/item/weapon/storage/backpack/odst/donator/flaksim
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Kashada's Backpack"
	item_state = "Odst Flaksim Backpack"
	icon_state = "Odst Flaksim Backpack"

/obj/item/weapon/storage/backpack/odst/donator/spartan
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Spartan's Backpack"
	item_state = "Odst Spartan Backpack"
	icon_state = "Odst Spartan Backpack"

/obj/item/weapon/storage/backpack/odst/donator/general
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Customized's Backpack"
	item_state = "Odst customized Backpack"
	icon_state = "Odst customized Backpack"

/obj/item/weapon/storage/backpack/odst/kozi
	icon = ITEM_INHAND
	icon_override = ODST_OVERRIDE
	name = "Kozi's Hassar Backpack"
	item_state = "kozi-backpack_worn"
	icon_state = "kozi-backpack_obj"

//END DONATOR GEAR
#undef ODST_OVERRIDE
#undef ITEM_INHAND
