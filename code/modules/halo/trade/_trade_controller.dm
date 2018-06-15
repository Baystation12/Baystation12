var/global/datum/controller/process/trade_controller/trade_controller

/datum/controller/process/trade_controller
	var/list/trade_items = list()
	var/list/trade_items_by_type = list()
	var/list/trade_categories  = list()
	var/list/trade_categories_by_name = list()

/datum/controller/process/trade_controller/New()
	..()
	if(!trade_controller)
		trade_controller = src

/datum/controller/process/trade_controller/setup()

	for(var/category_type in typesof(/datum/trade_category) - /datum/trade_category)
		var/datum/trade_category/C = new category_type()
		trade_categories.Add(C)
		trade_categories_by_name[C.name] = C

	for(var/item_type in typesof(/datum/trade_item) - /datum/trade_item)
		var/datum/trade_item/I = new item_type()
		trade_items.Add(I)
		trade_items_by_type[I.item_type] = I

		var/datum/trade_category/C = trade_categories_by_name[I.category]
		if(C)
			C.trade_items.Add(I)
			C.trade_items_by_type[I.item_type] = I
			C.total_weighting += I.trader_weight

/datum/controller/process/trade_controller/proc/get_trade_category(var/category)
	return trade_categories_by_name[category]

/datum/controller/process/trade_controller/proc/get_trade_item(var/item_type)
	return trade_items_by_type[item_type]

/datum/controller/process/trade_controller/proc/get_item_category(var/obj/O)
	if(O.trader_category)
		return O.trader_category
