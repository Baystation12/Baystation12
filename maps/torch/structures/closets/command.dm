/*
 * Torch Command
 */
/decl/closet_appearance/secure_closet/torch/command
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/command/bo
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/command/xo
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_CLOSET_GOLD,
		"command" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/command/co
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_mid_full" = COLOR_OFF_WHITE,
		"stripe_vertical_right_full" = COLOR_CLOSET_GOLD,
		"command" = COLOR_OFF_WHITE
	)

/decl/closet_appearance/secure_closet/torch/command/synth_med
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BABY_BLUE,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_CLOSET_GOLD
	)

/decl/closet_appearance/secure_closet/torch/command/synth_eng
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_WARM_YELLOW,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_WARM_YELLOW,
		"exped" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/CO
	name = "commanding officer's locker"
	req_access = list(access_captain)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/command/co

/obj/structure/closet/secure_closet/CO/WillContain()
	return list(
		/obj/item/device/radio/headset/heads/torchexec,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/device/radio/headset/heads/torchexec/alt,
		/obj/item/storage/belt/general,
		/obj/item/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/gun/energy/confuseray,
		/obj/item/device/megaphone,
		//proxima code start,
		/obj/item/storage/box/radiokeys,
		/obj/item/device/remote_device/captain,
		/obj/item/storage/box/encryptionkey/command,
		//proxima code end,
		/obj/item/storage/box/ids,
		/obj/item/material/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/folder/blue,
		/obj/item/material/knife/folding/swiss/officer,
		/obj/item/storage/backpack/satchel/com,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
	)

/obj/structure/closet/secure_closet/XO
	name = "executive officer's locker"
	req_access = list(access_hop)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/command/xo

/obj/structure/closet/secure_closet/XO/WillContain()
	return list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/device/radio/headset/heads/torchexec,
		/obj/item/storage/belt/general,
		/obj/item/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/gun/energy/confuseray,
		/obj/item/device/megaphone,
		/obj/item/storage/box/headset,
		/obj/item/device/radio/headset/heads/torchexec/alt,
		/obj/item/storage/box/radiokeys,
		/obj/item/storage/box/large/ids,
		/obj/item/storage/box/PDAs,
		//proxima code start,
		/obj/item/device/remote_device/civillian,
		/obj/item/storage/box/encryptionkey/service,
		//proxima code end,
		/obj/item/material/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/folder/blue,
		/obj/item/material/knife/folding/swiss/officer,
		/obj/item/storage/backpack/satchel/com,
		/obj/item/storage/box/imprinting,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command
	)

/obj/structure/closet/secure_closet/sea
	name = "senior enlisted advisor's locker"
	req_access = list(access_senadv)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/command

/obj/structure/closet/secure_closet/sea/WillContain()
	return list(
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/armor/pcarrier/medium/command,
		/obj/item/clothing/head/helmet/solgov/command,
		/obj/item/storage/belt/holster/general,
		/obj/item/gun/energy/confuseray,
		/obj/item/device/radio/headset/sea,
		/obj/item/device/radio/headset/sea/alt,
		/obj/item/storage/belt/general,
		/obj/item/melee/telebaton,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/material/clipboard,
		/obj/item/device/holowarrant,
		/obj/item/folder/blue,
		/obj/item/material/knife/folding/swiss/officer,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger))
	)

/obj/structure/closet/secure_closet/bridgeofficer
	name = "bridge officer's locker"
	req_access = list(access_bridge, access_keycard_auth)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/command/bo

/obj/structure/closet/secure_closet/bridgeofficer/WillContain()
	return list(
		/obj/item/device/radio,
		/obj/item/pen,
		/obj/item/device/tape/random,
		/obj/item/device/taperecorder,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/material/clipboard,
		/obj/item/folder/blue,
		/obj/item/modular_computer/tablet/lease/preset/command,
		/obj/item/device/radio/headset/bridgeofficer,
		/obj/item/device/radio/headset/bridgeofficer/alt,
		/obj/item/storage/belt/general,
		/obj/item/material/knife/folding/swiss/officer,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack, /obj/item/storage/backpack/satchel/grey)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag, /obj/item/storage/backpack/messenger)),
		new /datum/atom_creator/weighted(list(/obj/item/device/flashlight, /obj/item/device/flashlight/flare, /obj/item/device/flashlight/flare/glowstick/random))
	)

/obj/structure/closet/secure_closet/synth_med
	name = "EXO Synthethics's medical locker"
	req_access = list(access_bridge, access_keycard_auth)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/command/synth_med

/obj/structure/closet/secure_closet/synth_med/WillContain()
	return list(
		/obj/item/storage/box/autoinjectors,
		/obj/item/clothing/accessory/storage/white_vest,
		/obj/item/storage/box/gloves,
		/obj/item/storage/box/masks,
		/obj/item/storage/box/syringes,
		/obj/item/storage/box/armband/med,
		/obj/item/defibrillator/compact/loaded,
		/obj/item/auto_cpr,
		/obj/item/clothing/glasses/hud/health/prescription,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/device/scanner/health,
		/obj/item/clothing/head/beret/solgov/health,
		/obj/item/clothing/under/sterile,
		/obj/item/clothing/under/solgov/utility/expeditionary/officer/medical,
		/obj/item/clothing/under/gorka/med,
		/obj/item/clothing/suit/storage/toggle/labcoat/science,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/storage/belt/medical/emt,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/device/flashlight/pen,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel/med)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag/med, /obj/item/storage/backpack/messenger/med)),
		RANDOM_SCRUBS,
		RANDOM_SCRUBS
	)

/obj/structure/closet/secure_closet/synth_eng
	name = "EXO Synthethics's engineering locker"
	req_access = list(access_bridge, access_keycard_auth)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/command/synth_eng

/obj/structure/closet/secure_closet/synth_eng/WillContain()
	return list(
		/obj/item/device/multitool,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/welding/superior,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/storage/belt/utility/full,
		/obj/item/taperoll/engineering,
		/obj/item/taperoll/atmos,
		/obj/item/crowbar/brace_jack,
		/obj/item/storage/box/armband/engine,
		/obj/item/clothing/under/gorka/engi,
		/obj/item/clothing/under/hazard,
		/obj/item/clothing/under/rank/atmospheric_technician,
		/obj/item/clothing/under/rank/engineer,
		/obj/item/clothing/under/solgov/utility/expeditionary/officer/engineering,
		/obj/item/device/flashlight,
		/obj/item/clothing/gloves/insulated,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/industrial, /obj/item/storage/backpack/satchel/eng)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag/eng, /obj/item/storage/backpack/messenger/engi))
	)
