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
