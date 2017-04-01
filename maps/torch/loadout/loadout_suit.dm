// Suit slot
/datum/gear/suit
	display_name = "labcoat, plain"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

/datum/gear/suit/blueapron
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	cost = 1
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/suit/overalls
	display_name = "apron, overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/suit/leather
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/suit/hoodie
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/hoodie_sel
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/labcoat
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/suit/medcoat
	display_name = "medical suit selection"
	path = /obj/item/clothing/suit/storage/toggle/fr_jacket
	allowed_roles = MEDICAL_ROLES

/datum/gear/suit/medcoat/New()
	..()
	var/medcoats = list()
	medcoats["jacket, first responder"] = /obj/item/clothing/suit/storage/toggle/fr_jacket
	medcoats["labcoat, medical"] = /obj/item/clothing/suit/storage/toggle/labcoat/blue
	medcoats["apron, surgical"] = /obj/item/clothing/suit/surgicalapron
	gear_tweaks += new/datum/gear_tweak/path(medcoats)

/datum/gear/suit/trenchcoat
	display_name = "trenchcoat selection"
	path = /obj/item/clothing/suit/storage/det_trench
	cost = 3
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/trenchcoat/New()
	..()
	var/trenchcoats = list()
	trenchcoats["trenchcoat, brown"] = /obj/item/clothing/suit/storage/det_trench
	trenchcoats["trenchcoat, grey"] = /obj/item/clothing/suit/storage/det_trench/grey
	trenchcoats["coat, duster"] = /obj/item/clothing/suit/leathercoat
	gear_tweaks += new/datum/gear_tweak/path(trenchcoats)

/datum/gear/suit/poncho
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/roles/poncho/security
	allowed_roles = list("Security Guard", "Merchant")

/datum/gear/suit/roles/poncho/medical
	allowed_roles = list("Medical Contractor", "Chemist", "Counselor", "Merchant")

/datum/gear/suit/roles/poncho/engineering
	allowed_roles = list("Maintenance Assistant", "Roboticist", "Merchant")

/datum/gear/suit/roles/poncho/science
	allowed_roles = list("Scientist", "Research Assistant", "Merchant")

/datum/gear/suit/roles/poncho/cargo
	allowed_roles = list("Supply Assistant", "Merchant")

/datum/gear/suit/suit_jacket
	allowed_roles = FORMAL_ROLES

/datum/gear/suit/wintercoat
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/track
	allowed_roles = RESTRICTED_ROLES