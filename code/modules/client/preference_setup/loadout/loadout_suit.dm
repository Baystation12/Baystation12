// Suit slot
/datum/gear/suit
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

/datum/gear/suit/leather
	display_name = "leather jackets"
	path = /obj/item/clothing/suit/storage/leather_jacket

/datum/gear/suit/leather/New()
	..()
	var/jackets = list()
	jackets["bomber jacket"] = /obj/item/clothing/suit/storage/toggle/bomber
	jackets["corporate black jacket"] = /obj/item/clothing/suit/storage/leather_jacket/nanotrasen
	jackets["corporate brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen
	jackets["black jacket"] = /obj/item/clothing/suit/storage/leather_jacket
	jackets["brown jacket"] = /obj/item/clothing/suit/storage/toggle/brown_jacket
	jackets["long coat"] = /obj/item/clothing/suit/leathercoat
	gear_tweaks += new/datum/gear_tweak/path(jackets)

/datum/gear/suit/hazard
	display_name = "hazard vests"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/suit/storage/hazardvest)

/datum/gear/suit/hoodie
	display_name = "hoodies"
	path = /obj/item/clothing/suit/storage/toggle/hoodie

/datum/gear/suit/hoodie/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/suit/storage/toggle/hoodie)

/datum/gear/suit/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/blue_labcoat
	display_name = "blue-edged labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue

/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/suit/poncho
	cost = 1

/datum/gear/suit/poncho/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/suit/poncho)

/datum/gear/suit/unathi_robe
	display_name = "roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1

/datum/gear/suit/suit_jacket
	display_name = "suit jackets"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket

/datum/gear/suit/suit_jacket/New()
	..()
	var/suitjackets = list()
	suitjackets["black suit jacket"] = /obj/item/clothing/suit/storage/toggle/internalaffairs/plain
	suitjackets["blue suit jacket"] = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket
	suitjackets["purple suit jacket"] = /obj/item/clothing/suit/storage/lawyer/purpjacket
	gear_tweaks += new/datum/gear_tweak/path(suitjackets)
