
/decl/hierarchy/outfit/job/UNSC_ship/marine_co
	name = "Marine Company Officer"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	l_hand = /obj/item/squad_manager
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	gloves = /obj/item/clothing/gloves/thick/unsc
	starting_accessories = list(/obj/item/clothing/accessory/rank/fleet/officer/o2)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/marine_xo
	name = "Marine Company Sergeant"

	l_ear = /obj/item/device/radio/headset/unsc/marine
	l_hand = /obj/item/squad_manager
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/marine_fatigues
	shoes = /obj/item/clothing/shoes/marine
	head = /obj/item/clothing/head/helmet/marine
	suit = /obj/item/clothing/suit/storage/marine
	belt = /obj/item/weapon/storage/belt/marine_ammo
	gloves = /obj/item/clothing/gloves/thick/unsc
	starting_accessories = list(/obj/item/clothing/accessory/rank/marine/enlisted/e7)

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
	gloves = /obj/item/clothing/gloves/thick/unsc
	starting_accessories = list(/obj/item/clothing/accessory/rank/marine/enlisted/e5)

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
	gloves = /obj/item/clothing/gloves/thick/unsc
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/marine/proc/equip_special(mob/living/carbon/human/H)
	if(prob(25))
		H.equip_to_slot_or_del(/obj/item/clothing/mask/marine)
	if(prob(25))
		H.equip_to_slot_or_del(/obj/item/clothing/head/helmet/marine/visor)

/decl/hierarchy/outfit/job/UNSC_ship/odst
	name = "ODST Rifleman"
	l_ear = /obj/item/device/radio/headset/unsc/odst
	glasses = /obj/item/clothing/glasses/hud/tactical
	uniform = /obj/item/clothing/under/unsc/odst_jumpsuit
	shoes = /obj/item/clothing/shoes/jungleboots
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	starting_accessories = list (/obj/item/clothing/accessory/rank/marine/enlisted/e4, /obj/item/clothing/accessory/holster/thigh)

	flags = 0

/decl/hierarchy/outfit/job/UNSC_ship/odsto
	name = "ONI Bridge Officer"
	l_ear = /obj/item/device/radio/headset/unsc/odsto
	uniform = /obj/item/clothing/under/utility
	shoes = /obj/item/clothing/shoes/dress
	belt = /obj/item/weapon/gun/projectile/m6c_magnum_s
	l_pocket = /obj/item/weapon/folder/envelope/nuke_instructions
	starting_accessories = list (/obj/item/clothing/accessory/rank/fleet/officer/o5, /obj/item/clothing/accessory/holster/thigh)

	flags = 0
