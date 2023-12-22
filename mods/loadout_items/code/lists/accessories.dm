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
	solgovranks["ranks (E-7 chief explorer)"] = /obj/item/clothing/accessory/solgov/rank/ec/enlisted/e7
	solgovranks["ranks (O-1 ensign)"] = /obj/item/clothing/accessory/solgov/rank/ec/officer
	solgovranks["ranks (O-3 lieutenant)"] = /obj/item/clothing/accessory/solgov/rank/ec/officer/o3
	gear_tweaks += new/datum/gear_tweak/path(solgovranks)
