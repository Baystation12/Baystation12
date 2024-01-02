//Try to keep this limited. I don't want unique solgov or NT items in here, it should only be things that require the sierra map datums like access.

/obj/item/rig/hazard/guard
	name = "hazard hardsuit control module"

/obj/item/clothing/head/helmet/space/rig/hazard/guard
	camera = /obj/machinery/camera/network/research

/obj/item/rig/hazard/guard

	initial_modules = list(
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/energy/taser
		)

/obj/item/clothing/suit/space/void/sapper
	name = "\improper sapper voidsuit"
	desc = "A specially produced heavy suit for sapper units on space facilities. Usually, uses as emergency spacesuit."
	icon_state = "rig-secTG"
	item_state = "rig-secTG"
	icon = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_SHIELDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
	)
	flags_inv = HIDESHOES|HIDEJUMPSUIT|HIDEGLOVES
	siemens_coefficient = 0

/obj/item/clothing/suit/space/void/sapper/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 2

/obj/item/clothing/head/helmet/space/void/sapper
	name = "sapper voidsuit helmet"
	desc = "A specially produced heavy helmet for sapper units on space facilities."
	icon_state = "rig0-secTG"
	item_state = "rig0-secTG"
	item_icons = list(slot_head_str = 'maps/sierra/icons/mob/onmob/onmob_head.dmi')
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_SMALL,
		laser = ARMOR_LASER_SMALL,
		energy = ARMOR_ENERGY_RESISTANT,
		bomb = ARMOR_BOMB_SHIELDED,
		bio = ARMOR_BIO_SHIELDED,
		rad = ARMOR_RAD_MINOR
	)
	item_state_slots = list(
		slot_l_hand_str = "sec_helm",
		slot_r_hand_str = "sec_helm",
		)
	siemens_coefficient = 0
	light_overlay = "helmet_light_dual"
