/*
 * Torch Medical
 */
/decl/closet_appearance/secure_closet/torch/medical
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_BABY_BLUE
	)

/decl/closet_appearance/secure_closet/torch/medical/physician
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BABY_BLUE,
		"stripe_vertical_right_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_BABY_BLUE
	)

/decl/closet_appearance/secure_closet/torch/medical/cmo
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BABY_BLUE,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/counselor
	closet_appearance = /decl/closet_appearance/secure_closet/torch/medical

/obj/structure/closet/secure_closet/CMO_torch
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/medical/cmo

/obj/structure/closet/secure_closet/CMO_torch/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
		/obj/item/device/radio/headset/heads/cmo,
		/obj/item/device/radio/headset/heads/cmo/alt,
		/obj/item/device/flash,
		/obj/item/gun/energy/confuseray,
		/obj/item/device/megaphone,
		/obj/item/reagent_containers/hypospray/vial,
		/obj/item/storage/fancy/vials,
		/obj/item/device/scanner/health,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
		//proxima code start,
		/obj/item/device/remote_device/chief_medical_officer,
		//proxima code end,
		/obj/item/device/holowarrant,
		/obj/item/storage/firstaid/adv,
		/obj/item/storage/box/armband/med,
		/obj/item/material/knife/folding/swiss/officer,
		/obj/item/storage/backpack/dufflebag/med,
		RANDOM_SCRUBS
	)

/obj/structure/closet/secure_closet/medical_torchsenior
	name = "physician's locker"
	req_access = list(access_senmed)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/medical/physician

/obj/structure/closet/secure_closet/medical_torchsenior/WillContain()
	return list(
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/surgicalapron,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/device/radio/headset/headset_med/alt,
		/obj/item/taperoll/medical,
		/obj/item/storage/belt/medical,
		/obj/item/clothing/mask/surgical,
		/obj/item/device/scanner/health,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/device/megaphone,
		/obj/item/storage/firstaid/adv,
		/obj/item/material/knife/folding/swiss/medic,
		/obj/item/storage/backpack/dufflebag/med,
		RANDOM_SCRUBS = 2
	)

/obj/structure/closet/secure_closet/medical_torch
	name = "medical technician's locker"
	req_access = list(access_medical_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/medical

/obj/structure/closet/secure_closet/medical_torch/WillContain()
	return list(
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/device/radio/headset/headset_med,
		/obj/item/device/radio/headset/headset_corpsman/alt,
		/obj/item/taperoll/medical,
		/obj/item/storage/belt/medical/emt,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/storage/box/autoinjectors,
		/obj/item/device/scanner/health,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/storage/firstaid/adv,
		/obj/item/clothing/suit/storage/medical_chest_rig,
		/obj/item/clothing/head/hardhat/EMS,
		/obj/item/material/knife/folding/swiss/medic,
		/obj/item/storage/backpack/dufflebag/med
	)

/obj/structure/closet/wardrobe/medic_torch
	name = "medical wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/medic_torch/WillContain()
	return list(
		/obj/item/clothing/under/sterile = 2,
		RANDOM_SCRUBS = 4,
		/obj/item/clothing/suit/surgicalapron = 2,
		/obj/item/clothing/shoes/white = 2,
		/obj/item/clothing/mask/surgical = 2
	)
