
/obj
	var/trader_category = ""

/datum/trade_category
	var/name
	var/list/trade_items = list()
	var/list/trade_items_by_type = list()
	var/total_weighting = 0

/datum/trade_category/weapon
	name = "weapon"

/datum/trade_category/innie
	name = "innie"

/datum/trade_category/weapon_unsc
	name = "weapon_unsc"

/datum/trade_category/crops
	name = "crops"

/datum/trade_category/ore
	name = "ore"
