/*
 * Torch Supply
 */
/decl/closet_appearance/secure_closet/torch/cargo
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/torch/cargo/worker
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BEASTY_BROWN,
		"stripe_vertical_right_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/torch/cargo/deck_officer
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_left_full" = COLOR_BEASTY_BROWN,
		"stripe_vertical_right_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/decktech
	name = "deck technician's locker"
	req_access = list(access_cargo)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/cargo/worker

/obj/structure/closet/secure_closet/decktech/WillContain()
	return list(
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/device/radio/headset/headset_cargo/alt,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/weapon/storage/belt/utility/atmostech,
		/obj/item/weapon/hand_labeler,
		/obj/item/weapon/material/clipboard,
		/obj/item/weapon/folder/yellow,
		/obj/item/stack/package_wrap/twenty_five,
		/obj/item/weapon/marshalling_wand,
		/obj/item/weapon/marshalling_wand,
		/obj/item/weapon/storage/belt/general,
		/obj/item/weapon/stamp/cargo,
		/obj/item/weapon/stamp/denied,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack = 75, /obj/item/weapon/storage/backpack/satchel/grey = 25)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/messenger = 75, /obj/item/weapon/storage/backpack/dufflebag = 25))
	)

/obj/structure/closet/secure_closet/deckofficer
	name = "deck chief's locker"
	req_access = list(access_qm)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/cargo/deck_officer

/obj/structure/closet/secure_closet/deckofficer/WillContain()
	return list(
		/obj/item/device/radio/headset/headset_deckofficer,
		/obj/item/device/radio/headset/headset_deckofficer/alt,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/weapon/storage/belt/utility/full,
		/obj/item/weapon/hand_labeler,
		/obj/item/weapon/material/clipboard,
		/obj/item/weapon/folder/yellow,
		/obj/item/stack/package_wrap/twenty_five,
		/obj/item/device/flash,
		/obj/item/device/megaphone,
		/obj/item/device/holowarrant,
		/obj/item/clothing/suit/armor/pcarrier/light/sol,
		/obj/item/device/binoculars,
		/obj/item/weapon/storage/belt/general,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack = 75, /obj/item/weapon/storage/backpack/satchel/grey = 25)),
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/messenger = 75, /obj/item/weapon/storage/backpack/dufflebag = 25))
	)

/obj/structure/closet/secure_closet/prospector
	name = "prospector's locker"
	req_access = list(access_mining)
	closet_appearance = /decl/closet_appearance/secure_closet/torch/cargo

/obj/structure/closet/secure_closet/prospector/WillContain()
	return list(
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/shoes/workboots,
		/obj/item/device/radio/headset/headset_mining,
		/obj/item/device/radio/headset/headset_mining/alt,
		/obj/item/device/flashlight/lantern,
		/obj/item/weapon/shovel,
		/obj/item/weapon/pickaxe,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/wrench,
		/obj/item/weapon/storage/ore,
		/obj/item/device/scanner/mining,
		/obj/item/device/gps,
		/obj/item/device/radio,
		/obj/item/clothing/glasses/material,
		/obj/item/clothing/glasses/meson,
		new /datum/atom_creator/weighted(list(/obj/item/weapon/storage/backpack/industrial, /obj/item/weapon/storage/backpack/satchel/eng, /obj/item/weapon/storage/backpack/messenger/engi)),
		/obj/item/weapon/storage/backpack/dufflebag/eng
	)
