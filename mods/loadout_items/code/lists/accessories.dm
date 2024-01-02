/datum/gear/accessory/solgov_ec_rank
	display_name = "Expeditionary Corps rank badges selection"
	description = "An insignia denoting wearer's rank within the SCG Expeditionary Corps."
	path = /obj/item/clothing/accessory
	allowed_branches = list(/datum/mil_branch/contractor)
	allowed_factions = list(FACTION_EXPEDITIONARY, FACTION_CORPORATE)

/datum/gear/accessory/solgov_ec_rank/New()
	..()
	var/solgovranks = list()
	solgovranks["ranks (E-1 apprentice explorer)"] = /obj/item/clothing/accessory/solgov/rank/ec/enlisted
	solgovranks["ranks (E-3 explorer)"] = /obj/item/clothing/accessory/solgov/rank/ec/enlisted/e3
	solgovranks["ranks (E-5 senior explorer)"] = /obj/item/clothing/accessory/solgov/rank/ec/enlisted/e5
	solgovranks["ranks (O-1 ensign)"] = /obj/item/clothing/accessory/solgov/rank/ec/officer
	gear_tweaks += new/datum/gear_tweak/path(solgovranks)

// Cosmetics

/datum/gear/brush
	display_name = "hairbrush"
	path = /obj/item/haircomb/brush
	sort_category = "Cosmetics"

/datum/gear/deodorant
	display_name = "deodorant"
	path = /obj/item/reagent_containers/spray/cleaner/deodorant
	sort_category = "Cosmetics"

/datum/gear/lipstick
	display_name = "lipstick selection"
	path = /obj/item/lipstick
	sort_category = "Cosmetics"
	flags = GEAR_HAS_TYPE_SELECTION

/datum/gear/comb
	display_name = "plastic comb"
	path = /obj/item/haircomb
	sort_category = "Cosmetics"
	flags = GEAR_HAS_COLOR_SELECTION

// Assorted accessories

/datum/gear/corset
	display_name = "corset selection"
	path = /obj/item/clothing/accessory/corset
	sort_category = "Clothing Pieces"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/vinylcorset
	display_name = "vinyl corset"
	path = /obj/item/clothing/accessory/corset/vinyl
	sort_category = "Clothing Pieces"

/datum/gear/choker
	display_name = "choker selection"
	path = /obj/item/clothing/accessory/choker
	sort_category = "Clothing Pieces"
	flags = GEAR_HAS_COLOR_SELECTION

/datum/gear/accessory/collar
	display_name = "collar selection"
	path = /obj/item/clothing/accessory/necklace/collar

/datum/gear/accessory/collar/New()
	..()
	var/collar = list()
	collar["gold collar"] = /obj/item/clothing/accessory/necklace/collar/gold
	collar["bell collar"] = /obj/item/clothing/accessory/necklace/collar/bell
	collar["spike collar"] = /obj/item/clothing/accessory/necklace/collar/spike
	collar["pink collar"] = /obj/item/clothing/accessory/necklace/collar/pink
	collar["holo collar"] = /obj/item/clothing/accessory/necklace/collar/holo
	gear_tweaks += new/datum/gear_tweak/path(collar)

// Press

/datum/gear/accessory/pressbadge
	display_name = "corporate press pass"
	path = /obj/item/clothing/accessory/badge/press

/datum/gear/accessory/pressbadge
	display_name = "freelance press pass"
	path = /obj/item/clothing/accessory/badge/press/independent

/datum/gear/accessory/scarf_fancy
	display_name = "special scarfs selection"
	path = /obj/item/clothing/accessory/scarf/fancy

/datum/gear/accessory/scarf_fancy/New()
	..()
	var/scarf = list()
	scarf["red striped scarf"] = /obj/item/clothing/accessory/scarf/fancy
	scarf["green striped scarf"] = /obj/item/clothing/accessory/scarf/fancy/green
	scarf["blue striped scarf"] = /obj/item/clothing/accessory/scarf/fancy/blue
	scarf["zebra scarf"] = /obj/item/clothing/accessory/scarf/fancy/zebra
	scarf["christmas scarf"] = /obj/item/clothing/accessory/scarf/fancy/christmas
	gear_tweaks += new/datum/gear_tweak/path(scarf)
