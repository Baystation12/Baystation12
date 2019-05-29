
/obj/item/clothing/suit/armor/vest/police
	name = "ballistic padding"
	desc = "GCPD shoulder and torso padding designed for bullet resistance."
	icon_state = "ertarmor_cmd"
	item_state = "armor"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 40, bullet = 35, laser = 15, energy = 15, bomb = 40, bio = 0, rad = 0)

/obj/item/clothing/under/police
	name = "police uniform"
	desc = "A black uniform worn by the GCPD."
	icon_state = "blackutility_com"
	worn_state = "blackutility_com"
	starting_accessories = list(/obj/item/clothing/accessory/department/medical, /obj/item/clothing/accessory/holster/thigh)
	armor = list(melee = 20, bullet = 5, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/under/marshall
	name = "Marshall's uniform"
	desc = "A black uniform worn by the Emsville Marshalls."
	icon_state = "blackutility_com"
	worn_state = "blackutility_com"
	starting_accessories = list(/obj/item/clothing/accessory/holster/thigh)
	armor = list(melee = 20, bullet = 5, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/decl/hierarchy/outfit/job/cop
	name = "GCPD Chief of Police"

	head = /obj/item/clothing/head/soft/sec/corp
	uniform = /obj/item/clothing/under/police
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	shoes = /obj/item/clothing/shoes/dutyboots
	pda_slot = null
	l_pocket = /obj/item/clothing/accessory/badge/police
	l_ear = /obj/item/device/radio/headset/police
	id_type = /obj/item/weapon/card/id/security/head
	suit = /obj/item/clothing/suit/armor/hos

	flags = 0