/datum/gear/storage/
	sort_category = "Storage Accessories"
	category = /datum/gear/storage/
	slot = slot_tie

/datum/gear/storage/brown_vest
	display_name = "webbing, brown"
	path = /obj/item/clothing/accessory/storage/brown_vest
	cost = 3
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/mining, /datum/job/janitor)

/datum/gear/storage/black_vest
	display_name = "webbing, black"
	path = /obj/item/clothing/accessory/storage/black_vest
	cost = 3
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer)

/datum/gear/storage/white_vest
	display_name = "webbing, white"
	path = /obj/item/clothing/accessory/storage/white_vest
	cost = 3
	allowed_roles = list(/datum/job/cmo, /datum/job/doctor)

/datum/gear/storage/brown_drop_pouches
	display_name = "drop pouches, brown"
	path = /obj/item/clothing/accessory/storage/drop_pouches/brown
	cost = 3
	allowed_roles = list(/datum/job/chief_engineer, /datum/job/engineer, /datum/job/roboticist, /datum/job/qm, /datum/job/cargo_tech,
						/datum/job/mining, /datum/job/janitor)

/datum/gear/storage/black_drop_pouches
	display_name = "drop pouches, black"
	path = /obj/item/clothing/accessory/storage/drop_pouches/black
	cost = 3
	allowed_roles = list(/datum/job/hos, /datum/job/warden, /datum/job/detective, /datum/job/officer)

/datum/gear/storage/white_drop_pouches
	display_name = "drop pouches, white"
	path = /obj/item/clothing/accessory/storage/drop_pouches/white
	cost = 3
	allowed_roles = list(/datum/job/cmo, /datum/job/doctor)

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
	path = /obj/item/weapon/storage/belt/waistpack
	slot = slot_belt
	cost = 2
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/storage/waistpack/big
	display_name = "large waist pack"
	path = /obj/item/weapon/storage/belt/waistpack/big
	cost = 4

/datum/gear/accessory/wallet
	display_name = "wallet, colour select"
	path = /obj/item/weapon/storage/wallet
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/weapon/storage/wallet/poly
	cost = 2