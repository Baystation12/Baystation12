
/decl/hierarchy/outfit/job/UNSC_ship/marine_co
	name = "Marine Commanding Officer"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	l_hand = /obj/item/squad_manager
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/marine_xo
	name = "Marine Executive Officer"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	l_hand = /obj/item/squad_manager
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/marine_sl
	name = "Marine Squad Leader"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	l_hand = /obj/item/squad_manager
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	gloves = /obj/item/clothing/gloves/thick/combat

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/marine
	name = "Marine"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	gloves = /obj/item/clothing/gloves/thick/combat

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/marine/proc/equip_special(mob/living/carbon/human/H)
	if(prob(25))
		H.equip_to_slot_or_del(/obj/item/clothing/mask/marine)

/decl/hierarchy/outfit/job/UNSC_ship/odst
	name = "ODST Rifleman"
	l_ear = /obj/item/device/radio/headset/unsc/marine
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	shoes = /obj/item/clothing/shoes/marine
	pda_slot = null
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	id_type = /obj/item/weapon/card/id/silver

	flags = 0
e