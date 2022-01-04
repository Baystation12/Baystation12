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
		/obj/item/device/remote_device/captain,
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
