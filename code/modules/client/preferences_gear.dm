var/global/list/gear_datums = list()

proc/populate_gear_list()
	for(var/type in typesof(/datum/gear)-/datum/gear)
		var/datum/gear/G = new type()
		gear_datums[G.display_name] = G

/datum/gear
	var/display_name       //Name/index.
	var/path               //Path to item.
	var/cost               //Number of points used.
	var/slot               //Slot to equip to.
	var/list/allowed_roles //Roles that can spawn with this item.

//Standard gear datums.
/datum/gear/tie_horrible
	display_name = "horrible tie"
	path = /obj/item/clothing/tie/horrible
	cost = 2

/datum/gear/hairflower
	display_name = "hair flower pin"
	path = /obj/item/clothing/head/hairflower
	cost = 1
	slot = SLOT_HEAD

/datum/gear/bandana
	display_name = "pirate bandana"
	path = /obj/item/clothing/head/bandana
	cost = 1
	slot = SLOT_HEAD

/datum/gear/overalls
	display_name = "overalls"
	path = /obj/item/clothing/suit/apron/overalls
	cost = 1
	slot = SLOT_OCLOTHING

/datum/gear/wcoat
	display_name = "waistcoat"
	path = /obj/item/clothing/suit/wcoat
	cost = 1
	slot = SLOT_OCLOTHING

/datum/gear/prescription
	display_name = "prescription sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/prescription
	cost = 2
	slot = SLOT_EYES

/datum/gear/eyepatch
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	cost = 1
	slot = SLOT_EYES

/datum/gear/flatcap
	display_name = "flat cap"
	path = /obj/item/clothing/head/flatcap
	cost = 1
	slot = SLOT_HEAD

/datum/gear/labcoat
	display_name = "labcoat"
	path = /obj/item/clothing/suit/storage/labcoat
	cost = 2
	slot = SLOT_OCLOTHING

/datum/gear/sandal
	display_name = "sandals"
	path = /obj/item/clothing/shoes/sandal
	cost = 1
	slot = SLOT_FEET

/datum/gear/leather
	display_name = "leather shoes"
	path = /obj/item/clothing/shoes/leather
	cost = 1
	slot = SLOT_FEET

/datum/gear/dress_shoes
	display_name = "dress shoes"
	path = /obj/item/clothing/shoes/centcom
	cost = 1
	slot = SLOT_FEET

//Security
/datum/gear/security
	display_name = "Security HUD"
	path = /obj/item/clothing/glasses/hud/security
	cost = 1
	slot = SLOT_EYES
	allowed_roles = list("Security Officer","Head of Security","Warden")

/datum/gear/sec_beret
	display_name = "security beret"
	path = /obj/item/clothing/head/beret/sec
	cost = 1
	slot = SLOT_HEAD
	allowed_roles = list("Security Officer","Head of Security","Warden")

//Engineering
/datum/gear/eng_beret
	display_name = "engineering beret"
	path = /obj/item/clothing/head/beret/eng
	cost = 1
	slot = SLOT_HEAD
	allowed_roles = list("Station Engineering","Atmospheric Technician","Chief Engineer")

//Species-specific gear datums.
/datum/gear/zhan_furs
	display_name = "Zhan-Khazan furs"
	path = /obj/item/clothing/suit/tajaran/furs
	cost = 3

/datum/gear/zhan_scarf
	display_name = "Zhan-Khazan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	cost = 2

/datum/gear/unathi_robe
	display_name = "roughspun robe"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 3
	slot = SLOT_OCLOTHING

/datum/gear/unathi_mantle
	display_name = "hide mantle"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 2
	slot = SLOT_OCLOTHING