/decl/hierarchy/outfit/job/UNSC_ship/CO
	name = "Commanding Officer"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	belt = /obj/item/weapon/gun/projectile/m6d_magnum/CO
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/officer/o6)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/EXO
	name = "Executive Officer"

	l_ear = /obj/item/device/radio/headset/unsc/officer
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/officer/o5)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/cag
	name = "Commander Air Group"

	l_ear = /obj/item/device/radio/headset/unsc/officer
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/BO
	name = "Bridge Officer"

	l_ear = /obj/item/device/radio/headset/unsc/officer
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/officer)

	flags = 0

/obj/item/weapon/gun/projectile/m6d_magnum/CO
	name = "CO's Magnum"
	desc = "You'll have to find ammo as you go."

/obj/item/weapon/gun/projectile/m6d_magnum/CO/New()
	. = ..()
	ammo_magazine = null