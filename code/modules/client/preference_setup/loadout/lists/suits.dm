/datum/gear/suit
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	category = /datum/gear/suit

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/suit/poncho/colored
	cost = 1
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/security_poncho
	display_name = "poncho, security"
	path = /obj/item/clothing/suit/poncho/roles/security

/datum/gear/suit/medical_poncho
	display_name = "poncho, medical"
	path = /obj/item/clothing/suit/poncho/roles/medical

/datum/gear/suit/engineering_poncho
	display_name = "poncho, engineering"
	path = /obj/item/clothing/suit/poncho/roles/engineering

/datum/gear/suit/science_poncho
	display_name = "poncho, science"
	path = /obj/item/clothing/suit/poncho/roles/science

/datum/gear/suit/nanotrasen_poncho
	display_name = "poncho, NanoTrasen"
	path = /obj/item/clothing/suit/poncho/roles/science/nanotrasen

/datum/gear/suit/cargo_poncho
	display_name = "poncho, supply"
	path = /obj/item/clothing/suit/poncho/roles/cargo

/datum/gear/suit/suit_jacket
	display_name = "standard suit jackets"
	path = /obj/item/clothing/suit/storage/toggle/suit

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
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/custom_suit_jacket_double
	display_name = "suit jacket (double-breasted), colour select"
	path = /obj/item/clothing/suit/storage/toggle/suit_double
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/hazard
	display_name = "hazard vests"
	path = /obj/item/clothing/suit/storage/hazardvest
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/highvis
	display_name = "high-visibility jacket"
	path = /obj/item/clothing/suit/storage/toggle/highvis

/datum/gear/suit/hoodie
	display_name = "hoodie, colour select"
	path = /obj/item/clothing/suit/storage/hooded/hoodie
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/hoodie_sel
	display_name = "standard hoodies"
	path = /obj/item/clothing/suit/storage/toggle/hoodie

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

/datum/gear/suit/labcoat_blue
	display_name = "blue trimmed labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue

/datum/gear/suit/labcoat_corp
	display_name = "labcoat, corporate colors"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/science
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/coat
	display_name = "coat, colour select"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/coat
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/leather
	display_name = "jacket selection"
	path = /obj/item/clothing/suit

/datum/gear/suit/leather/New()
	..()
	var/jackets = list()
	jackets += /obj/item/clothing/suit/storage/toggle/bomber
	jackets += /obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	jackets += /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	jackets += /obj/item/clothing/suit/storage/leather_jacket
	jackets += /obj/item/clothing/suit/storage/toggle/brown_jacket
	jackets += /obj/item/clothing/suit/storage/mbill
	jackets += /obj/item/clothing/suit/storage/toggle/leather_hoodie
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(jackets)

/datum/gear/suit/wintercoat
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/wintercoat_dais
	display_name = "winter coat, DAIS"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/dais

/datum/gear/suit/track
	display_name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/suit/blueapron
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	cost = 1

/datum/gear/suit/overalls
	display_name = "apron, overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1

/datum/gear/suit/medcoat
	display_name = "medical suit selection"
	path = /obj/item/clothing/suit

/datum/gear/suit/medcoat/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path/specified_types_args(/obj/item/clothing/suit/storage/toggle/fr_jacket, /obj/item/clothing/suit/storage/toggle/fr_jacket/ems, /obj/item/clothing/suit/surgicalapron, /obj/item/clothing/suit/storage/toggle/fr_jacket/emrs)

/datum/gear/suit/trenchcoat
	display_name = "trenchcoat selection"
	path = /obj/item/clothing/suit
	cost = 3

/datum/gear/suit/trenchcoat/New()
	..()
	var/trenchcoats = list()
	trenchcoats += /obj/item/clothing/suit/storage/det_trench
	trenchcoats += /obj/item/clothing/suit/storage/det_trench/grey
	trenchcoats += /obj/item/clothing/suit/leathercoat
	gear_tweaks += new/datum/gear_tweak/path/specified_types_list(trenchcoats)


/datum/gear/suit/pullover
	display_name = "sweater, pullover"
	path = /obj/item/clothing/suit/storage/pullover


/datum/gear/suit/zipper
	display_name = "sweater, zip up"
	path = /obj/item/clothing/suit/storage/toggle/zipper
