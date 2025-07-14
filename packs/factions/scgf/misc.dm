// ERT Loadout

/obj/structure/closet/secure_closet/ert
	name = "\improper ERT equipment locker"
	req_access = list(access_ert_responder)
	closet_appearance = /singleton/closet_appearance/secure_closet/ert

/obj/structure/closet/secure_closet/ert/WillContain()
	return list(
		/obj/item/storage/backpack/dufflebag,
		/obj/item/clothing/under/scga/utility/urban,
		/obj/item/storage/wallet/poly,
		/obj/item/device/radio/headset/ert/alt,
		/obj/item/device/radio/headset/ert,
		/obj/item/clothing/accessory/ubac/blue,
		/obj/item/clothing/accessory/ubac,
		/obj/item/clothing/head/beret/solgov/fleet/branch/fifth,
		/obj/item/clothing/gloves/thick/duty/solgov/fleet/combat,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/accessory/storage/black_drop,
		/obj/item/clothing/accessory/storage/bandolier,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/mask/balaclava,
		/obj/item/device/binoculars,
		/obj/item/material/knife/folding/swiss/tactical
	)

/obj/structure/closet/secure_closet/ert/leader
	name = "\improper ERT leader's equipment locker"
	req_access = list(access_ert_leader)
	closet_appearance = /singleton/closet_appearance/secure_closet/ert/leader

/obj/structure/closet/secure_closet/ert/leader/WillContain()
	return list(
		/obj/item/storage/backpack/dufflebag,
		/obj/item/clothing/under/scga/utility/urban,
		/obj/item/storage/wallet/poly,
		/obj/item/device/radio/headset/ert/alt,
		/obj/item/device/radio/headset/ert,
		/obj/item/clothing/accessory/ubac/blue,
		/obj/item/clothing/accessory/ubac,
		/obj/item/clothing/gloves/thick/duty/solgov/fleet/combat,
		/obj/item/clothing/accessory/storage/black_vest,
		/obj/item/clothing/accessory/storage/black_drop,
		/obj/item/clothing/accessory/storage/bandolier,
		/obj/item/clothing/accessory/storage/holster/thigh,
		/obj/item/clothing/mask/gas,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/mask/balaclava,
		/obj/item/device/binoculars,
		/obj/item/material/knife/folding/swiss/tactical
	)

/obj/structure/closet/secure_closet/ert/empty/WillContain()
	return list()

/obj/structure/closet/secure_closet/ert/wall
	name = "secure equipment cabinet"
	req_access = list(access_ert_responder)
	density = FALSE
	anchored = TRUE
	wall_mounted = TRUE
	storage_types = CLOSET_STORAGE_ITEMS

	closet_appearance = /singleton/closet_appearance/wall/ert/secure

/obj/structure/closet/walllocker/ert
	name = "equipment cabinet"
	closet_appearance = /singleton/closet_appearance/wall/ert

// Decals

/singleton/closet_appearance/secure_closet/ert
	color = COLOR_DARK_BLUE_GRAY
	decals = list("lower_vent")
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_STEEL,
		"stripe_vertical_right_full" =  COLOR_STEEL,
		"exped_closed" = COLOR_STEEL
	)

/singleton/closet_appearance/secure_closet/ert/leader
	extra_decals = list(
		"stripe_vertical_left_full" =  COLOR_SUN,
		"stripe_vertical_right_full" =  COLOR_SUN,
		"exped_closed" = COLOR_SUN
	)

/singleton/closet_appearance/wall/ert
	color = COLOR_GUNMETAL
	decals = null
	extra_decals = list(
		"stripe_outer_closed" = COLOR_SOL
	)

/singleton/closet_appearance/wall/ert/secure
	can_lock = TRUE
