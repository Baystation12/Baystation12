/datum/gear/storage
	sort_category = "Storage Accessories"
	category = /datum/gear/storage
	slot = slot_tie

/datum/gear/storage/vest
	display_name = "webbing vest selection"
	path = /obj/item/clothing/accessory/storage
	cost = 3

/datum/gear/storage/vest/New()
	..()
	var/vests = list()
	vests += /obj/item/clothing/accessory/storage/black_vest
	vests += /obj/item/clothing/accessory/storage/brown_vest
	vests += /obj/item/clothing/accessory/storage/white_vest
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(vests)

/datum/gear/storage/pouches
	display_name = "drop pouches selection"
	path = /obj/item/clothing/accessory/storage

/datum/gear/storage/pouches/New()
	..()
	var/pouches = list()
	pouches += /obj/item/clothing/accessory/storage/black_drop
	pouches += /obj/item/clothing/accessory/storage/brown_drop
	pouches += /obj/item/clothing/accessory/storage/white_drop
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(pouches)

/datum/gear/storage/belt
	display_name = "storage belt selection"
	path = /obj/item/storage/belt
	slot = slot_belt
	cost = 2

/datum/gear/storage/belt/New()
	..()
	var/belts = list(
		/obj/item/storage/belt/general,
		/obj/item/storage/belt/utility
	)
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(belts)

/datum/gear/storage/webbing
	display_name = "webbing, small"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/storage/webbing_large
	display_name = "webbing, large"
	path = /obj/item/clothing/accessory/storage/webbing_large
	cost = 3

/datum/gear/storage/bandolier
	display_name = "bandolier"
	path = /obj/item/clothing/accessory/storage/bandolier
	cost = 3

/datum/gear/storage/waistpack
	display_name = "waist pack"
	path = /obj/item/storage/belt/waistpack
	slot = slot_belt
	cost = 2
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/storage/waistpack/big
	display_name = "large waist pack"
	path = /obj/item/storage/belt/waistpack/big
	cost = 4

/datum/gear/accessory/wallet
	display_name = "wallet, colour select"
	path = /obj/item/storage/wallet
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/storage/wallet/poly
	cost = 2
