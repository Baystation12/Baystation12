/datum/gear/head
	path = /obj/item/clothing/head
	slot = slot_head
	sort_category = "Hats and Headwear"
	category = /datum/gear/head

/datum/gear/head/bandana
	allowed_roles = NON_MILITARY_ROLES

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
	gear_tweaks += new/datum/gear_tweak/path(berets)

/datum/gear/head/whitentberet
	display_name = "beret, NanoTrasen security"
	path = /obj/item/clothing/head/beret/guard
	allowed_roles = list("Security Guard")

/datum/gear/head/cap
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/head/hairflower
	allowed_roles = FORMAL_ROLES

/datum/gear/head/bow
	allowed_roles = FORMAL_ROLES

/datum/gear/head/hardhat
	allowed_roles = list("Chief Engineer", "Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist", "Deck Officer", "Deck Technician",
						"Supply Assistant", "Prospector", "Sanitation Technician", "Research Assistant", "Merchant")

/datum/gear/head/formalhat
	allowed_roles = FORMAL_ROLES

/datum/gear/head/informalhat
	path = /obj/item/clothing/head/cowboy_hat
	allowed_roles = SEMIFORMAL_ROLES

/datum/gear/head/welding
	allowed_roles = list("Senior Engineer", "Engineer", "Maintenance Assistant", "Roboticist", "Deck Officer", "Deck Technician",
						"Supply Assistant", "Prospector", "Research Assistant", "Merchant")

/datum/gear/head/solhat
	display_name = "Sol Central Government Cap"
	path = /obj/item/clothing/head/soft/sol
	allowed_roles = SOLGOV_ROLES
