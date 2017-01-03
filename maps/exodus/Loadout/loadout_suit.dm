// Suit slot

/datum/gear/suit
	display_name = "apron, blue"
	path = /obj/item/clothing/suit/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 1


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
	display_name = "hoodie"
	path = /obj/item/clothing/suit/storage/toggle/hoodie
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/suit/blue_labcoat
	display_name = "blue-edged labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue

/* coveralls redefined in Eros
/datum/gear/suit/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
*/

/datum/gear/suit/poncho
	display_name = "poncho selection"
	path = /obj/item/clothing/suit/poncho/colored
	cost = 1

/datum/gear/suit/poncho/New()
	..()
	gear_tweaks += new/datum/gear_tweak/path(/obj/item/clothing/suit/poncho/colored)

/datum/gear/suit/roles/poncho/security
	display_name = "poncho, security"
	path = /obj/item/clothing/suit/poncho/roles/security
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/suit/roles/poncho/medical
	display_name = "poncho, medical"
	path = /obj/item/clothing/suit/poncho/roles/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/suit/roles/poncho/engineering
	display_name = "poncho, engineering"
	path = /obj/item/clothing/suit/poncho/roles/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Station Engineer")

/datum/gear/suit/roles/poncho/science
	display_name = "poncho, science"
	path = /obj/item/clothing/suit/poncho/roles/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/suit/roles/poncho/cargo
	display_name = "poncho, cargo"
	path = /obj/item/clothing/suit/poncho/roles/cargo
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/suit/roles/surgical_apron
	display_name = "surgical apron"
	path = /obj/item/clothing/suit/surgicalapron
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

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

//EROS START

/datum/gear/suit/flannel
	display_name = "grey flannel"
	path = /obj/item/clothing/suit/storage/flannel

/datum/gear/suit/flannel/red
	display_name = "red flannel"
	path = /obj/item/clothing/suit/storage/flannel/red

/datum/gear/suit/flannel/aqua
	display_name = "aqua flannel"
	path = /obj/item/clothing/suit/storage/flannel/aqua

/datum/gear/suit/colonel
	display_name = "colonels jacket"
	path = /obj/item/clothing/suit/storage/colonel

/datum/gear/suit/wintercoat
	display_name = "winter coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/wintercoat/captain
	display_name = "winter coat, captain"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	allowed_roles = list("Captain")

/datum/gear/suit/wintercoat/security
	display_name = "winter coat, security"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/suit/wintercoat/medical
	display_name = "winter coat, medical"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist")

/datum/gear/suit/wintercoat/science
	display_name = "winter coat, science"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/suit/wintercoat/engineering
	display_name = "winter coat, engineering"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Station Engineer")

/datum/gear/suit/wintercoat/atmos
	display_name = "winter coat, atmospherics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician", "Station Engineer")

/datum/gear/suit/wintercoat/hydro
	display_name = "winter coat, hydroponics"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	allowed_roles = list("Gardener", "Xenobiologist")

/datum/gear/suit/wintercoat/cargo
	display_name = "winter coat, cargo"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/suit/wintercoat/miner
	display_name = "winter coat, mining"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	allowed_roles = list("Shaft Miner")

/datum/gear/suit/track
	display_name = "track jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new/datum/gear_tweak/path(sortAssoc(tracks))

/datum/gear/suit/leather_jacket_alt
	display_name = "leather jacket 2, black"
	path = /obj/item/clothing/suit/storage/leather_jacket/alt

/datum/gear/suit/waistcoat/red
	display_name = "waistcoat, red"
	path = /obj/item/clothing/suit/wcoat/red
	cost = 1

/datum/gear/suit/waistcoat/gray
	display_name = "waistcoat, gray"
	path = /obj/item/clothing/suit/wcoat/gray
	cost = 1

/datum/gear/suit/waistcoat/brown
	display_name = "waistcoat, brown"
	path = /obj/item/clothing/suit/wcoat/brown
	cost = 1

/datum/gear/suit/jacket/puffer
	display_name = "puffer jacket"
	path = /obj/item/clothing/suit/jacket/puffer

/datum/gear/suit/jacket/puffer/vest
	display_name = "puffer vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/gear/suit/storage/miljacket
	display_name = "military jacket"
	path = /obj/item/clothing/suit/storage/miljacket

/datum/gear/suit/storage/miljacket/alt
	display_name = "military jacket, alternate"
	path = /obj/item/clothing/suit/storage/miljacket/alt

/datum/gear/suit/storage/miljacket/green
	display_name = "military jacket, green"
	path = /obj/item/clothing/suit/storage/miljacket/green

/datum/gear/suit/storage/jacket/brown
	display_name = "jacket, brown"
	path = /obj/item/clothing/suit/storage/brownjacket

/datum/gear/suit/storage/jacket/black
	display_name = "jacket, black"
	path = /obj/item/clothing/suit/storage/blackjacket

/datum/gear/suit/storage/jacket/shipping
	display_name = "jacket, shipping"
	path = /obj/item/clothing/suit/storage/shipping

/datum/gear/suit/apron/overalls
	display_name = "overalls selection"
	path = /obj/item/clothing/suit/apron/overalls

/datum/gear/suit/apron/overalls/New()
	..()
	var/overall = list()
	overall["coveralls"] = /obj/item/clothing/suit/apron/overalls
	overall["brown overalls"] = /obj/item/clothing/suit/apron/overalls/brown
	overall["electrician overalls"] = /obj/item/clothing/suit/apron/overalls/electrician
	overall["emergency overalls"] = /obj/item/clothing/suit/apron/overalls/emergency
	gear_tweaks += new/datum/gear_tweak/path(overall)

/datum/gear/suit/storage/factoryvest
	display_name = "factory worker's vest"
	path = /obj/item/clothing/suit/storage/factoryvest
	cost = 2

/datum/gear/suit/storage/factoryapron
	display_name = "factory worker's apron"
	path = /obj/item/clothing/suit/storage/factoryapron
	cost = 2

//EROS FINISH
