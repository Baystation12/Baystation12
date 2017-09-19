/*
 * Torch Medical
 */

/obj/structure/closet/secure_closet/CMO_torch
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmosecure1"
	icon_closed = "cmosecure"
	icon_locked = "cmosecure1"
	icon_opened = "cmosecureopen"
	icon_broken = "cmosecurebroken"
	icon_off = "cmosecureoff"

/obj/structure/closet/secure_closet/CMO_torch/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/shoes/white,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
		/obj/item/weapon/cartridge/cmo,
		/obj/item/clothing/gloves/latex,
		/obj/item/device/radio/headset/heads/cmo,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/reagent_containers/hypospray,
		/obj/item/clothing/mask/surgical,
		/obj/item/device/healthanalyzer,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/weapon/gun/energy/gun,
		/obj/item/clothing/accessory/holster/thigh,
		/obj/item/clothing/suit/storage/vest/solgov/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/weapon/clipboard,
		/obj/item/weapon/folder/white,
		/obj/item/device/holowarrant,
		/obj/item/weapon/storage/firstaid/adv,
		/obj/item/weapon/storage/box/armband/med,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/medic, /obj/item/weapon/storage/backpack/satchel_med)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/med, /obj/item/weapon/storage/backpack/messenger/med)),
		RANDOM_SCRUBS
	)

/obj/structure/closet/secure_closet/medical_torchsenior
	name = "physician's locker"
	req_access = list(access_senmed)
	icon_state = "securesenmed1"
	icon_closed = "securesenmed"
	icon_locked = "securesenmed1"
	icon_opened = "securesenmedopen"
	icon_broken = "securesenmedbroken"
	icon_off = "securesenmedoff"

/obj/structure/closet/secure_closet/medical_torchsenior/WillContain()
	return list(
		/obj/item/clothing/under/sterile,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/surgicalapron,
		/obj/item/clothing/shoes/white,
		/obj/item/weapon/cartridge/cmo,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/taperoll/medical,
		/obj/item/weapon/storage/belt/medical,
		/obj/item/clothing/mask/surgical,
		/obj/item/device/healthanalyzer,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/weapon/storage/firstaid/adv,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/medic, /obj/item/weapon/storage/backpack/satchel_med)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/med, /obj/item/weapon/storage/backpack/messenger/med)),
		new /datum/atom_creator/weighted(list(
					list(/obj/item/clothing/under/rank/medical/blue, /obj/item/clothing/head/surgery/blue),
					list(/obj/item/clothing/under/rank/medical/green, /obj/item/clothing/head/surgery/green),
					list(/obj/item/clothing/under/rank/medical/purple, /obj/item/clothing/head/surgery/purple),
					list(/obj/item/clothing/under/rank/medical/black, /obj/item/clothing/head/surgery/black),
					list(/obj/item/clothing/under/rank/medical/navyblue, /obj/item/clothing/head/surgery/navyblue)
				)) = 2
	)

/obj/structure/closet/secure_closet/medical_torch
	name = "corpsman's locker"
	req_access = list(access_medical_equip)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

/obj/structure/closet/secure_closet/medical_torch/WillContain()
	return list(
		/obj/item/clothing/under/sterile,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/shoes/white,
		/obj/item/weapon/cartridge/medical,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/taperoll/medical,
		/obj/item/weapon/storage/belt/medical/emt,
		/obj/item/clothing/mask/gas/half,
		/obj/item/weapon/tank/emergency/oxygen/engi,
		/obj/item/weapon/storage/box/autoinjectors,
		/obj/item/device/healthanalyzer,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/weapon/storage/firstaid/adv,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/medic, /obj/item/weapon/storage/backpack/satchel_med)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/med, /obj/item/weapon/storage/backpack/messenger/med))
	)

/obj/structure/closet/secure_closet/medical_contractor
	name = "medical contractor's locker"
	req_access = list(access_medical)
	icon_state = "securemed1"
	icon_closed = "securemed"
	icon_locked = "securemed1"
	icon_opened = "securemedopen"
	icon_broken = "securemedbroken"
	icon_off = "securemedoff"

/obj/structure/closet/secure_closet/medical_contractor/WillContain()
	return list(
		/obj/item/clothing/under/rank/orderly,
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/shoes/white,
		/obj/item/weapon/cartridge/medical,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/taperoll/medical,
		/obj/item/weapon/storage/belt/medical/emt,
		/obj/item/device/healthanalyzer,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/weapon/storage/firstaid/adv,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/medic, /obj/item/weapon/storage/backpack/satchel_med)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/dufflebag/med, /obj/item/weapon/storage/backpack/messenger/med))
	)

/obj/structure/closet/wardrobe/medic_torch
	name = "medical wardrobe"
	icon_state = "white"
	icon_closed = "white"

/obj/structure/closet/wardrobe/medic_torch/WillContain()
	return list(
		/obj/item/clothing/under/sterile = 2,
		/obj/item/clothing/under/rank/medical/blue,
		/obj/item/clothing/under/rank/medical/green,
		/obj/item/clothing/under/rank/medical/purple,
		/obj/item/clothing/under/rank/medical/black,
		/obj/item/clothing/under/rank/medical/navyblue,
		/obj/item/clothing/head/surgery/navyblue,
		/obj/item/clothing/head/surgery/purple,
		/obj/item/clothing/head/surgery/blue,
		/obj/item/clothing/head/surgery/green,
		/obj/item/clothing/head/surgery/black,
		/obj/item/clothing/suit/surgicalapron = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 2,
		/obj/item/clothing/mask/surgical = 2
	)
