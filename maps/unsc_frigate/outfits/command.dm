
/decl/hierarchy/outfit/job/UNSC_ship/CO
	name = "Commanding Officer"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown

	flags = 0

/obj/item/weapon/gun/projectile/m6d_magnum/CO
	name = "CO's Magnum"
	desc = "You'll have to find ammo as you go."

/decl/hierarchy/outfit/job/UNSC_ship/CO/equip_base(mob/living/carbon/human/H)
	. = ..()
	var/obj/item/weapon/gun/projectile/G = new /obj/item/weapon/gun/projectile/m6d_magnum/CO
	G.ammo_magazine = null
	H.equip_to_slot_or_del(G,slot_belt)

/decl/hierarchy/outfit/job/UNSC_ship/EXO
	name = "Executive Officer"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/cag
	name = "Commander Air Group"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/BO
	name = "Bridge Officer"

	l_ear = /obj/item/device/radio/headset/unsc/commander
	uniform = /obj/item/clothing/under/unsc/command
	shoes = /obj/item/clothing/shoes/brown

	flags = 0
