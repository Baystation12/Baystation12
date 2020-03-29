/decl/hierarchy/outfit/huragok_cov
	name = "Huragok"

/decl/hierarchy/outfit/huragok_cov/equip(mob/living/carbon/human/H, var/rank, var/assignment)
	. = ..()
	var/turf/h_loc = H.loc
	var/mob/living/silicon/robot/huragok/huragok = new(h_loc)
	huragok.faction = "Covenant"
	huragok.ckey = H.ckey
	huragok.Login()
	qdel(H)
	return huragok

/decl/hierarchy/outfit/kigyarcorvette
	name = "Kig-Yar Corvette Crew"

	l_ear = /obj/item/device/radio/headset/covenant
	uniform = /obj/item/clothing/under/kigyar
	suit = /obj/item/clothing/suit/armor/kigyar
	head = /obj/item/clothing/head/helmet/kigyar
	gloves = /obj/item/clothing/gloves/shield_gauntlet/kigyar
	l_hand = /obj/item/weapon/melee/blamite/dagger

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

/obj/item/weapon/paper/heresy_waiver
	name = "Authorisation Document"
	info = "\
COVENANT HEGEMONY\n\
\n\
\n\
Standard Supraluminal Communication Form\n\
\n\
\n\
Use of supraluminal communication arrays is only to be performed by Obedientiaries or officers of similar position.\n\
\n\
--------------------------------------------------------------------------------\n\
\n\
--------------------------------------------------------------------------------\n\
\n\
Subject-Trading Permission: Heresy Waiver\n\
\n\
Transmission-For the purpose of resource acquisition and organisation infiltration, the kig-yar shipmistress commanding the kig-yar raider vessel is to be left to their own devices. Any minor or major heresy committed towards the previously stated purpose is to be waived, and their operations are not to be interfered with unless requested or the kig-yar raider is believed to be under fear of potential capture and destruction. Sangheili/Jiralhanae officers in the sector still hold operational command and may retask the kig-yar raider's crew as they see fit, however, they are expected to use this only in times of extreme danger to other sector operations, as the kig-yar raider's mission has been deemed important to the assigning Prophet \[Prophet Name Classified\].\n\
\n\
\n\
--------------------------------------------------------------------------------\n\
\n\
--------------------------------------------------------------------------------"

/decl/hierarchy/outfit/kigyarcorvette/captain
	name = "Kig-Yar Ship-captain"

	l_ear = /obj/item/device/radio/headset/covenant
	uniform = /obj/item/clothing/under/kigyar
	suit = /obj/item/clothing/suit/armor/kigyar
	suit_store = /obj/item/weapon/gun/energy/plasmapistol
	back = /obj/item/weapon/gun/projectile/type51carbine
	l_pocket = /obj/item/weapon/paper/heresy_waiver
	r_pocket = /obj/item/ammo_magazine/type51mag
	belt = /obj/item/ammo_magazine/type51mag
	gloves = /obj/item/clothing/gloves/shield_gauntlet/kigyar
	head = /obj/item/clothing/head/helmet/kigyar
	l_hand = /obj/item/weapon/melee/blamite/cutlass

	flags = 0

	hierarchy_type = /decl/hierarchy/outfit/job

