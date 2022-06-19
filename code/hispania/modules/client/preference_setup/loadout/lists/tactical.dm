/datum/gear/tactical
	sort_category = "Equipo Tactico"
	category = /datum/gear/tactical
	slot = slot_tie

/datum/gear/tactical/armor_deco
	display_name = "armadura personalizada"
	path = /obj/item/clothing/accessory/armor_tag
	flags = GEAR_HAS_SUBTYPE_SELECTION | GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/tactical/helm_covers
	display_name = "cubiertas de casco"
	path = /obj/item/clothing/accessory/helmet_cover
	flags = GEAR_HAS_SUBTYPE_SELECTION | GEAR_HAS_NO_CUSTOMIZATION

/datum/gear/tactical/kneepads
	display_name = "rodilleras"
	path = /obj/item/clothing/accessory/kneepads

/datum/gear/tactical/holster
	display_name = "seleccion de funda"
	path = /obj/item/clothing/accessory/storage/holster
	cost = 3

/datum/gear/tactical/sheath
	display_name = "vaina de machete"
	path = /obj/item/clothing/accessory/storage/holster/machete

/datum/gear/tactical/knife_sheath
	display_name = "seleccion de vaina de cuchillo"
	description = "Una funda de cuchillo atada a la pierna."
	path = /obj/item/clothing/accessory/storage/holster/knife
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/tactical/tacticool
	display_name = "cuello alto tacticool"
	path = /obj/item/clothing/under/syndicate/tacticool
	slot = slot_w_uniform
