/datum/gear/tactical
	sort_category = "Tactical Equipment"
	category = /datum/gear/tactical
	slot = slot_tie

/datum/gear/tactical/helm_covers
	display_name = "helmet covers"
	path = /obj/item/clothing/accessory/helmet_cover
	flags = GEAR_HAS_SUBTYPE_SELECTION

/datum/gear/tactical/kneepads
	display_name = "kneepads"
	path = /obj/item/clothing/accessory/kneepads

/datum/gear/tactical/holster
	display_name = "holster selection"
	path = /obj/item/clothing/accessory/storage/holster
	cost = 3

/datum/gear/tactical/sheath
	display_name = "machete sheath"
	path = /obj/item/clothing/accessory/storage/holster/machete

/datum/gear/tactical/knife_sheath
	display_name = "knife sheath selection"
	description = "A leg strapped knife sheath."
	path = /obj/item/clothing/accessory/storage/holster/knife
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/tactical/tacticool
	display_name = "tacticool turtleneck"
	path = /obj/item/clothing/under/syndicate/tacticool
	slot = slot_w_uniform

//proxima code start
/datum/gear/tactical/gorka
	display_name = "gorka selection"
	path = /obj/item/clothing/under/gorka

/datum/gear/tactical/gorka/New()
	..()
	var/gorka = list()
	gorka["light gorka uniform"] = /obj/item/clothing/under/gorka
	gorka["old gorka uniform"] = /obj/item/clothing/under/gorka/old
	gorka["gorka camouflage uniform"] = /obj/item/clothing/under/gorka/ss
	gorka["tan gorka uniform"] = /obj/item/clothing/under/gorka/tan
	gear_tweaks += new/datum/gear_tweak/path(gorka)

/datum/gear/tactical/gorka_jacket
	display_name = "gorka jacket selection"
	path = /obj/item/clothing/suit/storage/toggle/gorka_jacket

/datum/gear/tactical/gorka_jacket/New()
	..()
	var/gorka_jacket = list()
	gorka_jacket["light gorka jacket"] = /obj/item/clothing/suit/storage/toggle/gorka_jacket
	gorka_jacket["old gorka jacket"] = /obj/item/clothing/suit/storage/toggle/gorka_jacket/old
	gorka_jacket["camouflage gorka jacket"] = /obj/item/clothing/suit/storage/toggle/gorka_jacket/ss
	gorka_jacket["tan gorka jacket"] = /obj/item/clothing/suit/storage/toggle/gorka_jacket/tan
	gear_tweaks += new/datum/gear_tweak/path(gorka_jacket)

/datum/gear/tactical/bdu
	display_name = "BDU selection"
	path = /obj/item/clothing/under/bdu

/datum/gear/tactical/bdu/New()
	..()
	var/bdu = list()
	bdu["bdu uniform"] = /obj/item/clothing/under/bdu
	bdu["tan bdu uniform"] = /obj/item/clothing/under/bdu/tan
	bdu["black bdu uniform"] = /obj/item/clothing/under/bdu/black
	bdu["grey bdu uniform"] = /obj/item/clothing/under/bdu/grey
	bdu["camo bdu uniform"] = /obj/item/clothing/under/bdu/camo
	bdu["green-black bdu uniform"] = /obj/item/clothing/under/bdu/utt
	gear_tweaks += new/datum/gear_tweak/path(bdu)

//proxima code end
