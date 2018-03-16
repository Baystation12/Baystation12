
/datum/gear/accessory
	sort_category = "Accessories"
	category = /datum/gear/accessory
	slot = slot_tie

/datum/gear/accessory/tie
	display_name = "tie selection"
	path = /obj/item/clothing/accessory

/datum/gear/accessory/tie/New()
	..()
	var/ties = list()
	ties["blue tie"] = /obj/item/clothing/accessory/blue
	ties["red tie"] = /obj/item/clothing/accessory/red
	ties["blue tie, clip"] = /obj/item/clothing/accessory/blue_clip
	ties["red long tie"] = /obj/item/clothing/accessory/red_long
	ties["black tie"] = /obj/item/clothing/accessory/black
	ties["yellow tie"] = /obj/item/clothing/accessory/yellow
	ties["navy tie"] = /obj/item/clothing/accessory/navy
	ties["horrible tie"] = /obj/item/clothing/accessory/horrible
	ties["brown tie"] = /obj/item/clothing/accessory/brown
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/tie_color
	display_name = "colored tie"
	path = /obj/item/clothing/accessory
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/tie_color/New()
	..()
	var/ties = list()
	ties["tie"] = /obj/item/clothing/accessory
	ties["striped tie"] = /obj/item/clothing/accessory/long
	gear_tweaks += new/datum/gear_tweak/path(ties)

/datum/gear/accessory/corset_color
	display_name = "colored corset"
	path = /obj/item/clothing/accessory/corset
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/choker_color
	display_name = "colored choker"
	path = /obj/item/clothing/accessory/choker
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/vynilcorset
	display_name = "vinyl corset"
	path = /obj/item/clothing/accessory/vynilcorset

/datum/gear/accessory/locket
	display_name = "locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/accessory/necklace
	display_name = "necklace, colour select"
	path = /obj/item/clothing/accessory/necklace
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/bowtie
	display_name = "bowtie, horrible"
	path = /obj/item/clothing/accessory/bowtie/ugly

/datum/gear/accessory/bowtie/color
	display_name = "bowtie, colour select"
	path = /obj/item/clothing/accessory/bowtie/color
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/ntaward
	display_name = "NanoTrasen award selection"
	description = "A medal or ribbon awarded to NanoTrasen personnel for significant accomplishments."
	path = /obj/item/clothing/accessory/medal
	cost = 8

/datum/gear/accessory/ntaward/New()
	..()
	var/ntawards = list()
	ntawards["sciences medal"] = /obj/item/clothing/accessory/medal/bronze/nanotrasen
	ntawards["nanotrasen service"] = /obj/item/clothing/accessory/medal/silver/nanotrasen
	ntawards["command medal"] = /obj/item/clothing/accessory/medal/gold/nanotrasen
	gear_tweaks += new/datum/gear_tweak/path(ntawards)

//have to break up armbands to restrict access
/datum/gear/accessory/armband_security
	display_name = "security armband"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband_cargo
	display_name = "cargo armband"
	path = /obj/item/clothing/accessory/armband/cargo

/datum/gear/accessory/armband_medical
	display_name = "medical armband"
	path = /obj/item/clothing/accessory/armband/med

/datum/gear/accessory/armband_emt
	display_name = "EMT armband"
	path = /obj/item/clothing/accessory/armband/medgreen
	allowed_roles = list(/datum/job/doctor)

/datum/gear/accessory/armband_engineering
	display_name = "engineering armband"
	path = /obj/item/clothing/accessory/armband/engine

/datum/gear/accessory/armband_hydro
	display_name = "hydroponics armband"
	path = /obj/item/clothing/accessory/armband/hydro
	allowed_roles = list(/datum/job/rd, /datum/job/scientist, /datum/job/assistant)

/datum/gear/accessory/armband_nt
	display_name = "NanoTrasen armband"
	path = /obj/item/clothing/accessory/armband/whitered
