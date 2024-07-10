/*
 * Torch Science
 */
/singleton/closet_appearance/secure_closet/torch/science
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_PURPLE_GRAY,
		"stripe_vertical_right_full" = COLOR_PURPLE_GRAY,
		"research" = COLOR_PURPLE_GRAY
	)

/singleton/closet_appearance/secure_closet/torch/science/cso
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_left_full" = COLOR_PURPLE_GRAY,
		"stripe_vertical_right_full" = COLOR_PURPLE_GRAY,
		"research" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/RD_torch
	name = "chief science officer's locker"
	req_access = list(access_rd)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/science/cso

/obj/structure/closet/secure_closet/RD_torch/WillContain()
	return list(
		/obj/item/clothing/suit/storage/toggle/labcoat/rd/ec,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/science,
		/obj/item/device/radio/headset/heads/torchntdirector,
		/obj/item/device/radio/headset/heads/torchntdirector/alt,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/clothing/mask/gas,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/device/tape/random = 3,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/storage/box/secret_project_disks/science,
		/obj/item/storage/belt/general/full,
		/obj/item/device/holowarrant,
		/obj/item/storage/backpack/dufflebag
	)

/obj/structure/closet/secure_closet/secure_closet/xenoarchaeologist_torch
	name = "xenoarchaeologist's locker"
	req_access = list(access_xenoarch)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/science

/obj/structure/closet/secure_closet/secure_closet/xenoarchaeologist_torch/WillContain()
	return list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat/science/ec,
		/obj/item/device/radio/headset/science,
		/obj/item/device/radio/headset/science/alt,
		/obj/item/clothing/mask/gas,
		/obj/item/material/clipboard,
		/obj/item/folder,
		/obj/item/device/taperecorder,
		/obj/item/device/tape/random = 3,
		/obj/item/device/camera,
		/obj/item/device/scanner/gas,
		/obj/item/taperoll/research,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/science,
		/obj/item/clothing/glasses/meson,
		/obj/item/device/radio,
		/obj/item/device/flashlight/lantern,
		/obj/item/storage/backpack/dufflebag
	)

/obj/structure/closet/secure_closet/scientist_torch
	name = "researcher's locker"
	req_access = list(access_research_storage)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/science

/obj/structure/closet/secure_closet/scientist_torch/WillContain()
	return list(
		/obj/item/clothing/under/rank/scientist,
		/obj/item/clothing/suit/storage/toggle/labcoat/science,
		/obj/item/clothing/suit/storage/toggle/labcoat/science/ec,
		/obj/item/device/radio/headset/science,
		/obj/item/device/radio/headset/science/alt,
		/obj/item/clothing/mask/gas/half,
		/obj/item/device/scanner/gas,
		/obj/item/clothing/gloves/latex,
		/obj/item/clothing/glasses/science,
		/obj/item/storage/belt/general/full,
		/obj/item/storage/backpack/dufflebag,
		/obj/item/storage/backpack/messenger/sci
	)
