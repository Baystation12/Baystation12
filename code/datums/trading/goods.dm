/datum/trader/ship/collector
	name = "The Collector"
	origin = "ISS Romulon"

	trade_goods = 0
	trade_wanted_only = 1
	possible_wanted_items = list(/obj/item/toy/figure                            = TRADER_ALL,
	                             /obj/item/toy/prize                             = TRADER_SUBTYPES_ONLY,
	                             /obj/item/toy/plushie                           = TRADER_SUBTYPES_ONLY
	                             )