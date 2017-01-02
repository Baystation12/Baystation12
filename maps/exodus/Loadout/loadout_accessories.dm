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
	armbands["science armband"] = /obj/item/clothing/accessory/armband/science
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
	allowed_roles = list("Captain", "Head of Personnel", "Security Officer", "Warden", "Head of Security","Detective")

/datum/gear/accessory/holster/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/holster)

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["blue tie"] = /obj/item/clothing/accessory/tie/blue
	ties["red tie"] = /obj/item/clothing/accessory/tie/red
	ties["blue tie, clip"] = /obj/item/clothing/accessory/tie/blue_clip
	ties["red long tie"] = /obj/item/clothing/accessory/tie/red_long
	ties["black tie"] = /obj/item/clothing/accessory/tie/black
	ties["yellow tie"] = /obj/item/clothing/accessory/tie/yellow
	ties["navy tie"] = /obj/item/clothing/accessory/tie/navy
	ties["horrible tie"] = /obj/item/clothing/accessory/tie/horrible
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

// EROS START

/datum/gear/accessory/collar
	display_name = "collar selection"
	description = "A collar for your little pets... or the big ones."
	path = /obj/item/clothing/accessory/collar

/datum/gear/accessory/collar/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/collar)

/datum/gear/accessory/scarf
	display_name = "scarf selection"
	path = /obj/item/clothing/accessory/scarf

/datum/gear/accessory/scarf/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/accessory/scarf)

/datum/gear/accessory/chaps
	display_name = "chaps, brown"
	description = "Why do they not cover the groin?"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	display_name = "chaps, black"
	path = /obj/item/clothing/accessory/chaps/black

/datum/gear/accessory/suitjacket/checkered
	display_name = "suit jacket, checkered"
	path = /obj/item/clothing/accessory/toggleable/checkered_jacket

/datum/gear/accessory/warmer/armwarmers
	display_name = "arm warmers"
	path = /obj/item/clothing/accessory/warmers/armwarmers
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/warmer/legarmers
	display_name = "leg warmers"
	path = /obj/item/clothing/accessory/warmers/legwarmers
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/suitjacket
	display_name = "suitjacket selection"
	path = /obj/item/clothing/accessory/toggleable/vest

/datum/gear/accessory/suitjacket/New()
	..()
	var/list/suitjacket = list()
	suitjacket["suit jacket, vest"] = /obj/item/clothing/accessory/toggleable/vest
	suitjacket["suit jacket, tan"] = /obj/item/clothing/accessory/toggleable/tan_jacket
	suitjacket["suit jacket, charcoal"] = /obj/item/clothing/accessory/toggleable/charcoal_jacket
	suitjacket["suit jacket, navy blue"] = /obj/item/clothing/accessory/toggleable/navy_jacket
	suitjacket["suit jacket, burgundy"] = /obj/item/clothing/accessory/toggleable/burgundy_jacket
	suitjacket["suit jacket, checkered"] = /obj/item/clothing/accessory/toggleable/checkered_jacket
	gear_tweaks += new/datum/gear_tweak/path(suitjacket)

/datum/gear/accessory/shirt/
	display_name = "shirt selection"
	path = /obj/item/clothing/accessory/shirt/tshirtwhite

/datum/gear/accessory/shirt/New()
	..()
	var/tshirts = list()
	tshirts["tshirt, white"] = /obj/item/clothing/accessory/shirt/tshirtwhite
	tshirts["tshirt, grey"] = /obj/item/clothing/accessory/shirt/tshirtgrey
	tshirts["tshirt, black"] = /obj/item/clothing/accessory/shirt/tshirtblack
	tshirts["chemise, white"] = /obj/item/clothing/accessory/shirt/chemisewhite
	tshirts["longsleeve, white"] = /obj/item/clothing/accessory/shirt/whitelongsleeve
	tshirts["turtleneck, black"] = /obj/item/clothing/accessory/shirt/turtleneckblack
	tshirts["turtleneck, winter"] = /obj/item/clothing/accessory/shirt/turtleneckwinter
	tshirts["singlet, white"] = /obj/item/clothing/accessory/shirt/singletwhite
	tshirts["singlet, black"] = /obj/item/clothing/accessory/shirt/singletblack
	tshirts["sweater, pink"] = /obj/item/clothing/accessory/shirt/sweaterpink
	tshirts["sweater, blue"] = /obj/item/clothing/accessory/shirt/sweaterblue
	tshirts["sweater, blueh heart"] = /obj/item/clothing/accessory/shirt/sweaterblueheart
	tshirts["sweater, mint"] = /obj/item/clothing/accessory/shirt/sweatermint
	tshirts["sweater, NT"] = /obj/item/clothing/accessory/shirt/sweaternt
	tshirts["sweater, snowman"] = /obj/item/clothing/accessory/shirt/sweatersnow
	tshirts["sweater, chrismas tree"] = /obj/item/clothing/accessory/shirt/sweatertree
	tshirts["sweater, reindeer"] = /obj/item/clothing/accessory/shirt/sweaterreindeer
	gear_tweaks += new/datum/gear_tweak/path(tshirts)

/datum/gear/accessory/tshirtc
	display_name = "t-shirt, colorable"
	path = /obj/item/clothing/accessory/shirt/tshirt
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/chemisec
	display_name = "chemise, colorable"
	path = /obj/item/clothing/accessory/shirt/chemise
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/longsleevec
	display_name = "longsleeve shirt, colorable"
	path = /obj/item/clothing/accessory/shirt/longsleeve
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/singletc
	display_name = "singlet, colorable"
	path = /obj/item/clothing/accessory/shirt/singlet
	flags = GEAR_HAS_COLOR_SELECTION