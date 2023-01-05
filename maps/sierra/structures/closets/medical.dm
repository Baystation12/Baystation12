/*
 * Sierra Medical
 */

/obj/structure/closet/secure_closet/CMO_sierra
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	icon_state = "cmo"

/obj/structure/closet/secure_closet/CMO_sierra/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
		/obj/item/device/radio/headset/heads/cmo,
		/obj/item/device/radio/headset/heads/cmo/alt,
		/obj/item/device/flash,
		/obj/item/device/scanner/health,
		/obj/item/clothing/suit/armor/pcarrier/light,
		/obj/item/device/megaphone,
		/obj/item/reagent_containers/hypospray/vial,
		/obj/item/device/flashlight/pen,
		/obj/item/storage/belt/medical,
		/obj/item/device/remote_device/chief_medical_officer,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/storage/firstaid/adv,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/storage/fancy/vials,
	)

/obj/structure/closet/secure_closet/medical_sierrasenior
	name = "surgeon's locker"
	req_access = list(access_senmed)


/obj/structure/closet/secure_closet/medical_sierrasenior/WillContain()
	return list(
		/obj/item/clothing/suit/surgicalapron,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/device/radio/headset/headset_med/alt,
		/obj/item/storage/belt/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/device/scanner/health,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/storage/firstaid/adv,
	)

/obj/structure/closet/secure_closet/medical_sierra
	name = "doctor's locker"
	req_access = list(access_medical_equip)
	icon_state = "med"

/obj/structure/closet/secure_closet/medical_sierra/WillContain()
	return list(
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/device/radio/headset/headset_med/alt,
		/obj/item/storage/belt/medical,
		/obj/item/taperoll/medical,
		/obj/item/device/flashlight/pen,
		/obj/item/storage/box/autoinjectors,
		/obj/item/device/scanner/health,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/storage/firstaid/adv,
	)

/obj/structure/closet/wardrobe/medic_sierra
	name = "medical wardrobe"


/obj/structure/closet/wardrobe/medic_sierra/WillContain()
	return list(
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/suit/storage/toggle/labcoat = 2,
		/obj/item/clothing/under/sterile = 2,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel/med)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag/med, /obj/item/storage/backpack/messenger/med))
	)

/obj/structure/closet/secure_closet/chemical_sierra
	name = "chemical closet"
	desc = "Store dangerous chemicals in here."
	req_access = list(access_chemistry)

/obj/structure/closet/secure_closet/chemical_sierra/WillContain()
	return list(
		/obj/item/storage/box/pillbottles = 2,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/storage/box/freezer,
		/obj/item/storage/box/syringes,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/beakers/insulated,
		/obj/item/reagent_containers/glass/beaker/large,
		/obj/item/reagent_containers/glass/beaker/insulated/large
	)
