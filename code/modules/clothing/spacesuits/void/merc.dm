//Syndicate rig
/obj/item/clothing/head/helmet/space/void/merc
	name = "blood-red voidsuit helmet"
	desc = "An advanced helmet designed for work in special operations. Property of Gorlex Marauders."
	icon_state = "rig0-syndie"
	item_state = "syndie_helm"
	armor = list(melee = 60, bullet = 50, laser = 50,energy = 15, bomb = 35, bio = 100, rad = 60)
	siemens_coefficient = 0.3
	species_restricted = list("Human", "Machine")
	camera = /obj/machinery/camera/network/mercenary
	light_overlay = "helmet_light_green" //todo: species-specific light overlays

/obj/item/clothing/suit/space/void/merc
	icon_state = "rig-syndie"
	name = "blood-red voidsuit"
	desc = "An advanced suit that protects against injuries during special operations. Property of Gorlex Marauders."
	item_state_slots = list(
		slot_l_hand_str = "syndie_voidsuit",
		slot_r_hand_str = "syndie_voidsuit",
	)
	w_class = ITEM_SIZE_LARGE //normally voidsuits are bulky but the merc voidsuit is 'advanced' or something
	armor = list(melee = 60, bullet = 50, laser = 50, energy = 15, bomb = 35, bio = 100, rad = 60)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs)
	siemens_coefficient = 0.3
	species_restricted = list("Human", "Skrell", "Machine")

/obj/item/clothing/suit/space/void/merc/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 1

/obj/item/clothing/suit/space/void/merc/prepared/New()
	..()
	helmet = new /obj/item/clothing/head/helmet/space/void/merc
	boots = new /obj/item/clothing/shoes/magboots