/*
 * Torch Exploration
 */

/decl/closet_appearance/secure_closet/torch/exploration
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_PURPLE,
		"exped" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/torch/exploration/pilot
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"exped" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/torch/exploration/pathfinder
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_PURPLE,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_PURPLE,
		"exped" = COLOR_CLOSET_GOLD
	)

//proxima code
/decl/closet_appearance/secure_closet/torch/exploration/medic
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_WHITE,
		"exped" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/torch/exploration/engineer
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_ORANGE,
		"exped" = COLOR_PURPLE
	)

/decl/closet_appearance/secure_closet/torch/exploration/guard
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_NT_RED,
		"security" = COLOR_NT_RED
	)

/obj/structure/closet/secure_closet/explorer/medic
	name = "expedition medic's locker"
	req_access = list(access_explorer)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/exploration/medic

/obj/structure/closet/secure_closet/explorer/medic/WillContain()
	return list(
		/obj/item/storage/belt/medical/emt,
		/obj/item/storage/box/gloves,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/storage/box/masks,
		/obj/item/storage/firstaid/adv,
		/obj/item/storage/firstaid/stab,
		/obj/item/bodybag/rescue/loaded,
		/obj/item/bodybag/rescue/loaded,
		/obj/item/device/scanner/health,
		/obj/item/roller,
		/obj/item/clothing/accessory/storage/holster/machete,
		/obj/item/device/radio,
		/obj/item/device/gps,
		/obj/item/taperoll/research,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio/headset/exploration,
		/obj/item/device/radio/headset/exploration/alt,
		/obj/item/device/binoculars,
		/obj/item/clothing/accessory/buddy_tag,
		/obj/item/storage/firstaid/individual/military,
		/obj/item/material/knife/folding/swiss/explorer,
		/obj/item/device/camera,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/explorer, /obj/item/storage/backpack/satchel/explorer)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger/explorer)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)
/obj/structure/closet/secure_closet/explorer/engineer
	name = "expedition engineer's locker"
	req_access = list(access_explorer)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/exploration/engineer

/obj/structure/closet/secure_closet/explorer/engineer/WillContain()
	return list(
		/obj/item/storage/belt/utility/full,
		/obj/item/clothing/gloves/insulated,
		/obj/item/device/multitool,
		/obj/item/clothing/accessory/storage/holster/machete,
		/obj/item/device/radio,
		/obj/item/device/gps,
		/obj/item/taperoll/research,
		/obj/item/device/spaceflare,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/device/scanner/gas,
		/obj/item/device/radio/headset/exploration,
		/obj/item/device/radio/headset/exploration/alt,
		/obj/item/device/binoculars,
		/obj/item/clothing/accessory/buddy_tag,
		/obj/item/storage/firstaid/individual/military,
		/obj/item/material/knife/folding/swiss/explorer,
		/obj/item/clothing/glasses/welding,
		/obj/item/clothing/head/welding,
		/obj/item/device/camera,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/explorer, /obj/item/storage/backpack/satchel/explorer)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger/explorer)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)

/obj/structure/closet/secure_closet/explorer/marine
	name = "expedition guard's locker"
	req_access = list(access_exploration_guard)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/exploration/guard

/obj/structure/closet/secure_closet/explorer/marine/WillContain()
	return list(
		/obj/item/cell/guncell/medium = 3,
		/obj/item/cell/guncell/small = 4,
		/obj/item/gun/energy/k342/explo = 1,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/accessory/storage/holster/knife/polymer,
		/obj/item/material/knife/combat,
		/obj/item/storage/firstaid/individual/military,
		/obj/item/gun/energy/stunrevolver/secure,
		/obj/item/storage/belt/holster/security,
		/obj/item/clothing/accessory/storage/webbing_large,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/security, /obj/item/storage/backpack/satchel/sec)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag/sec, /obj/item/storage/backpack/messenger/sec)),
	)
//proxima code end

/obj/structure/closet/secure_closet/pathfinder
	name = "pathfinder's locker"
	req_access = list(access_pathfinder)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/exploration/pathfinder

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
		//rubay code,
		/obj/item/storage/firstaid/individual/military,
		//rubay code end,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)

/obj/structure/closet/secure_closet/explorer
	name = "explorer's locker"
	req_access = list(access_explorer)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/exploration

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
		//rubay code,
		/obj/item/storage/firstaid/individual/military,
		//rubay code end,
		/obj/item/material/knife/folding/swiss/explorer,
		/obj/item/device/camera,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/explorer, /obj/item/storage/backpack/satchel/explorer)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger/explorer)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)

/obj/structure/closet/secure_closet/pilot
	name = "pilot's locker"
	req_access = list(access_pilot)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/exploration/pilot

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
		/obj/item/clothing/head/helmet/solgov/pilot,
		/obj/item/clothing/head/helmet/solgov/pilot/fleet,
		/obj/item/clothing/head/helmet/nt/pilot,
		//rubay code,
		/obj/item/storage/firstaid/individual/military,
		/obj/item/clothing/accessory/storage/holster/machete,
		//rubay code end,
		/obj/item/material/knife/folding/swiss/explorer,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)
