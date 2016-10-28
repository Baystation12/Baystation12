/datum/gear/accessory
	display_name = "armband, red"
	path = /obj/item/clothing/accessory/armband
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/accessory/cargo
	display_name = "armband, cargo"
	path = /obj/item/clothing/accessory/armband/cargo

/datum/gear/accessory/emt
	display_name = "armband, EMT"
	path = /obj/item/clothing/accessory/armband/medgreen

/datum/gear/accessory/engineering
	display_name = "armband, engineering"
	path = /obj/item/clothing/accessory/armband/engine

/datum/gear/accessory/hydroponics
	display_name = "armband, hydroponics"
	path = /obj/item/clothing/accessory/armband/hydro

/datum/gear/accessory/medical
	display_name = "armband, medical"
	path = /obj/item/clothing/accessory/armband/med

/datum/gear/accessory/science
	display_name = "armband, science"
	path = /obj/item/clothing/accessory/armband/science

/datum/gear/accessory/wallet
	display_name = "wallet"
	path = /obj/item/weapon/storage/wallet
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/wallet_poly
	display_name = "wallet, polychromic"
	path = /obj/item/weapon/storage/wallet/poly
	cost = 2

/datum/gear/accessory/holster
	display_name = "holster, armpit"
	path = /obj/item/clothing/accessory/holster/armpit
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/accessory/holster/hip
	display_name = "holster, hip"
	path = /obj/item/clothing/accessory/holster/hip

/datum/gear/accessory/holster/waist
	display_name = "holster, waist"
	path = /obj/item/clothing/accessory/holster/waist

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory/tie

/datum/gear/accessory/tie/New()
	..()
	var/list/ties = list()
	for(var/tie in typesof(/obj/item/clothing/accessory/tie))
		var/obj/item/clothing/accessory/tie/tie_type = tie
		ties[initial(tie_type.name)] = tie_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(ties))

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
	path = /obj/item/clothing/accessory/storage/brown_drop_pouches
	allowed_roles = list("Station Engineer","Atmospheric Technician","Chief Engineer")

/datum/gear/accessory/black_drop_pouches
	display_name = "drop pouches, security"
	path = /obj/item/clothing/accessory/storage/black_drop_pouches
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/accessory/white_drop_pouches
	display_name = "drop pouches, medical"
	path = /obj/item/clothing/accessory/storage/white_drop_pouches
	allowed_roles = list("Paramedic","Chief Medical Officer","Medical Doctor")

/datum/gear/accessory/webbing
	display_name = "webbing, simple"
	path = /obj/item/clothing/accessory/storage/webbing

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

/datum/gear/accessory/collar
	display_name = "collar selection"
	description = "A collar for your little pets... or the big ones."
	path = /obj/item/clothing/accessory/collar

/datum/gear/accessory/collar/New()
	..()
	var/list/collars = list()
	for(var/collar in typesof(/obj/item/clothing/accessory/collar))
		var/obj/item/clothing/accessory/collar/collar_type = collar
		collars[initial(collar_type.name)] = collar_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(collars))

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf

/datum/gear/accessory/scarf/New()
	..()
	var/list/scarves = list()
	for(var/scarf in typesof(/obj/item/clothing/accessory/scarf))
		var/obj/item/clothing/accessory/scarf/scarf_type = scarf
		scarves[initial(scarf_type.name)] = scarf_type
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(scarves))

/datum/gear/accessory/chaps
	display_name = "chaps, brown"
	description = "Why do they not cover the groin?"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	display_name = "chaps, black"
	path = /obj/item/clothing/accessory/chaps/black


/datum/gear/accessory/suitjacket/det_vest
	display_name = "suit jacket, vest"
	path = /obj/item/clothing/accessory/toggleable/vest

/datum/gear/accessory/suitjacket
	display_name = "suit jacket, tan"
	path = /obj/item/clothing/accessory/toggleable/tan_jacket

/datum/gear/accessory/suitjacket/charcoal
	display_name = "suit jacket, charcoal"
	path = /obj/item/clothing/accessory/toggleable/charcoal_jacket

/datum/gear/accessory/suitjacket/navy
	display_name = "suit jacket, navy blue"
	path = /obj/item/clothing/accessory/toggleable/navy_jacket

/datum/gear/accessory/suitjacket/burgundy
	display_name = "suit jacket, burgundy"
	path = /obj/item/clothing/accessory/toggleable/burgundy_jacket

/datum/gear/accessory/suitjacket/checkered
	display_name = "suit jacket, checkered"
	path = /obj/item/clothing/accessory/toggleable/checkered_jacket