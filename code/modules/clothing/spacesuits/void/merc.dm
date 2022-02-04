//Syndicate rig
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndie"
	item_state = "syndie_helm"
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	siemens_coefficient = 0.3
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC, SPECIES_VOX, SPECIES_SHELL)
	sprite_sheets = list(
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_skrell.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_helmet_unathi.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/onmob_head_vox.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'icons/obj/clothing/species/unathi/obj_head_unathi.dmi',
		SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_head_skrell.dmi',
		SPECIES_VOX = 'icons/obj/clothing/species/vox/obj_head_vox.dmi'
		)
	camera = /obj/machinery/camera/network/mercenary
	light_overlay = "explorer_light"

/obj/item/clothing/suit/space/void/merc
	icon_state = "rig-syndie"
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	item_state_slots = list(
		slot_l_hand_str = "syndie_voidsuit",
		slot_r_hand_str = "syndie_voidsuit",
	)
	w_class = ITEM_SIZE_LARGE //normally voidsuits are bulky but the merc voidsuit is 'advanced' or something
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_RESISTANT,
		laser = ARMOR_LASER_MAJOR,
		energy = ARMOR_ENERGY_MINOR,
		bomb = ARMOR_BOMB_PADDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_SMALL
		)
	allowed = list(/obj/item/device/flashlight,/obj/item/tank,/obj/item/device/suit_cooling_unit,/obj/item/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/melee/energy/sword,/obj/item/handcuffs)
	siemens_coefficient = 0.3
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_IPC, SPECIES_VOX, SPECIES_SHELL)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_suit_unathi.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/onmob_suit_vox.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'icons/obj/clothing/species/unathi/obj_suit_unathi.dmi',
		SPECIES_SKRELL = 'icons/obj/clothing/species/skrell/obj_suit_skrell.dmi',
		SPECIES_VOX = 'icons/obj/clothing/species/vox/obj_suit_vox.dmi'
		)

/obj/item/clothing/suit/space/void/merc/Initialize()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/space/void/merc/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/merc
	boots = /obj/item/clothing/shoes/magboots
	tank = /obj/item/tank/oxygen
