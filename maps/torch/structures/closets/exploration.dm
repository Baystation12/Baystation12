/*
 * Torch Exploration
 */

/singleton/closet_appearance/secure_closet/torch/exploration
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_PURPLE,
		"exped" = COLOR_PURPLE
	)

/singleton/closet_appearance/secure_closet/torch/exploration/pilot
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"exped" = COLOR_PURPLE
	)

/singleton/closet_appearance/secure_closet/torch/exploration/pathfinder
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"exped" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/pathfinder
	name = "pathfinder's locker"
	req_access = list(access_pathfinder)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/exploration/pathfinder

/obj/structure/closet/secure_closet/pathfinder/WillContain()
	return list(
		/obj/item/solbanner,
		/obj/item/solbanner,
		/obj/item/device/radio,
		/obj/item/device/tape/random,
		/obj/item/device/gps,
		/obj/item/pinpointer/radio,
		/obj/item/taperoll/research,
		/obj/item/material/hatchet/machete/deluxe,
		/obj/item/storage/belt/holster/machete,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/taperecorder,
		/obj/item/device/scanner/gas,
		/obj/item/device/flash,
		/obj/item/device/radio/headset/pathfinder,
		/obj/item/device/radio/headset/pathfinder/alt,
		/obj/item/storage/box/encryptionkey/exploration,
		/obj/item/device/binoculars,
		/obj/item/material/knife/folding/swiss/explorer,
		/obj/item/clothing/accessory/buddy_tag,
		/obj/item/storage/firstaid/light,
		/obj/item/storage/backpack/dufflebag,
		/obj/item/device/flashlight/flare
	)

/obj/structure/closet/secure_closet/explorer
	name = "explorer's locker"
	req_access = list(access_explorer)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/exploration

/obj/structure/closet/secure_closet/explorer/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/device/gps,
		/obj/item/taperoll/research,
		/obj/item/storage/belt/holster/machete,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio/headset/exploration,
		/obj/item/device/radio/headset/exploration/alt,
		/obj/item/device/binoculars,
		/obj/item/clothing/accessory/buddy_tag,
		/obj/item/storage/firstaid/light,
		/obj/item/material/knife/folding/swiss/explorer,
		/obj/item/device/camera,
		/obj/item/storage/backpack/dufflebag,
		/obj/item/device/flashlight/flare
	)

/obj/structure/closet/secure_closet/pilot
	name = "pilot's locker"
	req_access = list(access_pilot)
	closet_appearance = /singleton/closet_appearance/secure_closet/torch/exploration/pilot

/obj/structure/closet/secure_closet/pilot/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/device/gps,
		/obj/item/storage/belt/utility/full,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio/headset/headset_pilot,
		/obj/item/device/radio/headset/headset_pilot/alt,
		/obj/item/device/binoculars,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/suit/storage/hazardvest/blue,
		/obj/item/helmetcase,
		/obj/item/storage/firstaid/light,
		/obj/item/material/knife/folding/swiss/explorer,
		/obj/item/storage/backpack/dufflebag,
		/obj/item/device/flashlight/flare
	)
