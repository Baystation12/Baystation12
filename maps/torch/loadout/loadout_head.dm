/datum/gear/head
	path = /obj/item/clothing/head
	slot = slot_head
	sort_category = "Hats and Headwear"
	category = /datum/gear/head

/datum/gear/head/beret
	allowed_roles = NON_MILITARY_ROLES
	display_name = "beret, colored"
	path = /obj/item/clothing/head/beret/plaincolor
	flags = GEAR_HAS_COLOR_SELECTION
	description = "A simple, solid color beret. This one has no emblems or insignia on it."

/datum/gear/head/solberet
	display_name = "SolGov beret selection"
	description = "A beret denoting service in an organization within SolGov."
	path = /obj/item/clothing/head/beret/sol
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/solberet/New()
	..()
	var/berets = list()
	berets["peacekeeper beret"] = /obj/item/clothing/head/beret/sol
	berets["home guard beret"] = /obj/item/clothing/head/beret/sol/homeguard
	berets["gateway administration beret"] = /obj/item/clothing/head/beret/sol/gateway
	berets["customs and trade beret"] = /obj/item/clothing/head/beret/sol/customs
	berets["orbital assault beret"] = /obj/item/clothing/head/beret/sol/orbital
	berets["government research beret"] = /obj/item/clothing/head/beret/sol/research
	berets["health service beret"] = /obj/item/clothing/head/beret/sol/health
	berets["diplomatic security beret"] = /obj/item/clothing/head/beret/sol/diplomatic
	berets["border security beret"] = /obj/item/clothing/head/beret/sol/borderguard
	gear_tweaks += new/datum/gear_tweak/path(berets)

/datum/gear/head/whitentberet
	display_name = "beret, NanoTrasen security"
	path = /obj/item/clothing/head/beret/guard
	allowed_roles = list(/datum/job/guard)

/datum/gear/head/solhat
	display_name = "Sol Central Government Cap"
	path = /obj/item/clothing/head/soft/sol
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/veteranhat
	display_name = "veteran hat"
	path = /obj/item/clothing/head/soft/veteranhat
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/bandana
	display_name = "bandana selection"
	path = /obj/item/clothing/head
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/bandana/New()
	..()
	var/bandanas = list()
	bandanas["green bandana"] = /obj/item/clothing/head/greenbandana
	bandanas["orange bandana"] = /obj/item/clothing/head/orangebandana
	bandanas["pirate bandana"] = /obj/item/clothing/head/bandana
	gear_tweaks += new/datum/gear_tweak/path(bandanas)

/datum/gear/head/bow
	display_name = "hair bow"
	path = /obj/item/clothing/head/hairflower/bow
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/cap
	display_name = "cap selection"
	path = /obj/item/clothing/head
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/hairflower
	allowed_roles = FORMAL_ROLES

/datum/gear/head/bow
	allowed_roles = FORMAL_ROLES

/datum/gear/head/hardhat
	allowed_roles = TECHNICAL_ROLES

/datum/gear/head/formalhat
<<<<<<< HEAD
	display_name = "formal hat selection"
	path = /obj/item/clothing/head
=======
>>>>>>> Apollo-Dev
	allowed_roles = FORMAL_ROLES

/datum/gear/head/informalhat
<<<<<<< HEAD
	display_name = "informal hat selection"
	path = /obj/item/clothing/head
=======
	path = /obj/item/clothing/head/cowboy_hat
>>>>>>> Apollo-Dev
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/head/welding
	allowed_roles = TECHNICAL_ROLES

/datum/gear/head/solhat
	display_name = "Sol Central Government Cap"
	path = /obj/item/clothing/head/soft/sol
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/fleethat
	display_name = "Fleet Cap"
	path = /obj/item/clothing/head/utility/fleet
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/marinehat
	display_name = "Marine Cap"
	path = /obj/item/clothing/head/utility/marine
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/echat
	display_name = "EC Cap"
	path = /obj/item/clothing/head/soft/sol/expedition
	cost = 0
	allowed_roles = SOLGOV_ROLES

/datum/gear/head/surgical
	display_name = "surgical cap"
	path = /obj/item/clothing/head/surgery
	allowed_roles = STERILE_ROLES

/datum/gear/head/surgical/New()
	..()
	var/capcolor = list()
	capcolor["black cap"] = /obj/item/clothing/head/surgery/black
	capcolor["blue cap"] = /obj/item/clothing/head/surgery/blue
	capcolor["green cap"] = /obj/item/clothing/head/surgery/green
	capcolor["navy blue cap"] = /obj/item/clothing/head/surgery/navyblue
	capcolor["purple cap"] = /obj/item/clothing/head/surgery/purple
	gear_tweaks += new/datum/gear_tweak/path(capcolor)

/datum/gear/head/veteranhat
	display_name = "veteran hat"
	path = /obj/item/clothing/head/soft/veteranhat
	allowed_roles = NON_MILITARY_ROLES

