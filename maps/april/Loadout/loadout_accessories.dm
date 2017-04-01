/datum/gear/accessory
	display_name = "black vest"
	path = /obj/item/clothing/accessory/toggleable/vest
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/suspenders
	display_name = "suspenders"
	path = /obj/item/clothing/accessory/suspenders

/datum/gear/accessory/wcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/accessory/wcoat

/datum/gear/accessory/necklace
	display_name = "necklace"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/armband
	display_name = "armband selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/armbands = list()
	armbands["red armband"] = /obj/item/clothing/accessory/armband
	armbands["cargo armband"] = /obj/item/clothing/accessory/armband/cargo
	armbands["EMT armband"] = /obj/item/clothing/accessory/armband/medgreen
	armbands["medical armband"] = /obj/item/clothing/accessory/armband/med
	armbands["engineering armband"] = /obj/item/clothing/accessory/armband/engine
	armbands["hydroponics armband"] = /obj/item/clothing/accessory/armband/hydro
	gear_tweaks += new/datum/gear_tweak/path(armbands)

/datum/gear/accessory/wallet
	display_name = "wallet"
	path = /obj/item/weapon/storage/wallet
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/weapon/storage/wallet/poly
	cost = 2

/datum/gear/accessory/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/holster

/datum/gear/accessory/holster/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/holster)

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["blue tie"] = /obj/item/clothing/accessory/blue
	ties["red tie"] = /obj/item/clothing/accessory/red
	ties["blue tie, clip"] = /obj/item/clothing/accessory/blue_clip
	ties["red long tie"] = /obj/item/clothing/accessory/red_long
	ties["black tie"] = /obj/item/clothing/accessory/black
	ties["yellow tie"] = /obj/item/clothing/accessory/yellow
	ties["navy tie"] = /obj/item/clothing/accessory/navy
	ties["horrible tie"] = /obj/item/clothing/accessory/horrible
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/stethoscope
	display_name = "stethoscope (medical)"
	path = /obj/item/clothing/accessory/stethoscope
	allowed_roles = list("Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/brown_vest
	display_name = "webbing, engineering"
	path = /obj/item/clothing/accessory/storage/brown_vest
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/accessory/black_vest
	display_name = "webbing, security"
	path = /obj/item/clothing/accessory/storage/black_vest
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/accessory/white_vest
	display_name = "webbing, medical"
	path = /obj/item/clothing/accessory/storage/white_vest
	allowed_roles = list("Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/brown_drop_pouches
	display_name = "drop pouches, engineering"
	path = /obj/item/clothing/accessory/storage/drop_pouches/brown
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/accessory/black_drop_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/drop_pouches/black
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/accessory/white_drop_pouches
	display_name = "drop pouches, medical"
	path =/obj/item/clothing/accessory/storage/drop_pouches/white
	allowed_roles = list("Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/accessory/hawaii
	display_name = "hawaii shirt"
	path = /obj/item/clothing/accessory/toggleable/hawaii

/datum/gear/accessory/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["blue hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii
	shirts["red hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/red
	shirts["random colored hawaii shirt"] = /obj/item/clothing/accessory/toggleable/hawaii/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)

/datum/gear/accessory/scarf
	display_name = "scarf"
	path = /obj/item/clothing/accessory/scarf
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/locket
	display_name = "locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/accessory/gun
	display_name = "Gun selection"
	description = "a selection of pistols"
	path = /obj/item/weapon/gun/projectile
	cost = 5

/datum/gear/accessory/gun/New()
	..()
	var/guns = list()
	guns["vintage .45 pistol"] = /obj/item/weapon/gun/projectile/colt
	guns[".50 magnum pistol"] = /obj/item/weapon/gun/projectile/magnum_pistol
	guns["zip gun"] = /obj/item/weapon/gun/projectile/pirate
	guns["revolver"] = /obj/item/weapon/gun/projectile/revolver
	guns["Deckard .44"] = /obj/item/weapon/gun/projectile/revolver/deckard
	gear_tweaks += new/datum/gear_tweak/path(guns)
