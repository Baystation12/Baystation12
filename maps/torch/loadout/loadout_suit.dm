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

/datum/gear/suit/medcoat
	display_name = "medical suit selection"
	path = /obj/item/clothing/suit
	allowed_roles = MEDICAL_ROLES

/datum/gear/suit/medcoat/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path/specified_types_args(/obj/item/clothing/suit/storage/toggle/fr_jacket, /obj/item/clothing/suit/storage/toggle/labcoat/blue, /obj/item/clothing/suit/surgicalapron)

/datum/gear/suit/trenchcoat
	display_name = "trenchcoat selection"
	path = /obj/item/clothing/suit
	cost = 3
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/trenchcoat/New()
	..()
	var/trenchcoats = list()
	trenchcoats += /obj/item/clothing/suit/storage/det_trench
	trenchcoats += /obj/item/clothing/suit/storage/det_trench/grey
	trenchcoats += /obj/item/clothing/suit/leathercoat
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(trenchcoats)

/datum/gear/suit/poncho
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/roles/poncho/security
	allowed_roles = list(/datum/job/guard, /datum/job/merchant)

/datum/gear/suit/roles/poncho/medical
	allowed_roles = list(/datum/job/doctor_contractor, /datum/job/psychiatrist, /datum/job/merchant)

/datum/gear/suit/roles/poncho/engineering
	allowed_roles = list(/datum/job/engineer_contractor, /datum/job/roboticist, /datum/job/merchant)

/datum/gear/suit/roles/poncho/science
	allowed_roles = list(/datum/job/scientist, /datum/job/scientist_assistant, /datum/job/merchant)

/datum/gear/suit/roles/poncho/cargo
	allowed_roles = list(/datum/job/cargo_contractor, /datum/job/merchant)

/datum/gear/suit/suit_jacket
	display_name = "standard suit jackets"
	path = /obj/item/clothing/suit/storage/toggle/suit
	allowed_roles = FORMAL_ROLES

/datum/gear/suit/suit_jacket/New()
	..()
	var/suitjackets = list()
	suitjackets += /obj/item/clothing/suit/storage/toggle/suit/black
	suitjackets += /obj/item/clothing/suit/storage/toggle/suit/blue
	suitjackets += /obj/item/clothing/suit/storage/toggle/suit/purple
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(suitjackets)

/datum/gear/suit/custom_suit_jacket
	display_name = "suit jacket, colour select"
	path = /obj/item/clothing/suit/storage/toggle/suit
	allowed_roles = FORMAL_ROLES
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/hazard
	display_name = "hazard vests"
	path = /obj/item/clothing/suit/storage/hazardvest
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/hoodie
	display_name = "hoodie, colour select"
	path = /obj/item/clothing/suit/storage/hooded/hoodie
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/hoodie_sel
	display_name = "standard hoodies"
	path = /obj/item/clothing/suit/storage/toggle/hoodie
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/hoodie_sel/New()
	..()
	var/hoodies = list()
	hoodies += /obj/item/clothing/suit/storage/toggle/hoodie/cti
	hoodies += /obj/item/clothing/suit/storage/toggle/hoodie/mu
	hoodies += /obj/item/clothing/suit/storage/toggle/hoodie/nt
	hoodies += /obj/item/clothing/suit/storage/toggle/hoodie/smw
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(hoodies)

/datum/gear/suit/labcoat
	display_name = "labcoat, colour select"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = STERILE_ROLES

/datum/gear/suit/coat
	display_name = "coat, colour select"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/coat
	flags = GEAR_HAS_COLOR_SELECTION
	allowed_roles = FORMAL_ROLES

/datum/gear/suit/leather
	display_name = "jacket selection"
	path = /obj/item/clothing/suit
	allowed_roles = NON_MILITARY_ROLES

/datum/gear/suit/leather/New()
	..()
	var/jackets = list()
	jackets += /obj/item/clothing/suit/storage/toggle/bomber
	jackets += /obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	jackets += /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	jackets += /obj/item/clothing/suit/storage/leather_jacket
	jackets += /obj/item/clothing/suit/storage/toggle/brown_jacket
	jackets += /obj/item/clothing/suit/storage/mbill
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(jackets)

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/suit/poncho/colored
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/roles/poncho/security
	display_name = "poncho, security"
	path = /obj/item/clothing/suit/poncho/roles/security

/datum/gear/suit/roles/poncho/medical
	display_name = "poncho, medical"
	path = /obj/item/clothing/suit/poncho/roles/medical

/datum/gear/suit/roles/poncho/engineering
	display_name = "poncho, engineering"
	path = /obj/item/clothing/suit/poncho/roles/engineering

/datum/gear/suit/roles/poncho/science
	display_name = "poncho, science"
	path = /obj/item/clothing/suit/poncho/roles/science

/datum/gear/suit/roles/poncho/cargo
	display_name = "poncho, supply"
	path = /obj/item/clothing/suit/poncho/roles/cargo

/datum/gear/suit/wintercoat
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat
	allowed_roles = RESTRICTED_ROLES

/datum/gear/suit/track
	display_name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track
	allowed_roles = RESTRICTED_ROLES
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/pcarrier
	display_name = "plate carrier selection"
	path = /obj/item/clothing/suit/armor/pcarrier
	cost = 1
	allowed_roles = ARMORED_ROLES

/datum/gear/suit/pcarrier/New()
	..()
	var/armors = list()
	armors += /obj/item/clothing/suit/armor/pcarrier/green
	armors += /obj/item/clothing/suit/armor/pcarrier/navy
	armors += /obj/item/clothing/suit/armor/pcarrier/tan
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(armors)
