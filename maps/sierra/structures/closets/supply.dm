/*
 * Sierra Supply
 */

/singleton/closet_appearance/secure_closet/sierra/prospector
	color = COLOR_WARM_YELLOW
	decals = list(
		"upper_side_vent",
		"lower_side_vent"
	)
	extra_decals = list(
		"stripe_vertical_mid_partial" = COLOR_BEASTY_BROWN,
		"stripe_vertical_left_partial" = COLOR_BEASTY_BROWN,
		"mining" = COLOR_BEASTY_BROWN
	)

/singleton/closet_appearance/secure_closet/sierra/cargo/decktech
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BEASTY_BROWN,
		"stripe_vertical_right_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_BEASTY_BROWN
	)

/singleton/closet_appearance/secure_closet/sierra/cargo/quartmaster
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_GOLD,
		"stripe_vertical_left_full" = COLOR_BEASTY_BROWN,
		"stripe_vertical_right_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_GOLD
	)

/obj/structure/closet/secure_closet/decktech
	name = "cargo technician's locker"
	req_access = list(access_cargo)
	closet_appearance = /singleton/closet_appearance/secure_closet/sierra/cargo/decktech

/obj/structure/closet/secure_closet/decktech/WillContain()
	return list(
		/obj/item/device/radio/headset/headset_cargo,
		/obj/item/device/radio/headset/headset_cargo/alt,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/storage/belt/utility/atmostech,
		/obj/item/hand_labeler,
		/obj/item/material/clipboard,
		/obj/item/folder/yellow,
		/obj/item/stack/package_wrap/twenty_five,
		/obj/item/marshalling_wand,
		/obj/item/marshalling_wand,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack = 75, /obj/item/storage/backpack/satchel/grey = 25)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/messenger = 75, /obj/item/storage/backpack/dufflebag = 25))
	)

/obj/structure/closet/secure_closet/quartermaster_sierra
	name = "quartermaster's locker"
	req_access = list(access_qm)
	icon_state = "qm"

/obj/structure/closet/secure_closet/quartermaster_sierra/WillContain()
	return list(
		/obj/item/device/radio/headset/sierra_quartermaster,
		/obj/item/device/radio/headset/sierra_quartermaster/alt,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/accessory/storage/brown_vest,
		/obj/item/storage/belt/utility/full,
		/obj/item/hand_labeler,
		/obj/item/material/clipboard,
		/obj/item/folder/yellow,
		/obj/item/stack/package_wrap/twenty_five,
		/obj/item/device/flash,
		/obj/item/device/remote_device/quartermaster,
		/obj/item/device/megaphone,
		/obj/item/clothing/suit/armor/pcarrier/light,
		/obj/item/device/binoculars,
		/obj/item/device/scanner/price,
	)

/obj/structure/closet/secure_closet/prospector
	name = "prospector's locker"
	req_access = list(access_mining)
	icon_state = "mining"

/obj/structure/closet/secure_closet/prospector/WillContain()
	return list(
		/obj/item/clothing/accessory/storage/webbing,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/shoes/workboots,
		/obj/item/device/scanner/gas,
		/obj/item/storage/ore,
		/obj/item/device/radio/headset/headset_mining,
		/obj/item/device/radio/headset/headset_mining/alt,
		/obj/item/device/flashlight/lantern,
		/obj/item/shovel,
		/obj/item/pickaxe,
		/obj/item/crowbar,
		/obj/item/clothing/glasses/material,
		/obj/item/clothing/glasses/meson,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/industrial, /obj/item/storage/backpack/satchel/eng)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag/eng, /obj/item/storage/backpack/messenger/engi))
	)
